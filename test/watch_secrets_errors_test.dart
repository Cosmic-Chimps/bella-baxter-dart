// #1162 item 1 — BellaClient.watchSecrets used to swallow every failed poll and re-emit the last value, so
// a refusal (e2ee-plaintext-response), an expired credential or an outage during polling went unseen and
// the watcher kept serving stale secrets with no signal. Every failure is now an error event on the stream,
// after the re-emitted last good value, and polling carries on.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bella_baxter/bella_client.dart';
import 'package:bella_baxter/src/e2ee.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

import 'e2ee_envelope_helper.dart';

const _project = 'watch-project';
const _env = 'watch-env';
const _secretsPath = '/api/v1/projects/$_project/environments/$_env/secrets';

void main() {
  late HttpServer server;
  // One answer per poll, in order: 'v1' / 'v2' (a valid envelope carrying that value), 'plaintext', '500'.
  late List<String> answers;
  var polls = 0;

  setUp(() async {
    polls = 0;
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((req) async {
      await req.drain<void>();
      if (req.uri.path != _secretsPath) {
        req.response.statusCode = 404;
        return req.response.close();
      }
      final answer = polls < answers.length ? answers[polls] : answers.last;
      polls++;
      final presented = req.headers.value('x-e2e-public-key')!;
      Map<String, dynamic> body(String v) => {
            'environmentSlug': _env,
            'environmentName': _env,
            'secrets': {'DB_URL': v},
            'version': 1,
            'lastModified': '2026-10-04T00:00:00Z',
          };
      req.response.headers.contentType = ContentType.json;
      switch (answer) {
        case 'plaintext':
          req.response.write(jsonEncode(body('plaintext-must-not-be-read')));
        case '500':
          req.response
            ..statusCode = 500
            ..write(jsonEncode({'title': 'server error'}));
        default:
          req.response.write(jsonEncode(encryptFor(presented, utf8.encode(jsonEncode(body(answer))))));
      }
      await req.response.close();
    });
  });

  tearDown(() => server.close(force: true));

  BellaClient client() => BellaClient(BellaClientOptions(
      baseUrl: 'http://127.0.0.1:${server.port}', accessToken: 'watch-token'));

  /// The first [n] events of the stream: a value is its DB_URL, an error is the error object.
  Future<List<Object?>> firstEvents(Stream<Map<String, String>> stream, int n) {
    final events = <Object?>[];
    final done = Completer<List<Object?>>();
    late StreamSubscription<Map<String, String>> sub;
    void add(Object? e) {
      events.add(e);
      if (events.length == n && !done.isCompleted) {
        sub.cancel();
        done.complete(events);
      }
    }

    sub = stream.listen((v) => add(v['DB_URL']), onError: (Object e) => add(e));
    return done.future.timeout(const Duration(seconds: 20));
  }

  test('a failed poll is an error event after the last good value, and polling continues', () async {
    answers = ['v1', 'plaintext', '500', 'v2'];
    final events = await firstEvents(
        client().watchSecrets(
            interval: const Duration(milliseconds: 10), projectRef: _project, environmentSlug: _env),
        7);

    expect(events[0], 'v1', reason: 'poll 1 succeeded');
    expect(events[1], 'v1', reason: 'poll 2 failed: the last good value is still re-emitted');
    expect(
        events[2],
        isA<E2EEResponseError>()
            .having((e) => e.code, 'code', E2EEResponseError.plaintextResponse)
            .having((e) => e.toString(), 'toString', isNot(contains('plaintext-must-not-be-read'))),
        reason: 'poll 2: the refusal itself, unwrapped from Dio, carrying its code');
    expect(events[3], 'v1', reason: 'poll 3 failed: last good value again');
    expect(events[4], isA<DioException>().having((e) => e.response?.statusCode, 'status', 500),
        reason: 'poll 3: the 500 is delivered, not swallowed');
    expect(events[5], 'v2', reason: 'the stream stayed open and poll 4 delivered the new value');
    expect(events[6], 'v2');
    expect(events.whereType<String>(), isNot(contains('plaintext-must-not-be-read')));
  });

  test('watchSecretsAs forwards the error events too', () async {
    answers = ['v1', 'plaintext', 'v2'];
    final events = <Object?>[];
    final done = Completer<void>();
    late StreamSubscription<String?> sub;
    sub = client()
        .watchSecretsAs((m) => m['DB_URL'],
            interval: const Duration(milliseconds: 10), projectRef: _project, environmentSlug: _env)
        .listen((v) {
      events.add(v);
      if (v == 'v2' && !done.isCompleted) {
        sub.cancel();
        done.complete();
      }
    }, onError: (Object e) => events.add(e));
    await done.future.timeout(const Duration(seconds: 20));
    expect(events.whereType<E2EEResponseError>().single.code, E2EEResponseError.plaintextResponse);
  });

  test('cancelOnError: true stops at the first failure (documented)', () async {
    answers = ['v1', '500', 'v2'];
    final values = <String?>[];
    final error = Completer<Object>();
    client()
        .watchSecrets(
            interval: const Duration(milliseconds: 10), projectRef: _project, environmentSlug: _env)
        .listen((v) => values.add(v['DB_URL']), onError: error.complete, cancelOnError: true);
    expect(await error.future.timeout(const Duration(seconds: 20)), isA<DioException>());
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(values, ['v1', 'v1'], reason: 'nothing after the error reached a cancelOnError listener');
  });
}
