import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Verifies the `X-Bella-Signature` header on incoming Bella Baxter webhook requests.
///
/// Header format: `t={unix_epoch_seconds},v1={hmac_sha256_hex}`
/// Signing input:  `{t}.{rawBodyJson}` (UTF-8)
/// HMAC key:       the raw `whsec-xxx` signing secret (UTF-8 encoded)
class WebhookSignatureVerifier {
  static const int _defaultToleranceSeconds = 300;

  /// Verifies [signatureHeader] (`X-Bella-Signature`) against [rawBody] using [secret].
  ///
  /// Returns `false` if the signature is invalid, stale, or the header is malformed.
  static bool verify({
    required String secret,
    required String signatureHeader,
    required String rawBody,
    int toleranceSeconds = _defaultToleranceSeconds,
  }) {
    String? t;
    String? v1;

    for (final part in signatureHeader.split(',')) {
      final trimmed = part.trim();
      if (trimmed.startsWith('t=')) {
        t = trimmed.substring(2);
      } else if (trimmed.startsWith('v1=')) {
        v1 = trimmed.substring(3);
      }
    }

    if (t == null || t.isEmpty || v1 == null || v1.isEmpty) {
      return false;
    }

    final timestamp = int.tryParse(t);
    if (timestamp == null) {
      return false;
    }

    final nowSeconds =
        DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if ((nowSeconds - timestamp).abs() > toleranceSeconds) {
      return false;
    }

    final hmac = Hmac(sha256, utf8.encode(secret));
    final digest = hmac.convert(utf8.encode('$t.$rawBody'));
    final expected = digest.toString(); // lowercase hex

    return _constantTimeEquals(expected, v1);
  }

  /// Compares two strings in constant time to prevent timing attacks.
  static bool _constantTimeEquals(String a, String b) {
    final aBytes = Uint8List.fromList(utf8.encode(a));
    final bBytes = Uint8List.fromList(utf8.encode(b));

    if (aBytes.length != bBytes.length) {
      return false;
    }

    var result = 0;
    for (var i = 0; i < aBytes.length; i++) {
      result |= aBytes[i] ^ bBytes[i];
    }
    return result == 0;
  }
}
