import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:bella_baxter/src/api.dart';
import 'package:bella_baxter/src/e2ee.dart';
import 'package:bella_baxter/src/model/project_response.dart';
import 'package:bella_baxter/src/model/get_project_response.dart';
import 'package:bella_baxter/src/model/environment_response.dart';
import 'package:bella_baxter/src/model/key_context_response.dart';

export 'package:bella_baxter/bella_baxter.dart';

/// Contract for persisting secrets locally between app launches.
///
/// Implement this to provide encrypted storage — the Dart SDK ships no
/// concrete implementation so it stays free of platform-specific dependencies.
///
/// For Flutter apps use [FlutterSecureSecretCache] from your app or the
/// `bella_baxter_flutter` package (backed by `flutter_secure_storage`).
///
/// ```dart
/// final client = BellaClient(BellaClientOptions(
///   baseUrl: '...',
///   apiKey: '...',
///   cache: FlutterSecureSecretCache(),  // ← inject here
/// ));
/// ```
abstract class SecretCache {
  /// Returns the last cached secrets, or `null` if nothing is stored yet.
  Future<Map<String, String>?> read();

  /// Persists [secrets] (called after every successful [BellaClient.pullSecrets]).
  Future<void> write(Map<String, String> secrets);

  /// Removes the cached secrets (e.g. on logout or API key rotation).
  Future<void> clear();
}

/// Options for initializing a [BellaClient].
///
/// Provide exactly one of [apiKey] or [accessToken]:
/// - [apiKey]: HMAC-signed auth (`bax-<keyId>-<signingSecret>` format).
/// - [accessToken]: Bearer JWT auth (injected by `bella sdk run` in SSO/OAuth mode).
class BellaClientOptions {
  /// The base URL of the Bella Baxter API.
  /// Defaults to `'https://api.bella-baxter.io'` (hosted cloud).
  /// Override for self-hosted deployments.
  final String baseUrl;

  /// API key in `bax-<keyId>-<signingSecretHex>` format.
  /// Mutually exclusive with [accessToken].
  final String? apiKey;

  /// Short-lived JWT access token.
  /// Injected as `BELLA_BAXTER_ACCESS_TOKEN` by `bella sdk run` in SSO mode.
  /// Mutually exclusive with [apiKey].
  final String? accessToken;

  /// Optional app name sent as `X-App-Client` header for audit logs.
  /// Falls back to the `BELLA_BAXTER_APP_CLIENT` env var.
  final String? appClient;

  /// Connection timeout (default: 10 seconds).
  final Duration connectTimeout;

  /// Receive timeout (default: 30 seconds).
  final Duration receiveTimeout;

  /// Optional encrypted cache.
  ///
  /// When provided:
  /// - After every successful [BellaClient.pullSecrets] the result is written.
  /// - If a fetch fails and [BellaClient.pullSecrets] would return `{}`, the
  ///   last cached value is returned instead (offline-first).
  final SecretCache? cache;

  /// Optional PKCS#8 DER bytes for ZKE (Zero-Knowledge Encryption) mode.
  ///
  /// When set, the E2EE layer uses this **persistent device key** instead of
  /// generating a fresh ephemeral key per client instance.  The key is loaded
  /// via [e2eeKeyPairFromPkcs8].
  ///
  /// Obtain a device key with: `bella auth setup`. To convert a PEM or base64
  /// string (e.g. `BELLA_BAXTER_PRIVATE_KEY`) use [bellaPrivateKeyFromEnvValue].
  ///
  /// When null (default) an ephemeral P-256 key pair is generated automatically.
  final Uint8List? privateKey;

  /// Optional callback invoked when the server returns an
  /// `X-Bella-Wrapped-Dek` response header (ZKE key-wrapping flow).
  ///
  /// Arguments:
  /// - `projectSlug` — slug of the project whose secrets were fetched
  /// - `envSlug`     — environment slug
  /// - `wrappedDek`  — base64-encoded wrapped Data-Encryption Key
  /// - `leaseExpires` — parsed value of `X-Bella-Lease-Expires`, or null
  ///
  /// Use this to persist the wrapped DEK for offline / cache-warming scenarios.
  final void Function(String, String, String, DateTime?)? onWrappedDekReceived;

