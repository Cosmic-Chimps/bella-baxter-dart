// #1050 (b) — once this SDK has presented its E2EE public key, a secrets response that is not an envelope
// it can decrypt is REFUSED, never read as values (apps/sdk/SDK_CONTRACT.md, "Rule: a presented key
// requires an envelope"). Before the fix the interceptor passed a plaintext answer straight through and
// swallowed a failed decryption, so a tampered or mis-keyed envelope reached the caller raw.
//
// The stub is a real loopback HttpServer standing in for a misbehaving Bella. It encrypts exactly as the
// API does (ECDH P-256 → HKDF-SHA256(salt = 32 zero bytes, info = "bella-e2ee-v1") → AES-256-GCM with a
// 12-byte nonce and a separate 16-byte tag), to whatever key the client presented.
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bella_baxter/bella_client.dart';
import 'package:bella_baxter/src/e2ee.dart';
import 'package:dio/dio.dart';
import 'package:pointycastle/export.dart';
import 'package:test/test.dart';

const _sentinelKey = 'BELLA_KEY_CONTRACT';
const _sentinelValue = 'the-presented-key-decrypted-this';
const _project = 'contract-project';
const _env = 'contract-env';
const _secretsPath = '/api/v1/projects/$_project/environments/$_env/secrets';

enum _Mode { validEnvelope, plaintext, tampered, wrongKey, forbidden }

final _domain = ECDomainParameters('prime256v1');

ECPublicKey _publicKeyFromSpkiB64(String spkiB64) {
  final spki = base64.decode(spkiB64);
  final point = Uint8List(65)
    ..[0] = 0x04
    ..setAll(1, spki.sublist(27, 91));
  return ECPublicKey(_domain.curve.decodePoint(point), _domain);
}

Uint8List _bytes32(BigInt v) {
  final hex = v.toRadixString(16).padLeft(64, '0');
  return Uint8List.fromList(
      List.generate(32, (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)));
}

Uint8List _random(int n) =>
    Uint8List.fromList(List.generate(n, (_) => Random.secure().nextInt(256)));

/// The server side of the contract: EciesAlgorithm.Encrypt, as the stub (server.mjs encryptFor) does it.
Map<String, dynamic> _encryptFor(String clientSpkiB64, List<int> plaintext) {
  final server = generateE2eeKeyPair();
  final shared = _bytes32((ECDHBasicAgreement()..init(server.privateKey))
      .calculateAgreement(_publicKeyFromSpkiB64(clientSpkiB64)));
  final aesKey = Uint8List(32);
  (HKDFKeyDerivator(SHA256Digest())
        ..init(HkdfParameters(shared, 32, Uint8List(32), utf8.encode('bella-e2ee-v1'))))
      .deriveKey(null, 0, aesKey, 0);
  final nonce = _random(12);
  final sealed = (GCMBlockCipher(AESEngine())
        ..init(true, AEADParameters(KeyParameter(aesKey), 128, nonce, Uint8List(0))))
      .process(Uint8List.fromList(plaintext));
  final ciphertext = sealed.sublist(0, sealed.length - 16);
  final tag = sealed.sublist(sealed.length - 16);
  return {
    'encrypted': true,
    'algorithm': 'ECDH-P256-HKDF-SHA256-AES256GCM',
    'serverPublicKey': e2eePublicKeyToSpkiB64(server),
    'nonce': base64.encode(nonce),
    'tag': base64.encode(tag),
    'ciphertext': base64.encode(ciphertext),
  };
}

class _Stub {
  late final HttpServer server;
  _Mode mode = _Mode.validEnvelope;
  final presentedKeys = <String?>[];

  String get baseUrl => 'http://127.0.0.1:${server.port}';

  Future<void> start() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen(_handle);
  }

  Future<void> close() => server.close(force: true);

  void _send(HttpRequest req, int status, Object body) {
    req.response
      ..statusCode = status
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(body))
      ..close();
  }

  void _handle(HttpRequest req) async {
    await req.drain<void>();
    final path = req.uri.path;
    final presented = req.headers.value('x-e2e-public-key');

    // A value-less read the server answers in plain JSON even when a key is presented.
    if (path == '$_secretsPath/version') {
      return _send(req, 200, {'environmentSlug': _env, 'version': 7});
    }
    if (path != _secretsPath) return _send(req, 404, {'error': 'not served'});

    presentedKeys.add(presented);
    if (mode == _Mode.forbidden) {
      return _send(req, 403, {'type': 'zke-device-not-registered', 'title': 'refused'});
    }
    final plaintext = {
      'environmentSlug': _env,
      'environmentName': _env,
      'secrets': {_sentinelKey: _sentinelValue},
      'version': 1,
      'lastModified': '2026-10-04T00:00:00Z',
    };
    if (presented == null) return _send(req, 400, {'error': 'no key presented'});
    switch (mode) {
      case _Mode.plaintext:
        return _send(req, 200, plaintext);
      case _Mode.tampered:
        final env = _encryptFor(presented, utf8.encode(jsonEncode(plaintext)));
        final ct = base64.decode(env['ciphertext'] as String);
        ct[0] ^= 0x01;
        return _send(req, 200, {...env, 'ciphertext': base64.encode(ct)});
      case _Mode.wrongKey:
        final other = e2eePublicKeyToSpkiB64(generateE2eeKeyPair());
        return _send(req, 200, _encryptFor(other, utf8.encode(jsonEncode(plaintext))));
      case _Mode.validEnvelope:
      case _Mode.forbidden:
        return _send(req, 200, _encryptFor(presented, utf8.encode(jsonEncode(plaintext))));
    }
  }
}

