# Sample 04 — Dart shelf server (SDK mode)

**Pattern:** `bella exec` injects credentials; shelf server fetches its own secrets via `BellaClient.pullSecrets()` at startup, then returns them on every request.

## Run

```bash
# API key (recommended for servers — billed per call):
bella login --api-key bax-...
bella exec -- dart run main.dart

# OAuth (human dev — not billed):
bella login                          # .bella file in this dir provides project/env context
bella exec -- dart run main.dart
```

## Endpoints

| Endpoint | Response |
|---|---|
| `GET /health` | `{"status": "ok"}` |
| `GET /` | All 8 secrets as JSON (`PORT`, `DATABASE_URL`, `EXTERNAL_API_KEY`, `GLEAP_API_KEY`, `ENABLE_FEATURES`, `APP_ID`, `ConnectionStrings__Postgres`, `APP_CONFIG`) |

## Default port

The shelf server listens on **port 9090** by default (`Platform.environment['PORT'] ?? '9090'`).

> Note: the `PORT` secret value (`8080`) comes from Bella and is returned in the JSON response, but the server itself starts on 9090 — `bella exec` injects credentials only, not secret values as env vars.

## Why no .bella file?

`.bella` is only needed for commands like `bella run` and `bella secrets get` that need to know the project/env upfront. `bella exec` only injects credentials — the `BellaClient` SDK discovers project + env from the API key at runtime via `/api/v1/keys/me`.

When using OAuth, `bella exec` needs a `.bella` file to resolve project/env context.
