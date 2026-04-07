# Sample 03 — Dart CLI (env-var mode + SDK mode)

**Pattern:** Two modes in one sample — `bella run` for simple env-var injection, or `bella exec` for SDK-fetched secrets with typed access.

## Modes

### Env-var mode (`bella run`)

`bella run` fetches all secrets and injects them as env vars into the subprocess. `AwesomeSecrets()` reads from `Platform.environment`.

```bash
bella login                          # or bella login --api-key bax-...
bella run -- dart run main.dart
```

### SDK mode (`bella exec`)

`bella exec` injects only Bella credentials (API key / OAuth token). The app itself fetches secrets via `BellaClient.pullSecretsAs(AwesomeSecrets.fromMap)`.

```bash
bella login                          # or bella login --api-key bax-...
bella exec -- dart run main.dart sdk
```

## Typed secret class

`awesome_secrets.dart` is **auto-generated** — do not edit by hand:

```bash
bella secrets generate dart --types -o awesome_secrets.dart
```

The generated class exposes all 8 secrets with proper Dart types:

```dart
final s = await BellaClient.pullSecretsAs(AwesomeSecrets.fromMap);
print(s.port);             // int  → 8080
print(s.enableFeatures);   // bool → true
print(s.databaseUrl);      // String
print(s.appConfig);        // String (raw JSON)
```

## Secrets (from demo.env)

| Key | Type | Value |
|---|---|---|
| `PORT` | int | `8080` |
| `DATABASE_URL` | String | `postgres://user:pass@host:port/dbname` |
| `EXTERNAL_API_KEY` | String | `abc123xyzAg-FFFx` |
| `GLEAP_API_KEY` | String | `az123456789xyz` |
| `ENABLE_FEATURES` | bool | `true` |
| `APP_ID` | String | `550e8400-e29b-41d4-a716-446655440000` |
| `ConnectionStrings__Postgres` | String | `conectionstringpostgres` |
| `APP_CONFIG` | String | `{"setting1": "value1", "setting2": 42}` |
