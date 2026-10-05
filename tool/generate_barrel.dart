// #1162 — keeps lib/bella_baxter.dart (the package barrel) complete.
//
// lib/bella_baxter.dart is protected from the generator by .openapi-generator-ignore, because it also
// carries handwritten exports. That protection is why it went stale: by #1162 it exported 200 of 276
// generated API files and 213 of 335 models, and still named files the generator no longer writes, so
// the package did not even compile from its committed spec. The generated part is now rewritten from
// the generated folders by this script, and test/barrel_complete_test.dart fails when it is out of date.
//
//   dart run tool/generate_barrel.dart          # rewrite lib/bella_baxter.dart
//   dart run tool/generate_barrel.dart --check  # exit 1 (naming the files) when it is out of date
//
// Everything between the BEGIN/END markers is owned by this script; everything outside them (the
// handwritten exports) is kept as it is. Pure Dart, no dependencies.
import 'dart:io';

const beginMarker = '// BEGIN GENERATED EXPORTS — tool/generate_barrel.dart, do not edit by hand';
const endMarker = '// END GENERATED EXPORTS';

/// The generated files the barrel must export: every `lib/src/api/*.dart` and `lib/src/model/*.dart`
/// except the built_value parts (`*.g.dart`), as sorted `package:` URIs.
List<String> generatedExports(Directory packageRoot) {
  final uris = <String>[];
  for (final dir in ['api', 'model']) {
    final d = Directory('${packageRoot.path}/lib/src/$dir');
    if (!d.existsSync()) {
      throw StateError('${d.path} does not exist — generate the client first (apps/sdk/generate.sh, '
          'or the openapi-generator recipe in apps/sdk/contract-tests/run.sh prepare_dart)');
    }
    for (final f in d.listSync().whereType<File>()) {
      final name = f.uri.pathSegments.last;
      if (!name.endsWith('.dart') || name.endsWith('.g.dart')) continue;
      uris.add('package:bella_baxter/src/$dir/$name');
    }
  }
  uris.sort();
  return uris;
}

/// The exports currently inside the generated section of [barrel].
List<String> exportsInSection(String barrel) {
  final section = _section(barrel);
  return RegExp(r"^export '([^']+)'", multiLine: true)
      .allMatches(section.body)
      .map((m) => m.group(1)!)
      .toList();
}

/// [barrel] with its generated section replaced by [exports].
String renderBarrel(String barrel, List<String> exports) {
  final section = _section(barrel);
  final body = exports.map((u) => "export '$u';").join('\n');
  return '${barrel.substring(0, section.start)}$beginMarker\n$body\n$endMarker'
      '${barrel.substring(section.end)}';
}

class _Section {
  final int start; // offset of the BEGIN marker
  final int end; // offset just past the END marker
  final String body;
  _Section(this.start, this.end, this.body);
}

_Section _section(String barrel) {
  final start = barrel.indexOf(beginMarker);
  final endAt = barrel.indexOf(endMarker);
  if (start < 0 || endAt < start) {
    throw StateError('lib/bella_baxter.dart has no "$beginMarker" … "$endMarker" section');
  }
  return _Section(start, endAt + endMarker.length,
      barrel.substring(start + beginMarker.length, endAt));
}

void main(List<String> args) {
  final root = Directory(Platform.script.resolve('..').toFilePath());
  final barrelFile = File('${root.path}/lib/bella_baxter.dart');
  final current = barrelFile.readAsStringSync();
  final want = generatedExports(root);

  if (args.contains('--check')) {
    final have = exportsInSection(current);
    final missing = want.where((u) => !have.contains(u)).toList();
    final extra = have.where((u) => !want.contains(u)).toList();
    if (missing.isEmpty && extra.isEmpty && renderBarrel(current, want) == current) {
      stdout.writeln('lib/bella_baxter.dart exports all ${want.length} generated files.');
      return;
    }
    stderr.writeln('lib/bella_baxter.dart is out of date — run: dart run tool/generate_barrel.dart');
    for (final u in missing) stderr.writeln('  missing: $u');
    for (final u in extra) stderr.writeln('  extra (not generated): $u');
    exitCode = 1;
    return;
  }

  barrelFile.writeAsStringSync(renderBarrel(current, want));
  stdout.writeln('lib/bella_baxter.dart: ${want.length} generated exports.');
}
