import 'dart:io';
import 'package:bella_baxter/bella_client.dart';

import 'awesome_secrets.dart';

/// Sample 03: Dart CLI app — typed secrets via BellaClient.pullSecretsAs.
///
/// The generated class (awesome_secrets.dart) has two modes:
///
///   Mode A — env-var (bella run injects secrets into env):
///     bella run -- dart main.dart
///     → AwesomeSecrets() reads from Platform.environment
///
///   Mode B — SDK (bella exec only injects credentials, app fetches secrets):
///     bella exec -- dart main.dart sdk
///     → client.pullSecretsAs(AwesomeSecrets.fromMap) fetches & types in one call
///
/// Generate / update the typed class:
///   bella secrets generate dart --types -o awesome_secrets.dart
void main(List<String> args) async {
  if (args.contains('sdk')) {
    await _runSdkMode();
  } else {
    _runEnvMode();
  }
}

// ---------------------------------------------------------------------------
// Mode A: bella run injects all secrets as env vars before the process starts.
//   bella run -- dart main.dart
// ---------------------------------------------------------------------------
void _runEnvMode() {
  final s = AwesomeSecrets();

  stdout.writeln('=== Typed secrets — env-var mode ===');
  stdout.writeln('Run with: bella run -- dart main.dart\n');

  stdout.writeln('PORT                      : ${s.port}  (${s.port.runtimeType})');
  stdout.writeln('DATABASE_URL              : ${s.databaseUrl}');
  stdout.writeln('EXTERNAL_API_KEY          : ${s.externalApiKey}');
  stdout.writeln('GLEAP_API_KEY             : ${s.gleapApiKey}');
  stdout.writeln('ENABLE_FEATURES           : ${s.enableFeatures}  (${s.enableFeatures.runtimeType})');
  stdout.writeln('APP_ID                    : ${s.appId}');
  stdout.writeln('ConnectionStrings__Postgres: ${s.connectionstringsPostgres}');
  stdout.writeln('APP_CONFIG                : ${s.appConfig.replaceAll(r'\"', '"')}');
  stdout.writeln('\nApp is ready.');
}

// ---------------------------------------------------------------------------
// Mode B: bella exec injects ONLY credentials (BELLA_BAXTER_API_KEY + URL).
//   The app fetches its own secrets at startup via pullSecretsAs.
//   bella exec -- dart main.dart sdk
// ---------------------------------------------------------------------------
Future<void> _runSdkMode() async {
  stdout.writeln('=== Typed secrets — SDK mode ===');
  stdout.writeln('Run with: bella exec -- dart main.dart sdk\n');

  final client = BellaClient.fromEnv();
  stdout.writeln('Pulling secrets from Bella...');

  // pullSecretsAs fetches the raw map then passes it through AwesomeSecrets.fromMap
  final s = await client.pullSecretsAs(AwesomeSecrets.fromMap);

  stdout.writeln('Loaded ${s.secretCount} secret(s)\n');

  stdout.writeln('PORT                      : ${s.port}  (${s.port.runtimeType})');
  stdout.writeln('DATABASE_URL              : ${s.databaseUrl}');
  stdout.writeln('EXTERNAL_API_KEY          : ${s.externalApiKey}');
  stdout.writeln('GLEAP_API_KEY             : ${s.gleapApiKey}');
  stdout.writeln('ENABLE_FEATURES           : ${s.enableFeatures}  (${s.enableFeatures.runtimeType})');
  stdout.writeln('APP_ID                    : ${s.appId}');
  stdout.writeln('ConnectionStrings__Postgres: ${s.connectionstringsPostgres}');
  stdout.writeln('APP_CONFIG                : ${s.appConfig.replaceAll(r'\"', '"')}');
  stdout.writeln('\nApp is ready.');
}
