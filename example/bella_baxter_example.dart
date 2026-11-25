/// Example: fetch secrets from Bella Baxter with an API key.
///
/// Prerequisites:
/// 1. Create an API key for your environment in the Bella Baxter console.
/// 2. Run the example through the CLI, which sets the variables the client reads
///    (`BELLA_BAXTER_URL` and `BELLA_BAXTER_API_KEY`):
///
///   bella sdk run -- dart run example/bella_baxter_example.dart
///
/// Or set those two variables yourself and run `dart run example/bella_baxter_example.dart`.
library;

import 'dart:io';

import 'package:bella_baxter/bella_client.dart';

Future<void> main() async {
  final BellaClient client;
  try {
    // Reads BELLA_BAXTER_URL and BELLA_BAXTER_API_KEY (or BELLA_BAXTER_ACCESS_TOKEN).
    client = BellaClient.fromEnv();
  } on StateError catch (e) {
    stderr.writeln(e.message);
    exit(1);
  }

  // The secrets of the environment the API key is scoped to. Values are never printed.
  final secrets = await client.pullSecrets();
  for (final key in secrets.keys) {
    print('$key=***');
  }

  print('Fetched ${secrets.length} secret(s).');
}
