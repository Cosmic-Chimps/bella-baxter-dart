import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

// ── P-256 domain parameters ──────────────────────────────────────────────────

final _domain = ECDomainParameters('prime256v1');

// ── P-256 SPKI DER header (27 bytes, hard-coded for secp256r1) ───────────────
// Structure: SEQUENCE { AlgorithmIdentifier { ecPublicKey, P-256 }
//                       BIT-STRING { 0x04 x y } }
const _spkiHeader = <int>[
  0x30, 0x59, // SEQUENCE, length 89
  0x30, 0x13, // SEQUENCE, length 19 (algorithm identifier)
  0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02, 0x01, // OID: ecPublicKey
  0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x07, // OID: P-256
  0x03, 0x42, // BIT STRING, length 66
  0x00, // 0 unused bits
  0x04, // uncompressed point marker (followed by 32-byte x then 32-byte y)
]; // total: 27 bytes; full SPKI = 27 + 64 = 91 bytes

// ── Internal key-pair type alias ─────────────────────────────────────────────

typedef E2eeKeyPair = AsymmetricKeyPair<ECPublicKey, ECPrivateKey>;

// ── Public helpers ───────────────────────────────────────────────────────────

/// Generates a fresh P-256 ECDH key pair for use with E2EE.
E2eeKeyPair generateE2eeKeyPair() {
  final rng = FortunaRandom()
    ..seed(KeyParameter(Uint8List.fromList(
        List.generate(32, (_) => Random.secure().nextInt(256)))));
  final gen = ECKeyGenerator()
    ..init(ParametersWithRandom(ECKeyGeneratorParameters(_domain), rng));
  final kp = gen.generateKeyPair();
  return AsymmetricKeyPair<ECPublicKey, ECPrivateKey>(
    kp.publicKey,
    kp.privateKey,
  );
}

/// Creates an [E2eeKeyPair] from PKCS#8 DER-encoded bytes (ZKE persistent
/// device key).
///
/// Use this instead of [generateE2eeKeyPair] when a persistent key is
/// configured. Obtain a key with: `bella auth setup` (exports
/// `~/.bella/device-key.pem`).
///
/// The DER follows RFC 5958 (PKCS#8) wrapping an RFC 5915 ECPrivateKey for
/// curve P-256 (secp256r1 / prime256v1):
/// ```
/// SEQUENCE {
///   INTEGER 0                              -- version
///   SEQUENCE { OID ecPublicKey, OID P-256 } -- algorithm
///   OCTET STRING {                          -- privateKey
///     SEQUENCE {
///       INTEGER 1
///       OCTET STRING <32 bytes: private scalar d>
///       [1] BIT STRING <65 bytes: 0x04 || X || Y>  (optional)
///     }
///   }
/// }
/// ```
/// The public key is derived from the private scalar (d·G) so the optional
/// `[1]` context field is not required.
E2eeKeyPair e2eeKeyPairFromPkcs8(Uint8List pkcs8Bytes) {
  // ── Outer PKCS#8 SEQUENCE ────────────────────────────────────────────────
  final outerParser = ASN1Parser(pkcs8Bytes);
  final outerSeq = outerParser.nextObject() as ASN1Sequence;
  if ((outerSeq.elements?.length ?? 0) < 3) {
    throw ArgumentError(
        'Invalid PKCS#8 DER: expected SEQUENCE with at least 3 elements.');
  }

  // elements[2] is an OCTET STRING whose value is the ECPrivateKey DER blob.
  final wrappedOctet = outerSeq.elements![2] as ASN1OctetString;
  final innerDer = Uint8List.fromList(wrappedOctet.octets!);

  // ── Inner ECPrivateKey SEQUENCE (RFC 5915) ───────────────────────────────
  final innerParser = ASN1Parser(innerDer);
  final innerSeq = innerParser.nextObject() as ASN1Sequence;
  if ((innerSeq.elements?.length ?? 0) < 2) {
    throw ArgumentError(
        'Invalid ECPrivateKey DER: expected SEQUENCE with at least 2 elements.');
  }

  // elements[1] is an OCTET STRING holding the 32-byte private scalar d.
  final dOctet = innerSeq.elements![1] as ASN1OctetString;
  final dBytes = Uint8List.fromList(dOctet.octets!);

  // Convert big-endian bytes → BigInt.
  var d = BigInt.zero;
  for (final byte in dBytes) {
    d = (d << 8) | BigInt.from(byte);
  }

  // Derive public key: Q = d·G (avoids parsing the optional [1] BIT STRING).
  final privateKey = ECPrivateKey(d, _domain);
  final publicKey = ECPublicKey((_domain.G * d)!, _domain);

  return AsymmetricKeyPair<ECPublicKey, ECPrivateKey>(publicKey, privateKey);
}

