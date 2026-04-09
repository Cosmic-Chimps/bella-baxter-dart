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
/// - [accessToken]: Bearer JWT auth (injected by `bella exec` in SSO/OAuth mode).
class BellaClientOptions {
  /// The base URL of the Bella Baxter API.
  /// Defaults to `'https://api.bella-baxter.io'` (hosted cloud).
  /// Override for self-hosted deployments.
  final String baseUrl;

  /// API key in `bax-<keyId>-<signingSecretHex>` format.
  /// Mutually exclusive with [accessToken].
  final String? apiKey;

  /// Short-lived JWT access token.
  /// Injected as `BELLA_BAXTER_ACCESS_TOKEN` by `bella exec` in SSO mode.
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
  /// Obtain a device key with: `bella auth setup`
  /// (exports `~/.bella/device-key.pem`; strip PEM headers and base64-decode
  /// to get the raw DER bytes).
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
/// **API key mode** (most common — `bella exec` with a stored key):
/// ```dart
/// final client = BellaClient(BellaClientOptions(
///   baseUrl: Platform.environment['BELLA_BAXTER_URL']!,
///   apiKey:  Platform.environment['BELLA_BAXTER_API_KEY']!,
/// ));
/// ```
///
/// **JWT mode** (`bella exec` in SSO / OAuth mode):
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

  /// Creates a [BellaClient] from environment variables injected by `bella exec`.
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
        '  Run your app via: bella exec -- dart main.dart',
      );
    }

    final apiKey = Platform.environment['BELLA_BAXTER_API_KEY'] ??
        Platform.environment['BELLA_API_KEY'];
    final accessToken = Platform.environment['BELLA_BAXTER_ACCESS_TOKEN'];
    final appClient = Platform.environment['BELLA_BAXTER_APP_CLIENT'];

    // ZKE: auto-load device private key from BELLA_BAXTER_PRIVATE_KEY env var.
    // This var is injected by `bella sdk run` when the device has been set up via `bella auth setup`.
    Uint8List? privateKey;
    final privateKeyB64 = Platform.environment['BELLA_BAXTER_PRIVATE_KEY'];
    if (privateKeyB64 != null && privateKeyB64.isNotEmpty) {
      try {
        privateKey = base64Decode(privateKeyB64);
      } catch (_) {
        // Invalid base64 — ignore and fall back to ephemeral key
      }
    }

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
      '  or run your app via: bella exec -- dart main.dart',
    );
  }

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
  /// result is written to the [SecretCache] (if configured). If a fetch fails
  /// the last known good value is re-emitted — the stream never closes due to
  /// connectivity loss. Cancel the subscription to stop polling.
  ///
  /// ```dart
  /// client.watchSecrets().listen((secrets) {
  ///   setState(() => _dbUrl = secrets['DATABASE_URL']);
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
      try {
        last = await pullSecrets(
          projectRef: projectRef,
          environmentSlug: environmentSlug,
          fallbackOnError: false, // cache write-through already done inside pullSecrets
        );
      } catch (_) {
        // Re-emit last known good (in-memory or from cache seed above).
      }
      yield last;
      await Future<void>.delayed(interval);
    }
  }

  /// Like [watchSecrets] but maps each emission through [fromMap].
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