  // NOTE: The constructor is not `const` because [privateKey] is `Uint8List?`,
  // which is not a const-compatible type.  All existing callers that omit
  // [privateKey] and [onWrappedDekReceived] are unaffected.
  BellaClientOptions({
    this.baseUrl = 'https://api.bella-baxter.io',
    this.apiKey,
    this.accessToken,
    this.appClient,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 30),
    this.cache,
    this.privateKey,
    this.onWrappedDekReceived,
  }) : assert(
          (apiKey != null) != (accessToken != null),
          'Provide exactly one of apiKey or accessToken.',
        );
}

// ── Device key (ZKE) ─────────────────────────────────────────────────────────

/// Parses the value of `BELLA_BAXTER_PRIVATE_KEY` into PKCS#8 DER bytes.
///
/// Accepts a PKCS#8 PEM (what `bella sdk run` injects) or bare base64 PKCS#8
/// DER: the `-----…-----` armour and all whitespace (including CRLF) are
/// stripped before decoding, the same rule the JS, Java and .NET SDKs apply.
///
/// Returns `null` when [value] is null or blank — no device key is configured,
/// and the client generates an ephemeral key as it always has.
///
/// Throws a [StateError] naming `BELLA_BAXTER_PRIVATE_KEY` when a key IS
/// present but cannot be read as a P-256 private key. It never falls back to an
/// ephemeral key in that case (#989): silently presenting a key nobody
/// registered makes every read fail later with a 403 whose cause is invisible
/// from inside the application.
Uint8List? bellaPrivateKeyFromEnvValue(String? value) {
  if (value == null || value.trim().isEmpty) return null;

  final body = value.replaceAll(RegExp(r'-----[A-Z ]+-----|\s'), '');
  try {
    final der = base64Decode(body);
    // Parse it now, so a bad key fails here rather than on the first request.
    e2eeKeyPairFromPkcs8(der);
    return der;
  } catch (_) {
    throw StateError(
      'BELLA_BAXTER_PRIVATE_KEY is set but is not a readable PKCS#8 P-256 '
      'private key (PEM or base64 DER expected). Refusing to continue with a '
      'throwaway key instead of your device key.\n'
      '  Unset it, or re-run: bella auth setup',
    );
  }
}

// ── Internal auth helpers ────────────────────────────────────────────────────

class _ParsedBaxToken {
  final String keyId;
  final List<int> signingSecret;
  _ParsedBaxToken(this.keyId, this.signingSecret);
}

_ParsedBaxToken _parseBaxToken(String apiKey) {
  final parts = apiKey.split('-');
  if (parts.length != 3 || parts[0] != 'bax') {
    throw ArgumentError(
      'Invalid Bella API key format (expected "bax-<id>-<secret>").\n'
      '  Generate a valid key in the Bella Baxter WebApp under Settings → API Keys.',
    );
  }
  final hex = parts[2];
  final bytes = <int>[
    for (var i = 0; i < hex.length; i += 2)
      int.parse(hex.substring(i, i + 2), radix: 16),
  ];
  return _ParsedBaxToken(parts[1], bytes);
}

/// Dio interceptor: HMAC-signed `X-Bella-*` headers (API key mode).
class _BellaHmacInterceptor extends Interceptor {
  final String keyId;
  final List<int> signingSecret;
  final String? appClient;

  _BellaHmacInterceptor({
    required this.keyId,
    required this.signingSecret,
    this.appClient,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final method = options.method.toUpperCase();
    final path = options.uri.path;

    // Sorted query string (matches JS SDK behaviour)
    final sortedParams = (options.uri.queryParameters.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)))
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    // Body hash
    List<int> bodyBytes = const [];
    final data = options.data;
    if (data != null) {
      if (data is List<int>) {
        bodyBytes = data;
      } else if (data is String) {
        bodyBytes = utf8.encode(data);
      } else {
        bodyBytes = utf8.encode(jsonEncode(data));
      }
    }
    final bodyHash = sha256.convert(bodyBytes).toString();