/// Encodes a [keyPair]'s P-256 public key as DER SPKI, Base64-encoded,
/// ready to send as the `X-E2E-Public-Key` request header.
String e2eePublicKeyToSpkiB64(E2eeKeyPair keyPair) {
  // ECPoint.getEncoded(false) = 04 || x || y (65 bytes; 04 = uncompressed)
  final encodedPoint = keyPair.publicKey.Q!.getEncoded(false);
  final spki = Uint8List(91)
    ..setAll(0, _spkiHeader)
    ..setAll(27, encodedPoint.sublist(1)); // skip 0x04, take 64 bytes x||y
  return base64.encode(spki);
}

/// Decrypts an E2EE-encrypted payload returned by the Bella Baxter API.
///
/// [clientKeyPair] must be the key pair whose public key was sent as the
/// `X-E2E-Public-Key` header.
///
/// Crypto: ECDH-P256 → HKDF-SHA256(salt=32 zeros, info="bella-e2ee-v1")
///         → AES-256-GCM decrypt.
///
/// Returns the decrypted response as a plain [Map<String,dynamic>].
Map<String, dynamic> decryptE2eePayload(
  E2eeKeyPair clientKeyPair,
  Map<String, dynamic> payload,
) {
  final serverSpki = base64.decode(payload['serverPublicKey'] as String);
  final nonce = base64.decode(payload['nonce'] as String);
  final tag = base64.decode(payload['tag'] as String);
  final ciphertext = base64.decode(payload['ciphertext'] as String);

  // ── Step 1: Import server ephemeral public key from SPKI DER ──────────────
  // Layout: 27-byte header | 32-byte x | 32-byte y.
  // Reconstruct uncompressed-point encoding: 0x04 || x || y (65 bytes).
  final uncompressedPoint = Uint8List(65)
    ..[0] = 0x04
    ..setAll(1, serverSpki.sublist(27, 91));
  final serverQ = _domain.curve.decodePoint(uncompressedPoint)!;
  final serverPublicKey = ECPublicKey(serverQ, _domain);

  // ── Step 2: ECDH → 32-byte shared secret (x-coordinate) ──────────────────
  final agreement = ECDHBasicAgreement()..init(clientKeyPair.privateKey);
  final sharedBigInt = agreement.calculateAgreement(serverPublicKey);
  final sharedSecret = _bigIntToBytes32(sharedBigInt);

  // ── Step 3: HKDF-SHA256 → 32-byte AES-256 key ────────────────────────────
  // Salt = 32 zero bytes (RFC 5869 §2.2 default). Info = "bella-e2ee-v1".
  final aesKey = _hkdfSha256(
    ikm: sharedSecret,
    salt: Uint8List(32), // 32 zero bytes
    info: utf8.encode('bella-e2ee-v1'),
    length: 32,
  );

  // ── Step 4: AES-256-GCM decrypt ───────────────────────────────────────────
  // GCMBlockCipher expects ciphertext || tag concatenated.
  final combined = Uint8List(ciphertext.length + tag.length)
    ..setAll(0, ciphertext)
    ..setAll(ciphertext.length, tag);

  final gcm = GCMBlockCipher(AESEngine())
    ..init(
      false, // false = decrypt
      AEADParameters(
        KeyParameter(aesKey),
        128, // tag length in bits
        Uint8List.fromList(nonce),
        Uint8List(0), // no AAD
      ),
    );
  final plaintext = gcm.process(combined);

  return json.decode(utf8.decode(plaintext)) as Map<String, dynamic>;
}

// ── Private utilities ────────────────────────────────────────────────────────

/// RFC 5869 HKDF-SHA256, implemented using HMAC-SHA256 from pointycastle.
Uint8List _hkdfSha256({
  required List<int> ikm,
  required List<int> salt,
  required List<int> info,
  required int length,
}) {
  // Extract: PRK = HMAC-SHA256(salt, IKM)
  final hmacExtract = HMac(SHA256Digest(), 64)
    ..init(KeyParameter(Uint8List.fromList(salt)));
  hmacExtract.update(Uint8List.fromList(ikm), 0, ikm.length);
  final prk = Uint8List(32);
  hmacExtract.doFinal(prk, 0);

  // Expand: T(1) = HMAC-SHA256(PRK, info || 0x01)  (one block suffices for 32 bytes)
  final hmacExpand = HMac(SHA256Digest(), 64)..init(KeyParameter(prk));
  hmacExpand.update(Uint8List.fromList(info), 0, info.length);
  hmacExpand.update(Uint8List.fromList([0x01]), 0, 1);
  final okm = Uint8List(32);
  hmacExpand.doFinal(okm, 0);

  return okm.sublist(0, length);
}

