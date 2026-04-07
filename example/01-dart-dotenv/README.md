# Sample 01 — Dart dotenv (.env file)

**Pattern:** `bella secrets get` writes all secrets to a `.env` file; app reads with the `dotenv` package.

## How it works

```
bella secrets get -o .env  →  .env on disk  →  DotEnv().load()  →  env['KEY']
```

The CLI fetches secrets via E2EE and writes them to `.env`. The Dart app loads them with the `dotenv` package.

## Run

```bash
# Human dev (OAuth, not billed):
bella login
bella secrets get -o .env    # .bella file in this directory sets project/env context
dart run main.dart

# CI/CD (API key, billed per call):
bella login --api-key bax-xxxxxx    # .bella auto-created from key
bella secrets get -o .env
dart run main.dart
```

> `-p`/`-e` flags are not needed: the `.bella` file already encodes project and environment context (auto-created on API key login, or commit/create it manually).

## Security notes

- Add `.env` to `.gitignore` — never commit secrets to source control
- Secret values never leave the local machine (E2EE: decryption happens client-side)
