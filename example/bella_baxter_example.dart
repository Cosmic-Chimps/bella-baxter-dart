/// Example: fetch secrets from Bella Baxter using an API key.
///
/// Prerequisites:
/// 1. Create an API key for your environment at https://app.bella-baxter.io
/// 2. Set the `BELLA_API_KEY` environment variable
///
/// Run:
///   dart run example/bella_baxter_example.dart
library;

import 'dart:io';

import 'package:bella_baxter/bella_baxter.dart';

void main() async {
  final apiKey = Platform.environment['BELLA_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    stderr.writeln('Set BELLA_API_KEY environment variable to run this example.');
    exit(1);
  }

  final client = BellaBaxter.withApiKey(apiKey);

  // List secrets for the environment scoped to this API key
  final secrets = await client.secrets.listSecrets();
  for (final entry in secrets.entries) {
    print('${entry.key}=***');
  }

  print('Fetched ${secrets.length} secret(s).');
}
