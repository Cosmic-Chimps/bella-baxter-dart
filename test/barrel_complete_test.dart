// #1162 item 2 — lib/bella_baxter.dart must export every generated API and model file. It is protected
// from the generator (.openapi-generator-ignore) because it carries handwritten exports, and by #1162 that
// protection had let it fall to 200 of 276 API files and 213 of 335 models, plus exports of files the
// generator no longer writes. tool/generate_barrel.dart owns its generated section; this test fails,
// naming the files, whenever the section is not what that script would write.
import 'dart:io';

import 'package:test/test.dart';

import '../tool/generate_barrel.dart' as barrel;

void main() {
  test('lib/bella_baxter.dart exports exactly the generated API and model files', () {
    final root = Directory.current; // `dart test` runs from the package root
    final current = File('${root.path}/lib/bella_baxter.dart').readAsStringSync();
    final want = barrel.generatedExports(root);
    final have = barrel.exportsInSection(current);

    final missing = want.where((u) => !have.contains(u)).toList();
    final extra = have.where((u) => !want.contains(u)).toList();
    expect([...missing.map((u) => 'missing: $u'), ...extra.map((u) => 'extra: $u')], isEmpty,
        reason: 'run `dart run tool/generate_barrel.dart` from apps/sdk/dart');
    expect(barrel.renderBarrel(current, want), current,
        reason: 'the generated section is not in the order/format the script writes — run it');
    expect(want.where((u) => u.contains('/src/api/')), isNotEmpty);
    expect(want.where((u) => u.contains('/src/model/')), isNotEmpty);
  });
}
