#!/usr/bin/env bash
# test-samples.sh — Bella Baxter Dart SDK samples test runner
# Usage: ./test-samples.sh <api-key>

set -u

BELLA_API_KEY="${1:-}"
if [ -z "$BELLA_API_KEY" ]; then
  echo "Usage: $0 <bella-api-key>"
  echo "Example: $0 bax-xxxxxxxxxxxxxxxx"
  exit 1
fi

export BELLA_BAXTER_URL="http://localhost:5522"
SAMPLES_DIR="$(cd "$(dirname "$0")/example" && pwd)"
DEMO_ENV="$(cd "$(dirname "$0")/../../.." && pwd)/demo.env"

PASS=0
FAIL=0
RESULTS=()

# ── Helpers ────────────────────────────────────────────────────────────────────

get_expected() {
  local key="$1"
  local raw
  raw=$(grep -m1 "^${key}=" "$DEMO_ENV" | cut -d'=' -f2-)
  # Strip surrounding double-quotes (dotenv format) and unescape \"
  if [ "${raw#\"}" != "$raw" ] && [ "${raw%\"}" != "$raw" ]; then
    raw="${raw#\"}"
    raw="${raw%\"}"
    raw=$(printf '%s' "$raw" | sed 's/\\"/"/g')
  fi
  printf '%s' "$raw"
}

print_header() {
  printf '\n━━━ %s %s\n' "$1" "$(printf '━%.0s' {1..50})" | cut -c1-70
}

check_value() {
  local label="$1" output="$2" key="$3"
  local expected
  expected=$(get_expected "$key")
  if echo "$output" | grep -qF "$expected"; then
    echo "  ✓ $label ($key)"
    return 0
  else
    echo "  ✗ $label ($key)  expected: $expected"
    return 1
  fi
}

check_cli_secrets() {
  local sample_name="$1" output="$2"
  local passed=0 failed=0

  check_value "PORT"                      "$output" "PORT"                       && passed=$((passed+1)) || failed=$((failed+1))
  check_value "DATABASE_URL"              "$output" "DATABASE_URL"               && passed=$((passed+1)) || failed=$((failed+1))
  check_value "EXTERNAL_API_KEY"          "$output" "EXTERNAL_API_KEY"           && passed=$((passed+1)) || failed=$((failed+1))
  check_value "GLEAP_API_KEY"             "$output" "GLEAP_API_KEY"              && passed=$((passed+1)) || failed=$((failed+1))
  check_value "ENABLE_FEATURES"           "$output" "ENABLE_FEATURES"            && passed=$((passed+1)) || failed=$((failed+1))
  check_value "APP_ID"                    "$output" "APP_ID"                     && passed=$((passed+1)) || failed=$((failed+1))
  check_value "ConnectionStrings__Postgres" "$output" "ConnectionStrings__Postgres" && passed=$((passed+1)) || failed=$((failed+1))
  check_value "APP_CONFIG"                "$output" "APP_CONFIG"                 && passed=$((passed+1)) || failed=$((failed+1))

  if [ "$failed" -eq 0 ]; then
    RESULTS+=("PASS — $sample_name ($passed/8 secrets)")
    PASS=$((PASS+1))
  else
    RESULTS+=("FAIL — $sample_name ($passed/8 secrets, $failed failed)")
    FAIL=$((FAIL+1))
  fi
}

check_server_secrets() {
  local sample_name="$1" json="$2"
  local passed=0 failed=0

  for key in PORT DATABASE_URL EXTERNAL_API_KEY GLEAP_API_KEY ENABLE_FEATURES APP_ID "ConnectionStrings__Postgres"; do
    local expected
    expected=$(get_expected "$key")
    if echo "$json" | grep -qF "$expected"; then
      echo "  ✓ $key"
      passed=$((passed+1))
    else
      echo "  ✗ $key  expected: $expected"
      failed=$((failed+1))
    fi
  done

  # APP_CONFIG contains JSON with quotes; use jq to extract and unescape
  local app_config_expected app_config_actual
  app_config_expected=$(get_expected "APP_CONFIG")
  app_config_actual=$(echo "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('APP_CONFIG',''))" 2>/dev/null)
  if [ "$app_config_actual" = "$app_config_expected" ]; then
    echo "  ✓ APP_CONFIG"
    passed=$((passed+1))
  else
    echo "  ✗ APP_CONFIG  expected: $app_config_expected"
    failed=$((failed+1))
  fi

  if [ "$failed" -eq 0 ]; then
    RESULTS+=("PASS — $sample_name ($passed/8 secrets)")
    PASS=$((PASS+1))
  else
    RESULTS+=("FAIL — $sample_name ($passed/8 secrets, $failed failed)")
    FAIL=$((FAIL+1))
  fi
}

cleanup_port() {
  local port="$1"
  lsof -ti :"$port" | while read -r pid; do
    kill "$pid" 2>/dev/null || true
  done
  sleep 1
}

wait_for_port() {
  local port="$1" max="${2:-20}"
  local i=0
  while [ $i -lt $max ]; do
    if curl -sf "http://localhost:${port}/health" >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
    i=$((i+1))
  done
  return 1
}

stop_server() {
  local pid="$1" port="$2"
  kill "$pid" 2>/dev/null || true
  cleanup_port "$port"
}

# ── Authentication ─────────────────────────────────────────────────────────────

