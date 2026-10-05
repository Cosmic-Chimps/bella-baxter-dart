// Test support (not a test): the server side of the E2EE contract, as the API (EciesAlgorithm.Encrypt) and
// the contract stub (contract-tests/stub/server.mjs encryptFor) do it — ECDH P-256 → HKDF-SHA256(salt = 32
// zero bytes, info = "bella-e2ee-v1") → AES-256-GCM with a 12-byte nonce and a separate 16-byte tag.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bella_baxter/src/e2ee.dart';
import 'package:pointycastle/export.dart';

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

/// An envelope of [plaintext] encrypted to the client key [clientSpkiB64].
Map<String, dynamic> encryptFor(String clientSpkiB64, List<int> plaintext) {
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
  return {
    'encrypted': true,
    'algorithm': 'ECDH-P256-HKDF-SHA256-AES256GCM',
    'serverPublicKey': e2eePublicKeyToSpkiB64(server),
    'nonce': base64.encode(nonce),
    'tag': base64.encode(sealed.sublist(sealed.length - 16)),
    'ciphertext': base64.encode(sealed.sublist(0, sealed.length - 16)),
  };
}
