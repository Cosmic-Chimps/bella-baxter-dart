import 'dart:io';
import 'package:dotenv/dotenv.dart';

/// Sample 01: Dart app — reads secrets from a .env file written by bella.
void main() {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  print('=== Bella Baxter: .env file sample (Dart) ===');
  print('PORT                      : ${env['PORT'] ?? '(not set)'}');
  print('DATABASE_URL              : ${env['DATABASE_URL'] ?? '(not set)'}');
  print('EXTERNAL_API_KEY          : ${env['EXTERNAL_API_KEY'] ?? '(not set)'}');
  print('GLEAP_API_KEY             : ${env['GLEAP_API_KEY'] ?? '(not set)'}');
  print('ENABLE_FEATURES           : ${env['ENABLE_FEATURES'] ?? '(not set)'}');
  print('APP_ID                    : ${env['APP_ID'] ?? '(not set)'}');
  print('ConnectionStrings__Postgres: ${env['ConnectionStrings__Postgres'] ?? '(not set)'}');
  print('APP_CONFIG                : ${env['APP_CONFIG']?.replaceAll(r'\\\"', '"').replaceAll(r'\"', '"') ?? '(not set)'}');

  exit(0);
}