print_header "Authentication"
echo "Logging in with API key ${BELLA_API_KEY:0:12}..."
if bella login --api-key "$BELLA_API_KEY" 2>&1; then
  echo "  ✓ Login successful"
else
  echo "  ✗ Login failed — aborting"
  exit 1
fi

# ── 01: dart-dotenv ────────────────────────────────────────────────────────────

print_header "Sample 01 — dart-dotenv (bella secrets get → .env → dart run)"
pushd "$SAMPLES_DIR/01-dart-dotenv" >/dev/null

# Write secrets to .env file
if BELLA_BAXTER_URL="$BELLA_BAXTER_URL" bella secrets get --app dart-01-dart-dotenv -o .env 2>&1; then
  echo "  ✓ bella secrets get succeeded"
else
  echo "  ✗ bella secrets get failed"
  RESULTS+=("FAIL — 01-dart-dotenv (bella secrets get failed)")
  FAIL=$((FAIL+1))
  popd >/dev/null
fi

if [ "${#RESULTS[@]}" -eq 0 ] || [ "${RESULTS[${#RESULTS[@]}-1]:0:4}" != "FAIL" ]; then
  output=$(dart run main.dart 2>&1)
  echo "--- output ---"
  echo "$output"
  echo "--------------"
  check_cli_secrets "01-dart-dotenv" "$output"
fi
popd >/dev/null 2>/dev/null || true

# ── 02: process-inject ─────────────────────────────────────────────────────────

print_header "Sample 02 — process-inject (bella run -- dart run main.dart)"
pushd "$SAMPLES_DIR/02-process-inject" >/dev/null

output=$(BELLA_BAXTER_URL="$BELLA_BAXTER_URL" bella run --app dart-02-process-inject -- dart run main.dart 2>&1)
echo "--- output ---"
echo "$output"
echo "--------------"
check_cli_secrets "02-process-inject" "$output"

popd >/dev/null

# ── 03: dart-cli (env-var mode) ────────────────────────────────────────────────

print_header "Sample 03a — dart-cli env-var mode (bella run -- dart run main.dart)"
pushd "$SAMPLES_DIR/03-dart-cli" >/dev/null

output=$(BELLA_BAXTER_URL="$BELLA_BAXTER_URL" bella run --app dart-03-dart-cli -- dart run main.dart 2>&1)
echo "--- output ---"
echo "$output"
echo "--------------"
check_cli_secrets "03-dart-cli (env mode)" "$output"

popd >/dev/null

# ── 03: dart-cli (SDK mode) ────────────────────────────────────────────────────

print_header "Sample 03b — dart-cli SDK mode (bella exec -- dart run main.dart sdk)"
pushd "$SAMPLES_DIR/03-dart-cli" >/dev/null

output=$(BELLA_BAXTER_URL="$BELLA_BAXTER_URL" bella exec --app dart-03-dart-cli -- dart run main.dart sdk 2>&1)
echo "--- output ---"
echo "$output"
echo "--------------"
check_cli_secrets "03-dart-cli (sdk mode)" "$output"

popd >/dev/null

# ── 04: dart-shelf (server) ────────────────────────────────────────────────────

print_header "Sample 04 — dart-shelf (bella exec -- dart run main.dart)"
SERVER_PORT=9090
cleanup_port $SERVER_PORT
pushd "$SAMPLES_DIR/04-dart-shelf" >/dev/null

BELLA_BAXTER_URL="$BELLA_BAXTER_URL" bella exec --app dart-04-dart-shelf -- dart run main.dart &
SERVER_PID=$!
echo "  Started server PID=$SERVER_PID on :$SERVER_PORT"

if wait_for_port $SERVER_PORT 25; then
  echo "  ✓ Server is up"

  # /health
  health=$(curl -sf "http://localhost:${SERVER_PORT}/health" 2>&1)
  echo "  /health: $health"
  if echo "$health" | grep -q '"status"'; then
    echo "  ✓ /health OK"
  else
    echo "  ✗ /health unexpected response"
  fi

  # / (all secrets)
  echo "  Checking / (all 8 secrets):"
  secrets_json=$(curl -sf "http://localhost:${SERVER_PORT}/" 2>&1)
  echo "  $secrets_json"
  check_server_secrets "04-dart-shelf" "$secrets_json"
else
  echo "  ✗ Server did not start within 25 seconds"
  RESULTS+=("FAIL — 04-dart-shelf (server did not start)")
  FAIL=$((FAIL+1))
fi

stop_server $SERVER_PID $SERVER_PORT
popd >/dev/null

# ── 05: flutter-app ────────────────────────────────────────────────────────────

print_header "Sample 05 — flutter-app (SKIPPED)"
echo "  ⚠ Skipped: Flutter uses dart-define compile-time constants."
echo "    bella exec cannot inject secrets — they must be compiled in."
echo "    Run manually: flutter run --dart-define-from-file=secrets.json"
RESULTS+=("SKIP — 05-flutter-app (compile-time dart-defines, cannot test with bella exec)")

# ── Summary ────────────────────────────────────────────────────────────────────

printf '\n━━━ Results %s\n' "$(printf '━%.0s' {1..57})" | cut -c1-70

if [ "${#RESULTS[@]}" -gt 0 ]; then
  for r in "${RESULTS[@]}"; do
    echo "  $r"
  done
fi

printf '\nTotal: %d passed, %d failed\n' "$PASS" "$FAIL"

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