/// Converts a [BigInt] to a fixed-length 32-byte big-endian [Uint8List],
/// padding with leading zeros as needed (required for P-256 x-coordinates).
Uint8List _bigIntToBytes32(BigInt value) {
  final hex = value.toRadixString(16);
  // Ensure exactly 64 hex chars (= 32 bytes), padding or trimming as needed.
  final padded = hex.length < 64
      ? hex.padLeft(64, '0')
      : hex.substring(hex.length - 64);
  return Uint8List.fromList(List.generate(
      32, (i) => int.parse(padded.substring(i * 2, i * 2 + 2), radix: 16)));
}

// ── #1050: a presented key requires an envelope ─────────────────────────────

/// A secrets response was refused because it was not the E2EE envelope this client asked for, or the
/// envelope would not decrypt (#1050, `apps/sdk/SDK_CONTRACT.md`, "Rule: a presented key requires an
/// envelope"). Never a plaintext fallback: the caller gets this error, not the values.
///
/// [code] is the stable, cross-SDK contract: [plaintextResponse] or [decryptionFailed]. The message names
/// the request path only — never the body, ciphertext or key material. The underlying failure, if any,
/// is [cause].
class E2EEResponseError implements Exception {
  /// A `2xx` answer to an envelope-required read, sent with `X-E2E-Public-Key`, that is not an envelope.
  static const String plaintextResponse = 'e2ee-plaintext-response';

  /// An `"encrypted": true` envelope with a missing/undecodable field, a failing GCM tag (tampered), or
  /// encrypted to a key other than the one presented.
  static const String decryptionFailed = 'e2ee-decryption-failed';

  /// [plaintextResponse] or [decryptionFailed].
  final String code;

  /// The request path the refused response answered.
  final String path;

  /// Human-readable, ends with the [code] in parentheses.
  final String message;

  /// What failed underneath, for [decryptionFailed]; never part of [message].
  final Object? cause;

  E2EEResponseError._(this.code, this.path, this.message, this.cause);

  /// The answer was plaintext although the key was presented.
  factory E2EEResponseError.plaintextReceived(String path) => E2EEResponseError._(
        plaintextResponse,
        path,
        'E2EE response expected but plaintext received for $path; '
        'refusing it ($plaintextResponse)',
        null,
      );

  /// The envelope did not decrypt.
  factory E2EEResponseError.undecryptable(String path, [Object? cause]) =>
      E2EEResponseError._(
        decryptionFailed,
        path,
        'E2EE response could not be decrypted for $path; '
        'refusing it ($decryptionFailed)',
        cause,
      );

  @override
  String toString() => 'E2EEResponseError: $message';
}

/// Whether a `2xx` answer to [method] [path] must be an E2EE envelope when `X-E2E-Public-Key` was
/// presented: the GETs that carry secret VALUES (`SDK_CONTRACT.md`, "Which Endpoints Support E2EE").
/// Everything else under `/secrets` carries no value and is answered in plain JSON.
bool requiresEnvelope(String method, String path) {
  if (method.toUpperCase() != 'GET') return false;
  const marker = '/api/v1/projects/';
  final i = path.indexOf(marker);
  if (i < 0) return false;
  final segs = path.substring(i + marker.length).split('/');
  if (segs.length < 2 || segs[0].isEmpty) return false;
  final r = segs.sublist(1);
  bool any(int idx) => r[idx].isNotEmpty;
  // /projects/{p}/secrets — listGlobalSecrets
  if (r.length == 1) return r[0] == 'secrets';
  if (r[0] != 'environments' || !any(1)) return false;
  // /environments/{e}/secrets[/export]
  if (r.length == 3) return r[2] == 'secrets';
  if (r.length == 4 && r[2] == 'secrets') return r[3] == 'export';
  if (r[2] != 'providers' || r.length < 5 || !any(3) || r[4] != 'secrets') return false;
  // /environments/{e}/providers/{v}/secrets — listSecrets
  if (r.length == 5) return true;
  // .../secrets/export (exportSecrets) or .../secrets/{key} (getSecret), never .../secrets/hash
  if (r.length == 6) return any(5) && r[5] != 'hash';
  // .../secrets/{key}/versions/{n} — getSecretVersion
  if (r.length == 8) {
    return any(5) && r[6] == 'versions' && RegExp(r'^[0-9]+$').hasMatch(r[7]);
  }
  return false;
}

// ── Dio interceptor ──────────────────────────────────────────────────────────

class BellaE2eeInterceptor extends Interceptor {
  /// Optional PKCS#8 DER bytes for the persistent device key (ZKE mode).
  /// When null an ephemeral P-256 key pair is generated once per client instance.
  final Uint8List? _privateKeyBytes;