Matcher _refusedWith(String code) => isA<E2EEResponseError>()
    .having((e) => e.code, 'code', code)
    .having((e) => e.message, 'message', contains(code))
    .having((e) => e.message, 'message', contains(_secretsPath))
    .having((e) => e.toString(), 'toString', isNot(contains(_sentinelValue)));

void main() {
  late _Stub stub;
  late BellaClient client;

  setUp(() async {
    stub = _Stub();
    await stub.start();
    client = BellaClient(BellaClientOptions(baseUrl: stub.baseUrl, accessToken: 'contract-token'));
  });

  tearDown(() => stub.close());

  Future<Map<String, String>> pull({bool fallbackOnError = false}) => client.pullSecrets(
      projectRef: _project, environmentSlug: _env, fallbackOnError: fallbackOnError);

  group('a presented key requires an envelope (#1050)', () {
    test('(1) a valid envelope to the presented key decrypts to the values', () async {
      final secrets = await pull();
      expect(secrets[_sentinelKey], _sentinelValue);
      expect(stub.presentedKeys.single, isNotNull);
    });

    test('(2) plaintext after presenting the key is refused with e2ee-plaintext-response', () async {
      stub.mode = _Mode.plaintext;
      await expectLater(pull(), throwsA(_refusedWith(E2EEResponseError.plaintextResponse)));
      expect(stub.presentedKeys.single, isNotNull, reason: 'the key was presented, so this is (b)');
    });

    test('(2b) the refusal survives fallbackOnError: it is not a connectivity failure', () async {
      stub.mode = _Mode.plaintext;
      await expectLater(pull(fallbackOnError: true),
          throwsA(_refusedWith(E2EEResponseError.plaintextResponse)));
    });

    test('(3) a tampered envelope is refused with e2ee-decryption-failed', () async {
      stub.mode = _Mode.tampered;
      await expectLater(pull(), throwsA(_refusedWith(E2EEResponseError.decryptionFailed)));
    });

    test('(4) an envelope encrypted to another key is refused with e2ee-decryption-failed', () async {
      stub.mode = _Mode.wrongKey;
      await expectLater(pull(), throwsA(_refusedWith(E2EEResponseError.decryptionFailed)));
    });

    test('(6) a non-2xx answer is the API error, not an E2EE refusal', () async {
      stub.mode = _Mode.forbidden;
      await expectLater(
          pull(),
          throwsA(isA<DioException>()
              .having((e) => e.response?.statusCode, 'status', 403)
              .having((e) => e.error, 'error', isNot(isA<E2EEResponseError>()))));
    });
  });

  group('reads that carry no value pass plaintext through', () {
    test('(5) GET .../secrets/version answered in plain JSON is returned as-is', () async {
      final dio = Dio(BaseOptions(baseUrl: stub.baseUrl))
        ..interceptors.add(BellaE2eeInterceptor());
      final resp = await dio.get<Map<String, dynamic>>('$_secretsPath/version',
          options: Options(extra: {BellaE2eeInterceptor.keyPresentedExtra: true}));
      expect(resp.data, {'environmentSlug': _env, 'version': 7});
    });
  });

  group('requiresEnvelope — the envelope-required reads (SDK_CONTRACT.md)', () {
    const base = '/api/v1/projects/p/environments/e';
    for (final path in [
      '/api/v1/projects/p/secrets',
      '$base/secrets',
      '$base/secrets/export',
      '$base/providers/v/secrets',
      '$base/providers/v/secrets/export',
      '$base/providers/v/secrets/DB_URL',
      '$base/providers/v/secrets/DB_URL/versions/3',
      '/gateway$base/secrets',
    ]) {
      test('GET $path requires an envelope', () => expect(requiresEnvelope('GET', path), isTrue));
    }
    for (final path in [
      '$base/secrets/version',
      '$base/secrets/manifest',
      '$base/secrets/certificates',
      '$base/providers/v/secrets/hash',
      '$base/providers/v/secrets/DB_URL/metadata',
      '$base/providers/v/secrets/DB_URL/versions',
      '$base/providers/v/secrets/DB_URL/versions/latest',
      '$base/providers/v/secrets/DB_URL/rotation-policy',
      '$base/providers/v/secrets/import/preview',
      '$base/providers',
      '/api/v1/projects/p',
      '/api/v1/tenants/me/zke',
    ]) {
      test('GET $path does not', () => expect(requiresEnvelope('GET', path), isFalse));
    }
    test('a write never does', () {
      for (final m in ['POST', 'PUT', 'PATCH', 'DELETE']) {
        expect(requiresEnvelope(m, '$base/secrets'), isFalse);
      }
    });
  });
}
