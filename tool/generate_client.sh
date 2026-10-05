#!/usr/bin/env bash
# #1162 — generate the dart-dio client (lib/src/api/, lib/src/model/, gitignored) from the COMMITTED
# openapi.json, so the handwritten tests can run. Used by apps/sdk/contract-tests/run.sh (prepare_dart) and by
# the Dart unit-test step in .github/workflows/sdk-key-contract.yml; one recipe, so the two cannot drift.
#
#   apps/sdk/dart/tool/generate_client.sh [log-dir]
#
# Needs docker and dart. The generator image is pinned by digest (v7.20.0) because it rewrites a TRACKED file,
# lib/src/api.dart: after running, `git diff apps/sdk/dart/lib/src/api.dart` must be empty unless the spec
# changed. The barrel (lib/bella_baxter.dart) is protected from the generator; keep it complete with
# `dart run tool/generate_barrel.dart`.
set -euo pipefail

D=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
LOGS=${1:-$(mktemp -d)}
mkdir -p "$LOGS"
OPENAPI_GENERATOR_IMAGE=openapitools/openapi-generator-cli@sha256:fa4add01856e44becf70674164df354d61bd37ba0f444d27be949801e013921b

docker run --rm --user "$(id -u):$(id -g)" -v "$D/openapi.json:/openapi.json:ro" -v "$D:/output" \
  "$OPENAPI_GENERATOR_IMAGE" generate -i /openapi.json -g dart-dio -o /output \
  --additional-properties=pubName=bella_baxter,nullSafe=true,browserClient=false \
  --skip-validate-spec >"$LOGS/dart-generate.log" 2>&1 \
  || { cat "$LOGS/dart-generate.log" >&2; exit 1; }
(cd "$D" && { dart fix --apply lib/src/api/ >/dev/null 2>&1 || true; })
find "$D/lib/src/model" -name '*.g.dart' -exec perl -pi -e 's/^abstract class (_\$[A-Za-z]*Mixin) \{$/mixin $1 {/' {} +
(cd "$D" && dart pub get >/dev/null && dart run build_runner build --delete-conflicting-outputs >"$LOGS/dart-build-runner.log" 2>&1) \
  || { cat "$LOGS/dart-build-runner.log" >&2; exit 1; }