  /// Optional callback invoked when `X-Bella-Wrapped-Dek` is received.
  /// Arguments: projectSlug, envSlug, wrappedDek (base64), leaseExpires.
  final void Function(String, String, String, DateTime?)? _onWrappedDekReceived;

  E2eeKeyPair? _keyPair;
  String? _publicKeySpkiB64;

  BellaE2eeInterceptor({
    Uint8List? privateKeyBytes,
    void Function(String, String, String, DateTime?)? onWrappedDekReceived,
  })  : _privateKeyBytes = privateKeyBytes,
        _onWrappedDekReceived = onWrappedDekReceived;

  /// Lazily initialises the P-256 key pair and caches the SPKI-encoded public
  /// key ready to send as a header.
  ///
  /// In ZKE mode ([_privateKeyBytes] set) the persistent device key is loaded
  /// via [e2eeKeyPairFromPkcs8]; otherwise a fresh ephemeral key is generated.
  void _ensureKeyPair() {
    if (_keyPair != null) return;
    _keyPair = _privateKeyBytes != null
        ? e2eeKeyPairFromPkcs8(_privateKeyBytes!)
        : generateE2eeKeyPair();
    _publicKeySpkiB64 = e2eePublicKeyToSpkiB64(_keyPair!);
  }

  /// Set on a request's `extra` when this interceptor presented the key, so the response is judged by
  /// what was actually sent — not by whether a key pair happens to exist on the instance.
  static const String keyPresentedExtra = 'bella.e2ee.keyPresented';

  /// Returns `true` when [path] is the all-environment-secrets endpoint.
  /// Matches `/environments/{slug}/secrets` (no trailing path segments).
  static bool isSecretsEndpoint(String path) =>
      RegExp(r'/environments/[^/]+/secrets$').hasMatch(path);

  // ── Interceptor overrides ─────────────────────────────────────────────────

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method == 'GET' && isSecretsEndpoint(options.uri.path)) {
      _ensureKeyPair();
      options.headers['X-E2E-Public-Key'] = _publicKeySpkiB64;
      options.extra[keyPresentedExtra] = true;
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.data;
    final request = response.requestOptions;
    final path = request.uri.path;
    final presented = request.extra[keyPresentedExtra] == true;
    final status = response.statusCode ?? 0;
    final isEnvelope = data is Map && data['encrypted'] == true;

    if (_keyPair != null && isEnvelope) {
      // #1050 — an envelope that will not decrypt (tampered, wrong key, malformed) is REFUSED. It used to
      // be passed through raw, so the caller could read the envelope's fields as its "secrets".
      try {
        response.data =
            decryptE2eePayload(_keyPair!, data.cast<String, dynamic>());
      } catch (e) {
        return _refuse(handler, request, E2EEResponseError.undecryptable(path, e));
      }
    } else if (presented &&
        status >= 200 &&
        status < 300 &&
        requiresEnvelope(request.method, path)) {
      // #1050 (b) — the key was presented on a read the server always encrypts, and the answer is not an
      // envelope: a header-stripping intermediary or a server regression. Plaintext is never a value here.
      return _refuse(handler, request, E2EEResponseError.plaintextReceived(path));
    }

    // ZKE: invoke callback when the server returns a wrapped DEK.
    final onWrapped = _onWrappedDekReceived;
    if (onWrapped != null) {
      final wrappedDek = response.headers.value('x-bella-wrapped-dek');
      if (wrappedDek != null) {
        final path = response.requestOptions.uri.path;
        // Extract project + env slugs from a path like:
        //   /api/v1/projects/{projectSlug}/environments/{envSlug}/secrets
        final slugMatch = RegExp(
          r'/projects/([^/]+)/environments/([^/]+)/secrets',
        ).firstMatch(path);
        final projectSlug = slugMatch?.group(1) ?? '';
        final envSlug = slugMatch?.group(2) ?? '';
        final leaseExpiresStr =
            response.headers.value('x-bella-lease-expires');
        final leaseExpires =
            leaseExpiresStr != null ? DateTime.tryParse(leaseExpiresStr) : null;
        onWrapped(projectSlug, envSlug, wrappedDek, leaseExpires);
      }
    }

    handler.next(response);
  }

  /// Rejects with a [DioException] whose `error` is [err]. The refused response is deliberately NOT
  /// attached: for a plaintext refusal it holds the very values that must not reach the caller.
  void _refuse(
    ResponseInterceptorHandler handler,
    RequestOptions request,
    E2EEResponseError err,
  ) {
    handler.reject(DioException(
      requestOptions: request,
      error: err,
      message: err.message,
      type: DioExceptionType.unknown,
    ));
  }
}
