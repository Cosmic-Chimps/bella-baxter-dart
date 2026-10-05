// #1162 item 5 — the E2EE key is presented on EVERY envelope-required read (SDK_CONTRACT.md, "Rule: the key
// is presented on every envelope-required read"), decided by the interceptor through requiresEnvelope, not
// per public method. It used to be presented on getAllEnvironmentSecrets only. Each read's plaintext is
// handed on unchanged — an array (listSecrets) or a single item (getSecret) as much as the full response.
import 'dart:convert';
import 'dart:io';

import 'package:bella_baxter/bella_client.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

import 'e2ee_envelope_helper.dart';

const _base = '/api/v1/projects/p/environments/e';
final _item = {
  'key': 'DB_URL',
  'value': 'postgres://presented',
  'description': null,
  'createdAt': '2026-01-01T00:00:00Z',
  'updatedAt': '2026-01-01T00:00:00Z',
  'type': null,
};

/// The seven envelope-required reads, each with the plaintext the API encrypts for it.
final _reads = <String, (String, Object)>{
  'getAllEnvironmentSecrets': (
    '$_base/secrets',
    {
      'environmentSlug': 'e',
      'environmentName': 'e',
      'secrets': {'DB_URL': 'postgres://presented'},
      'version': 1,
      'lastModified': '2026-01-01T00:00:00Z',
    }
  ),
  'exportEnvironmentSecrets': ('$_base/secrets/export?format=json', {'DB_URL': 'postgres://presented'}),
  'listSecrets': ('$_base/providers/v/secrets', [_item]),
  'exportSecrets': ('$_base/providers/v/secrets/export?format=json', {'DB_URL': 'postgres://presented'}),
  'getSecret': ('$_base/providers/v/secrets/DB_URL', _item),
  'getSecretVersion': ('$_base/providers/v/secrets/DB_URL/versions/3', _item),
  'listGlobalSecrets': (
    '/api/v1/projects/p/secrets',
    {
      'projectRef': 'p',
      'projectSlug': 'p',
      'globalSecretProviderId': null,
      'secrets': [_item],
    }
  ),
};

void main() {
  late HttpServer server;
  final presented = <String, String?>{}; // path → presented key
  final wrappedDekCalls = <List<String>>[];

  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((req) async {
      await req.drain<void>();
      final key = req.headers.value('x-e2e-public-key');
      presented[req.uri.path] = key;
      req.response.headers.contentType = ContentType.json;
      if (req.uri.path == '$_base/secrets/version') {
        req.response.write(jsonEncode({'environmentSlug': 'e', 'version': 7}));
        return req.response.close();
      }
      final read = _reads.values.where((r) => Uri.parse(r.$1).path == req.uri.path).firstOrNull;
      if (read == null || key == null) {
        req.response.statusCode = read == null ? 404 : 400;
        return req.response.close();
      }
      if (req.uri.path == '$_base/providers/v/secrets') {
        req.response.headers.set('X-Bella-Wrapped-Dek', 'd3JhcHBlZA==');
      }
      req.response.write(jsonEncode(encryptFor(key, utf8.encode(jsonEncode(read.$2)))));
      await req.response.close();
    });
  });

  tearDownAll(() => server.close(force: true));

  BellaClient client() => BellaClient(BellaClientOptions(
        baseUrl: 'http://127.0.0.1:${server.port}',
        accessToken: 'presentation-token',
        onWrappedDekReceived: (p, e, dek, _) => wrappedDekCalls.add([p, e, dek]),
      ));

  for (final MapEntry(key: op, value: (path, plaintext)) in _reads.entries) {
    test('$op presents the key and hands on its plaintext unchanged', () async {
      final resp = await client().api.dio.get<Object?>(path);
      expect(presented[Uri.parse(path).path], isNotNull, reason: '$op must present X-E2E-Public-Key');
      expect(resp.data, plaintext);
    });
  }

  test('the plaintext keeps the representation the request asked for (String, bytes)', () async {
    final (path, plaintext) = _reads['getSecret']!;
    final asString = await client().api.dio.get<String>(path,
        options: Options(responseType: ResponseType.plain));
    expect(jsonDecode(asString.data!), plaintext);
    final asBytes = await client().api.dio.get<List<int>>(path,
        options: Options(responseType: ResponseType.bytes));
    expect(jsonDecode(utf8.decode(asBytes.data!)), plaintext);
  });

  test('a read that carries no value does not present the key', () async {
    final resp = await client().api.dio.get<Object?>('$_base/secrets/version');
    expect(presented['$_base/secrets/version'], isNull);
    expect(resp.data, {'environmentSlug': 'e', 'version': 7});
  });

  test('pullSecrets still presents and decrypts', () async {
    final secrets = await client().pullSecrets(projectRef: 'p', environmentSlug: 'e');
    expect(secrets, {'DB_URL': 'postgres://presented'});
  });

  test('a wrapped DEK on a provider read reports its project and environment slugs', () async {
    wrappedDekCalls.clear();
    await client().api.dio.get<Object?>('$_base/providers/v/secrets');
    expect(wrappedDekCalls, [
      ['p', 'e', 'd3JhcHBlZA==']
    ]);
  });
}