    final timestamp = DateTime.now()
        .toUtc()
        .toIso8601String()
        .replaceFirst(RegExp(r'\.\d{3}Z$'), 'Z');

    final stringToSign = '$method\n$path\n$sortedParams\n$timestamp\n$bodyHash';
    final signature =
        Hmac(sha256, signingSecret).convert(utf8.encode(stringToSign)).toString();

    options.headers['X-Bella-Key-Id'] = keyId;
    options.headers['X-Bella-Timestamp'] = timestamp;
    options.headers['X-Bella-Signature'] = signature;
    options.headers['X-Bella-Client'] = 'bella-dart-sdk';
    options.headers['User-Agent'] = 'bella-dart-sdk/1.0';
    if (appClient != null) options.headers['X-App-Client'] = appClient;

    handler.next(options);
  }
}

/// Dio interceptor: `Authorization: Bearer <token>` (JWT / SSO mode).
class _BellaBearerInterceptor extends Interceptor {
  final String accessToken;
  final String? appClient;

  _BellaBearerInterceptor({required this.accessToken, this.appClient});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $accessToken';
    options.headers['X-Bella-Client'] = 'bella-dart-sdk';
    options.headers['User-Agent'] = 'bella-dart-sdk/1.0';
    if (appClient != null) options.headers['X-App-Client'] = appClient;
    handler.next(options);
  }
}

// ── BellaClient ──────────────────────────────────────────────────────────────

/// High-level Bella Baxter client.
///
/// **API key mode** (most common — `bella sdk run` with a stored key):
/// ```dart
/// final client = BellaClient(BellaClientOptions(
///   baseUrl: Platform.environment['BELLA_BAXTER_URL']!,
///   apiKey:  Platform.environment['BELLA_BAXTER_API_KEY']!,
/// ));
/// ```
///
/// **JWT mode** (`bella sdk run` in SSO / OAuth mode):
/// ```dart
/// final client = BellaClient(BellaClientOptions(
///   baseUrl:     Platform.environment['BELLA_BAXTER_URL']!,
///   accessToken: Platform.environment['BELLA_BAXTER_ACCESS_TOKEN']!,
/// ));
/// ```
///
/// **Auto-detect from environment** (recommended — works for both modes):
/// ```dart
/// final client = BellaClient.fromEnv();
/// final secrets = await client.pullSecrets();
/// ```
class BellaClient {
  late final BellaBaxter _api;
  KeyContextResponse? _keyContext;
  SecretCache? _cache;

  BellaClient(BellaClientOptions options) {
    _cache = options.cache;
    final resolvedAppClient =
        options.appClient ?? Platform.environment['BELLA_BAXTER_APP_CLIENT'];

    final dio = Dio(BaseOptions(
      baseUrl: options.baseUrl,
      connectTimeout: options.connectTimeout,
      receiveTimeout: options.receiveTimeout,
    ));

    if (options.apiKey != null) {
      final parsed = _parseBaxToken(options.apiKey!);
      dio.interceptors.add(_BellaHmacInterceptor(
        keyId: parsed.keyId,
        signingSecret: parsed.signingSecret,
        appClient: resolvedAppClient,
      ));
    } else {
      dio.interceptors.add(_BellaBearerInterceptor(
        accessToken: options.accessToken!,
        appClient: resolvedAppClient,
      ));
    }

    // E2EE: transparently encrypts the secrets request / decrypts the response.
    // ZKE: when privateKey is set, uses the persistent device key; otherwise
    //      generates an ephemeral key pair (default behaviour).
    dio.interceptors.add(BellaE2eeInterceptor(
      privateKeyBytes: options.privateKey,
      onWrappedDekReceived: options.onWrappedDekReceived,
    ));

    _api = BellaBaxter(dio: dio);
  }

