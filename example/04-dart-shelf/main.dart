import 'dart:convert';
import 'dart:io';
import 'package:bella_baxter/bella_client.dart' show BellaClient;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

/// Sample 02: Dart shelf web server — load secrets before serving requests.
///
/// Pattern: pull secrets once at startup, pass them into your handlers.
/// The project + environment are auto-discovered from the API key.
///
/// Run with bella exec so credentials are injected automatically:
///   bella exec -- dart main.dart
void main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '9090') ?? 9090;

  // ── Load secrets before starting the server ───────────────────────────────
  stderr.writeln('[Bella] Loading secrets...');

  final client = BellaClient.fromEnv();
  final secrets = await client.pullSecrets();
  stderr.writeln('[Bella] Loaded ${secrets.length} secret(s)');

  // ── Build and start the shelf server ─────────────────────────────────────
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router(secrets));

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  stderr.writeln('[Server] Listening on http://localhost:${server.port}');
}

Handler _router(Map<String, String> secrets) {
  return (Request request) {
    switch (request.url.path) {
      case '':
      case '/':
        return _handleRoot(secrets);
      case 'health':
      case '/health':
        return _handleHealth();
      default:
        return Response.notFound('Not found');
    }
  };
}

Response _handleRoot(Map<String, String> secrets) {
  final body = jsonEncode({
    'PORT': secrets['PORT'] ?? '',
    'DATABASE_URL': secrets['DATABASE_URL'] ?? '',
    'EXTERNAL_API_KEY': secrets['EXTERNAL_API_KEY'] ?? '',
    'GLEAP_API_KEY': secrets['GLEAP_API_KEY'] ?? '',
    'ENABLE_FEATURES': secrets['ENABLE_FEATURES'] ?? '',
    'APP_ID': secrets['APP_ID'] ?? '',
    'ConnectionStrings__Postgres': secrets['ConnectionStrings__Postgres'] ?? '',
    'APP_CONFIG': (secrets['APP_CONFIG'] ?? '').replaceAll(r'\"', '"'),
  });
  return Response.ok(body, headers: {'content-type': 'application/json'});
}

Response _handleHealth() {
  return Response.ok(
    jsonEncode({'status': 'ok'}),
    headers: {'content-type': 'application/json'},
  );
}
