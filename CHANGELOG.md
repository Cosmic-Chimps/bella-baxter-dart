# Changelog

All notable changes to the `bella_baxter` Dart SDK are documented here.

## Unreleased

**Source-breaking for callers that read `.data` of the calls below. The next release of this SDK must NOT be a patch
release** (a minor at least; `pubspec.yaml` is at `0.1.2`).

The API contract this SDK is generated from was regenerated after the server's HTTP library moved to WolverineFx 6.65
(#1005). Three things in the generated client changed with it:

- **31 operations whose responses carry no body now return `Future<Response<void>>` instead of
  `Future<Response<JsonObject>>`.** They are the operations that answer `204 No Content`; the old contract described an
  empty JSON object that the server never sent, so `.data` was always `null` at run time and now does not type-check.
  Examples: `revokeLease`, `deleteProvider`, `revokeZkeDevice`. The whole list: `declineTenantInvite`,
  `revokeTenantInvite`, `leaveTenant`, `transferTenantOwnership`, `RemoveTenantUser`, `suspendTenantMember`,
  `restoreTenantMember`, `deleteAuditStreamDestination`, `cancelAuditStreamReplay`, `disablePaidUsage`,
  `deleteTrustDomain`, `revokeMyConnectedAppGrant`, `revokeMcpConnection`, `removeMyPasskey`, `revokeLease`,
  `releaseNodeBinding`, `deletePkiRole`, `withdrawEnvironmentSecurityInsightAcknowledgement`, `deleteSshRole`,
  `deleteWorkloadIdentity`, `assignProvidersToProject`, `unassignProviderFromProject`,
  `withdrawProjectSecurityInsightAcknowledgement`, `deleteProvider`, `revokeShare`, `decideAuthorityName`,
  `revokeTenantConnectedAppGrant`, `deleteDeveloperApp`, `revokeZkeDevice`, `removeSso`, `releaseSsoDomain`.
  Drop the `.data` read; the status code is on the `Response` as before.
- **`resumeProjectTransfer`'s `resumeProjectTransferCommand` parameter is now optional.** An empty body means the same
  as `{}`: resume without accepting the unmovable items. A call that passes a command is unchanged.
- **`getEnvironmentsByProject` (what `BellaClient.listEnvironments` calls): `includeArchived` now documents its default,
  `false`.** Nothing changes at run time; the generated parameter carries the default.

- Initial release of the `bella_baxter` Dart SDK.
- `BellaClient` with `pullSecrets()`, `pullSecretsAs<T>()`, `watchSecrets()`, `watchSecretsAs<T>()`.
- HMAC-signed API key auth (`bax-<id>-<secret>`) and Bearer JWT auth (SSO/OAuth mode).
- `BellaClient.fromEnv()` factory — auto-reads `BELLA_BAXTER_URL`, `BELLA_BAXTER_API_KEY`, `BELLA_BAXTER_ACCESS_TOKEN`.
- `SecretCache` abstract class for offline/encrypted local caching.
- End-to-end encryption (ECDH-P256 + HKDF-SHA256 + AES-256-GCM) via `BellaE2eeInterceptor`.
- Device key support (device-bound encryption) via `BellaClientOptions.privateKey` (PKCS#8 DER device key).
- `WebhookSignatureVerifier` for verifying `X-Bella-Signature` on incoming webhook requests.
- `SecretsMapExtension.toEnvFormat()` — export secrets as `.env` file content.