  /// Creates a [BellaClient] from environment variables injected by `bella sdk run`.
  ///
  /// Reads (in priority order):
  /// - `BELLA_BAXTER_URL`  / `BELLA_API_URL` (deprecated alias)
  /// - `BELLA_BAXTER_API_KEY` / `BELLA_API_KEY` (deprecated alias) — HMAC mode
  /// - `BELLA_BAXTER_ACCESS_TOKEN` — Bearer mode (SSO / OAuth)
  ///
  /// Throws [StateError] if neither auth var is set or the URL is missing.
  factory BellaClient.fromEnv() {
    final baseUrl = Platform.environment['BELLA_BAXTER_URL'] ??
        Platform.environment['BELLA_API_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError(
        'BELLA_BAXTER_URL is not set.\n'
        '  Run your app via: bella sdk run -- dart main.dart',
      );
    }

    final apiKey = Platform.environment['BELLA_BAXTER_API_KEY'] ??
        Platform.environment['BELLA_API_KEY'];
    final accessToken = Platform.environment['BELLA_BAXTER_ACCESS_TOKEN'];
    final appClient = Platform.environment['BELLA_BAXTER_APP_CLIENT'];

    // ZKE: auto-load device private key from BELLA_BAXTER_PRIVATE_KEY env var.
    // This var is injected by `bella sdk run` when the device has been set up via `bella auth setup`.
    final privateKey = bellaPrivateKeyFromEnvValue(
        Platform.environment['BELLA_BAXTER_PRIVATE_KEY']);

    if (apiKey != null && apiKey.isNotEmpty) {
      return BellaClient(BellaClientOptions(baseUrl: baseUrl, apiKey: apiKey, appClient: appClient, privateKey: privateKey));
    }
    if (accessToken != null && accessToken.isNotEmpty) {
      return BellaClient(
          BellaClientOptions(baseUrl: baseUrl, accessToken: accessToken, appClient: appClient, privateKey: privateKey));
    }

