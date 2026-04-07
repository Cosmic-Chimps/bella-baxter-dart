# Sample 02 — Process inject (bella run)

**Pattern:** `bella run` fetches secrets and injects them as env vars into the Dart subprocess. No file written.

## How it works

```
1. bella fetches all secrets (E2EE)
2. bella spawns: dart run main.dart
3. Dart app reads them via Platform.environment['KEY']
4. No .env file is written — secrets exist only in child process memory
```

## Run

```bash
# Human dev (OAuth, not billed):
bella login                          # opens browser; .bella file in this dir sets project/env
bella run -- dart run main.dart

# CI/CD (API key, billed per call):
bella login --api-key bax-xxxxxx    # .bella auto-created with project + env
bella run -- dart run main.dart
```

> The `.bella` file in this directory already has `project` and `environment` set — no `-p`/`-e` flags needed.

## vs. dotenv file approach

| | `bella secrets get -o .env` | `bella run --` |
|---|---|---|
| Secrets written to disk | ✅ Yes | ❌ No |
| Requires dotenv package | ✅ Yes | ❌ No |
| Secret security | Filesystem | Memory only |
