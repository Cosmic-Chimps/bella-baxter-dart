# Changelog

All notable changes to the `bella_baxter` Dart SDK are documented here.

## 1.0.0

- Initial release of the `bella_baxter` Dart SDK.
- `BellaClient` with `pullSecrets()`, `pullSecretsAs<T>()`, `watchSecrets()`, `watchSecretsAs<T>()`.
- HMAC-signed API key auth (`bax-<id>-<secret>`) and Bearer JWT auth (SSO/OAuth mode).
- `BellaClient.fromEnv()` factory — auto-reads `BELLA_BAXTER_URL`, `BELLA_BAXTER_API_KEY`, `BELLA_BAXTER_ACCESS_TOKEN`.
- `SecretCache` abstract class for offline/encrypted local caching.
- End-to-end encryption (ECDH-P256 + HKDF-SHA256 + AES-256-GCM) via `BellaE2eeInterceptor`.
- ZKE (Zero-Knowledge Encryption) support via `BellaClientOptions.privateKey` (PKCS#8 DER device key).
- `WebhookSignatureVerifier` for verifying `X-Bella-Signature` on incoming webhook requests.
- `SecretsMapExtension.toEnvFormat()` — export secrets as `.env` file content.
