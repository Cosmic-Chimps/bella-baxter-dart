# bella_baxter

Official Dart SDK for [Bella Baxter](https://bella-baxter.io) — the secure secret management gateway for teams.

Pull secrets from Vault, AWS Secrets Manager, Azure Key Vault, and GCP Secret Manager via one unified API.

## Features

- 🔑 **HMAC-signed API keys** (`bax-<id>-<secret>`) and **Bearer JWT / SSO** auth
- 🔄 **Real-time polling** via `watchSecrets()` — a `Stream` that emits fresh secrets on an interval
- �� **End-to-end encryption** (ECDH-P256 + HKDF-SHA256 + AES-256-GCM) — server never sees plaintext on the wire
- 🔐 **ZKE (Zero-Knowledge Encryption)** — persistent device key for offline-capable decryption
- 📦 **Offline-first caching** — `SecretCache` abstract class; inject your own encrypted storage
- 🪝 **Webhook verification** — `WebhookSignatureVerifier` for `X-Bella-Signature` headers
- 📝 **.env export** — `SecretsMapExtension.toEnvFormat()`

## Installation

```yaml
dependencies:
  bella_baxter: ^1.0.0
```

## Quick start

```dart
import 'package:bella_baxter/bella_client.dart';

void main() async {
  // Auto-detect from environment (works with bella exec)
  final client = BellaClient.fromEnv();
  final secrets = await client.pullSecrets();

  print(secrets['DATABASE_URL']); // postgresql://...
}
```

### Environment variables (set by `bella exec`)

| Variable | Description |
|----------|-------------|
| `BELLA_BAXTER_URL` | API base URL |
| `BELLA_BAXTER_API_KEY` | HMAC API key (`bax-<id>-<secret>`) |
| `BELLA_BAXTER_ACCESS_TOKEN` | Bearer JWT (SSO/OAuth mode) |

## API key mode

```dart
final client = BellaClient(BellaClientOptions(
  baseUrl: 'https://api.example.com',
  apiKey: 'bax-myKeyId-abc123def456...',
));

final secrets = await client.pullSecrets();
```

## Typed secrets

Generate a typed secrets class with `bella secrets generate dart --types`, then:

```dart
// AppSecrets is your generated class
final secrets = await client.pullSecretsAs(AppSecrets.fromMap);
print(secrets.databaseUrl);
print(secrets.apiPort);
```

## Real-time polling

```dart
client.watchSecrets(interval: Duration(minutes: 5)).listen((secrets) {
  // Called immediately, then every 5 minutes
  setState(() => _dbUrl = secrets['DATABASE_URL']);
});
```

## Offline-first caching

```dart
final client = BellaClient(BellaClientOptions(
  baseUrl: '...',
  apiKey: '...',
  cache: MyEncryptedSecretCache(),  // your SecretCache implementation
));
```

For Flutter, use `FlutterSecureSecretCache` from the `bella_baxter_flutter` package.

## Webhook verification

```dart
final isValid = WebhookSignatureVerifier.verify(
  secret: 'whsec-your-signing-secret',
  signatureHeader: request.headers['X-Bella-Signature']!,
  rawBody: await request.bodyAsString(),
);
```

## ZKE (Zero-Knowledge Encryption)

```dart
import 'dart:typed_data';

// Load your device key (PKCS#8 DER, from bella auth setup)
final derBytes = await loadDeviceKey(); // your storage logic

final client = BellaClient(BellaClientOptions(
  baseUrl: '...',
  apiKey: '...',
  privateKey: Uint8List.fromList(derBytes),
));
```

## Examples

See [`example/`](example/) for working samples:

- `01-dart-dotenv` — load secrets from `.env` file
- `02-process-inject` — `bella exec` process injection
- `03-dart-cli` — CLI app (env-var mode + SDK mode)
- `04-dart-shelf` — HTTP server with secrets
- `05-flutter-app` — Flutter app with `SecretCache`

## Links

- [Bella Baxter documentation](https://docs.bella-baxter.io)
- [GitHub repository](https://github.com/Cosmic-Chimps/bella-baxter-dart)
- [Issue tracker](https://github.com/Cosmic-Chimps/bella-baxter-dart/issues)
- [`bella_baxter_flutter`](https://pub.dev/packages/bella_baxter_flutter) — Flutter-specific `SecretCache` implementation
