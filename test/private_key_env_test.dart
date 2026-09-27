// #989 — BELLA_BAXTER_PRIVATE_KEY must load as PEM (what `bella sdk run` injects) AND as base64
// PKCS#8 DER, and a present-but-unreadable key must fail loudly instead of silently becoming an
// ephemeral key. Before the fix `fromEnv()` base64-decoded the raw value, so the PEM the CLI injects
// threw a FormatException that was swallowed, and the app presented a key nobody had registered.
import 'package:bella_baxter/bella_client.dart';
import 'package:bella_baxter/src/e2ee.dart';
import 'package:test/test.dart';

// A throwaway P-256 key generated for this test only — it protects nothing.
const _pem = '-----BEGIN PRIVATE KEY-----\n'
    'MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgsRj1N+yeYs4m7pH3\n'
    'We/3RD2dPnY3qn/GMnO95RIadNmhRANCAARsr5nCopK1zDCQeeJIOTdI1+lvXOI2\n'
    '6MCCkfapMFpxN9JN+8XObkqRgSSSNzBzxxUHq0I6NoXfePrhscq3iPqu\n'
    '-----END PRIVATE KEY-----';

// The same key as bare base64 PKCS#8 DER (the pre-#755 injection format).
const _base64Der =
    'MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgsRj1N+yeYs4m7pH3'
    'We/3RD2dPnY3qn/GMnO95RIadNmhRANCAARsr5nCopK1zDCQeeJIOTdI1+lvXOI2'
    '6MCCkfapMFpxN9JN+8XObkqRgSSSNzBzxxUHq0I6NoXfePrhscq3iPqu';

// Its SPKI public key, base64 — what the client must present as X-E2E-Public-Key.
const _expectedSpki =
    'MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEbK+ZwqKStcwwkHniSDk3SNfpb1ziNujAgpH2qTBacTfSTfvFzm5KkYEkkjcwc8cVB6tCOjaF33j64bHKt4j6rg==';

String _spkiOf(String envValue) {
  final der = bellaPrivateKeyFromEnvValue(envValue);
  expect(der, isNotNull);
  return e2eePublicKeyToSpkiB64(e2eeKeyPairFromPkcs8(der!));
}

void main() {
  group('bellaPrivateKeyFromEnvValue', () {
    test('loads the PEM `bella sdk run` injects', () {
      expect(_spkiOf(_pem), _expectedSpki);
    });

    test('loads a PEM that went through a CRLF editor or CI variable', () {
      expect(_spkiOf(_pem.replaceAll('\n', '\r\n')), _expectedSpki);
    });

    test('loads bare base64 PKCS#8 DER', () {
      expect(_spkiOf(_base64Der), _expectedSpki);
    });

    for (final garbage in [
      'not a key',
      '-----BEGIN PRIVATE KEY-----\nAAAA\n-----END PRIVATE KEY-----',
      'aGVsbG8gd29ybGQ=', // valid base64, not a key
    ]) {
      test('a present but unreadable key fails loudly: "$garbage"', () {
        expect(
          () => bellaPrivateKeyFromEnvValue(garbage),
          throwsA(isA<StateError>().having(
              (e) => e.message, 'message', contains('BELLA_BAXTER_PRIVATE_KEY'))),
        );
      });
    }

    for (final absent in [null, '', '  \n']) {
      test('absent or blank (${absent == null ? 'null' : '"$absent"'}) means ephemeral', () {
        expect(bellaPrivateKeyFromEnvValue(absent), isNull);
      });
    }
  });
}