    throw StateError(
      'No Bella auth credentials found.\n'
      '  Set BELLA_BAXTER_API_KEY or BELLA_BAXTER_ACCESS_TOKEN,\n'
      '  or run your app via: bella sdk run -- dart main.dart',
    );
  }

  // ── Generated client ──────────────────────────────────────────────────────

  /// The generated client for the full Bella Baxter API (projects, providers, TOTP, …), on the same Dio
  /// as this client: its auth and E2EE interceptors apply to every call made through it, so a secret
  /// value read here (e.g. `getSecret`, `listSecrets`) presents the E2EE key and is decrypted
  /// transparently, and a plaintext or undecryptable answer is refused with [E2EEResponseError] (#1162).
  /// The other SDKs expose theirs the same way (Python `client`, Java/PHP `getClient()`, Ruby `client`).
  ///
  /// Five of the seven secret-value reads are declared as `E2EEncryptedPayload` in the OpenAPI document,
  /// so their typed methods cannot represent the decrypted body; read those through `api.dio` instead.
  BellaBaxter get api => _api;

  // ── Key context ───────────────────────────────────────────────────────────

  /// Calls `GET /api/v1/keys/me` to discover the project + environment this
  /// API key is scoped to. Result is cached for the lifetime of this client.
  ///
  /// Note: only meaningful in API key mode. In JWT mode, use
  /// `BELLA_BAXTER_PROJECT` / `BELLA_BAXTER_ENV` env vars instead.
  Future<KeyContextResponse> getKeyContext() async {
    if (_keyContext != null) return _keyContext!;
    final resp = await _api
        .getBellaBaxterFeaturesApiKeysGetKeyContextApi()
        .getKeyContext();
    _keyContext = resp.data!;
    return _keyContext!;
  }

  // ── Projects ──────────────────────────────────────────────────────────────

  /// Lists all projects the authenticated user has access to.
  Future<List<ProjectResponse>> listProjects(
      {int page = 0, int size = 50}) async {
    final resp = await _api
        .getBellaBaxterFeaturesProjectsListProjectsApi()
        .getAllProjects(page: page, size: size);
    return resp.data?.content.toList() ?? [];
  }

  /// Gets a single project by GUID or slug.
  Future<GetProjectResponse> getProject(String ref) async {
    final resp = await _api
        .getBellaBaxterFeaturesProjectsGetProjectGetProjectApi()
        .getProjectById(projectRef: ref);
    return resp.data!;
  }

  // ── Environments ──────────────────────────────────────────────────────────

  /// Lists environments in a project.
  Future<List<EnvironmentResponse>> listEnvironments(
      String projectRef) async {
    final resp = await _api
        .getBellaBaxterFeaturesProjectsEnvironmentsListEnvironmentsApi()
        .getEnvironmentsByProject(projectRef: projectRef);
    return resp.data?.toList() ?? [];
  }

  // ── Secrets ───────────────────────────────────────────────────────────────

  /// Returns all secrets for an environment merged into a flat `Map<String, String>`.
  ///
  /// In API key mode: project + environment are auto-discovered via [getKeyContext].
  /// In JWT mode: pass [projectRef] + [environmentSlug] explicitly, or set
  /// `BELLA_BAXTER_PROJECT` / `BELLA_BAXTER_ENV` env vars.
  ///
  /// This is the primary method for secret consumption — equivalent to `bella pull`.
  ///
  /// When [fallbackOnError] is true (default) and the request fails (e.g. no
  /// network, timeout, invalid credentials), an empty map is returned instead of
  /// throwing. Set to false if you need to handle errors explicitly.
  ///
  /// An [E2EEResponseError] is always thrown, whatever [fallbackOnError] says: the server answered in
  /// plaintext although this client presented its E2EE key, or the envelope would not decrypt (#1050).
  Future<Map<String, String>> pullSecrets({
    String? projectRef,
    String? environmentSlug,
    bool fallbackOnError = true,
  }) async {
    try {
      String resolvedProject = projectRef ?? '';
      String resolvedEnv = environmentSlug ?? '';

      if (resolvedProject.isEmpty || resolvedEnv.isEmpty) {
        // Try API key context first
        try {
          final ctx = await getKeyContext();
          resolvedProject = resolvedProject.isNotEmpty
              ? resolvedProject
              : (ctx.projectSlug ?? '');
          resolvedEnv = resolvedEnv.isNotEmpty
              ? resolvedEnv
              : (ctx.environmentSlug ?? '');
        } catch (_) {
          // JWT mode: fall back to env vars
          resolvedProject = resolvedProject.isNotEmpty
              ? resolvedProject
              : (Platform.environment['BELLA_BAXTER_PROJECT'] ?? '');
          resolvedEnv = resolvedEnv.isNotEmpty
              ? resolvedEnv
              : (Platform.environment['BELLA_BAXTER_ENV'] ?? '');
        }
      }

      final resp = await _api
          .getBellaBaxterFeaturesProjectsEnvironmentsSecretsGetAllEnvironmentSecretsApi()
          .getAllEnvironmentSecrets(
            projectRef: resolvedProject,
            envSlug: resolvedEnv,
          );
      final data = resp.data;
      if (data == null) return {};
      final result = Map<String, String>.from(data.secrets.toMap());
      // Write-through: persist to cache on every successful fetch.
      await _cache?.write(result);
      return result;
    } catch (e) {
      // #1050 — a refused E2EE response is not a connectivity failure: it means the answer was plaintext
      // although this client presented its key, or the envelope would not decrypt. It is surfaced even
      // when fallbackOnError is set, and unwrapped from Dio so the caller sees its code.
      final refused = e is E2EEResponseError
          ? e
          : (e is DioException && e.error is E2EEResponseError
              ? e.error as E2EEResponseError
              : null);
      if (refused != null) throw refused;
      if (fallbackOnError) {
        // Try the encrypted cache before giving up.
        final cached = await _tryReadCache();
        return cached ?? {};
      }
      rethrow;
    }
  }

  Future<Map<String, String>?> _tryReadCache() async {
    try {
      return await _cache?.read();
    } catch (_) {
      return null;
    }
  }

  /// Pulls secrets and maps them to a typed object via [fromMap].
  ///
  /// Use this together with a generated secrets class:
  ///
  /// ```dart
  /// final secrets = await client.pullSecretsAs(AppSecrets.fromMap);
  /// print(secrets.databaseUrl);
  /// ```
  ///
  /// Generate the secrets class with:
  ///   `bella secrets generate dart --types`
  ///
  /// When [fallbackOnError] is true (default) and the request fails (e.g. no
  /// network), an empty map is returned instead of throwing — safe for mobile.
  Future<T> pullSecretsAs<T>(
    T Function(Map<String, String>) fromMap, {
    String? projectRef,
    String? environmentSlug,
    bool fallbackOnError = true,
  }) async {
    final raw = await pullSecrets(
      projectRef: projectRef,
      environmentSlug: environmentSlug,
      fallbackOnError: fallbackOnError,
    );
    return fromMap(raw);
  }

  /// Returns a [Stream] that emits fresh secrets on [interval] (default: 5 min).
  ///
  /// The first value is emitted immediately. On each successful fetch the
  /// result is written to the [SecretCache] (if configured). Cancel the
  /// subscription to stop polling.
  ///
  /// **Failures are delivered, never swallowed (#1162).** When a poll fails,
  /// the last known good value (in memory, or the cache seed) is re-emitted as
  /// before — so the stream never closes on connectivity loss — and then the
  /// failure itself is delivered as an **error event**. Every failure is
  /// delivered: a lost connection or timeout ([DioException]), an expired or
  /// revoked credential (the API's 401/403), and an [E2EEResponseError] when
  /// the server answered in plaintext although this client presented its E2EE
  /// key, or the envelope would not decrypt (unwrapped from Dio, so its `code`
  /// is `e2ee-plaintext-response` / `e2ee-decryption-failed`).
  ///
  /// The error comes AFTER the re-emitted value, so it is the latest event: a
  /// listener that clears its error state in `onData` (or a `StreamBuilder`)
  /// still shows the failure until a later poll succeeds. Polling continues
  /// after an error, but a listener subscribed with `cancelOnError: true` is
  /// cancelled by the first one — pass an `onError` handler instead.
  ///
  /// ```dart
  /// client.watchSecrets().listen((secrets) {
  ///   setState(() => _dbUrl = secrets['DATABASE_URL']);
  /// }, onError: (Object e) {
  ///   setState(() => _error = e is E2EEResponseError ? e.code : '$e');
  /// });
  /// ```
  Stream<Map<String, String>> watchSecrets({
    Duration interval = const Duration(minutes: 5),
    String? projectRef,
    String? environmentSlug,
  }) async* {
    // Seed from cache so first emission is instant even when offline.
    Map<String, String> last = await _tryReadCache() ?? {};
    while (true) {
      Object? failure;
      StackTrace? failureTrace;
      try {
        last = await pullSecrets(
          projectRef: projectRef,
          environmentSlug: environmentSlug,
          fallbackOnError: false, // cache write-through already done inside pullSecrets
        );
      } catch (e, st) {
        // #1050 — surface a refused E2EE answer by itself, with its code, not Dio's wrapper around it.
        failure = e is DioException && e.error is E2EEResponseError ? e.error : e;
        failureTrace = st;
      }
      // Re-emit last known good (in-memory or from the cache seed above) on failure, as documented.
      yield last;
      if (failure != null) {
        // An error event does not close an async* stream: polling carries on after it.
        yield* Stream<Map<String, String>>.error(failure, failureTrace);
      }
      await Future<void>.delayed(interval);
    }
  }

  /// Like [watchSecrets] but maps each emission through [fromMap]. Failed polls arrive as error events,
  /// exactly as in [watchSecrets].
  ///
  /// ```dart
  /// client.watchSecretsAs(AppSecrets.fromMap).listen((s) {
  ///   setState(() => _secrets = s);
  /// });
  /// ```
  Stream<T> watchSecretsAs<T>(
    T Function(Map<String, String>) fromMap, {
    Duration interval = const Duration(minutes: 5),
    String? projectRef,
    String? environmentSlug,
  }) =>
      watchSecrets(
        interval: interval,
        projectRef: projectRef,
        environmentSlug: environmentSlug,
      ).map(fromMap);
}

/// Extension to convert a secrets map to `.env` file format.
extension SecretsMapExtension on Map<String, String> {
  /// Returns `KEY=VALUE\n...` sorted by key.
  String toEnvFormat() {
    final sorted = entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return sorted.map((e) => '${e.key}=${e.value}').join('\n') + '\n';
  }
}

