// This is a command-line tool: printing is how it reports.
// ignore_for_file: avoid_print

/// Extracts the documentation snippets from `lib/examples/`.
///
/// Every example in the docs is a real widget in a real file that the analyser
/// checks and the app renders. This script reads those files and writes two
/// generated libraries:
///
/// - `lib/docs/snippets.g.dart` — the source of each region, verbatim.
/// - `lib/docs/previews.g.dart` — a builder for each region's widget.
///
/// Because the preview and the code block come from the same region, a snippet
/// cannot describe something the page does not actually render.
///
/// Regions are marked like this:
///
/// ```dart
/// // #example card_login -> CardLoginExample
/// class CardLoginExample extends StatelessWidget {
///   ...
/// }
/// // #end
/// ```
///
/// Run it from the `example/` directory after changing any example:
///
/// ```bash
/// dart run tool/gen_snippets.dart
/// ```
library;

import 'dart:io';

/// One extracted region.
class _Region {
  _Region(this.id, this.widget, this.library);

  final String id;
  final String widget;
  final String library;
  final List<String> lines = <String>[];
}

final RegExp _start = RegExp(
  r'^\s*//\s*#example\s+([A-Za-z0-9_]+)\s*->\s*([A-Za-z0-9_]+)\s*$',
);
final RegExp _end = RegExp(r'^\s*//\s*#end\s*$');

void main() {
  final examplesDir = Directory('lib/examples');
  if (!examplesDir.existsSync()) {
    stderr.writeln(
      'lib/examples not found. Run this from the example/ directory.',
    );
    exit(1);
  }

  final files =
      examplesDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final regions = <_Region>[];
  final seen = <String, String>{};

  for (final file in files) {
    final library = file.path.replaceFirst('lib/', '');
    _Region? open;
    var lineNumber = 0;

    for (final line in file.readAsLinesSync()) {
      lineNumber++;
      final startMatch = _start.firstMatch(line);

      if (startMatch != null) {
        if (open != null) {
          _fail('${file.path}:$lineNumber: region "${open.id}" is not closed.');
        }
        final id = startMatch.group(1)!;
        final previous = seen[id];
        if (previous != null) {
          _fail(
            '${file.path}:$lineNumber: id "$id" already used in '
            '$previous.',
          );
        }
        seen[id] = file.path;
        open = _Region(id, startMatch.group(2)!, library);
        continue;
      }

      if (_end.hasMatch(line) && open != null) {
        if (open.lines.isEmpty) {
          _fail('${file.path}:$lineNumber: region "${open.id}" is empty.');
        }
        if (!open.lines.any((l) => l.contains(open!.widget))) {
          _fail(
            '${file.path}:$lineNumber: region "${open.id}" never mentions '
            '${open.widget}.',
          );
        }
        regions.add(open);
        open = null;
        continue;
      }

      open?.lines.add(line);
    }

    if (open != null) {
      _fail('${file.path}: region "${open.id}" is missing its `// #end`.');
    }
  }

  if (regions.isEmpty) _fail('No `// #example` regions found.');

  File('lib/docs/snippets.g.dart').writeAsStringSync(_snippets(regions));
  File('lib/docs/previews.g.dart').writeAsStringSync(_previews(regions));

  print('Wrote ${regions.length} snippets from ${files.length} files.');
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}

String _header(String description) =>
    '''
// GENERATED FILE — DO NOT EDIT.
//
// $description
//
// Regenerate with:
//
//   dart run tool/gen_snippets.dart
''';

String _snippets(List<_Region> regions) {
  final out = StringBuffer(
    _header('The source of every documented example, extracted verbatim.'),
  )..writeln('''
/// The source of each documented example, keyed by region id.
///
/// Extracted from `lib/examples/` by `tool/gen_snippets.dart`, so a code block
/// is always the code that produced the preview beside it.
library;

/// Every example's source, keyed by its region id.
const Map<String, String> docSnippets = <String, String>{''');

  for (final region in regions) {
    out
      ..writeln('  // ${region.library}')
      ..writeln("  '${region.id}':");
    final lines = _trim(region.lines);
    for (var i = 0; i < lines.length; i++) {
      final last = i == lines.length - 1;
      out.writeln("      '${_escape(lines[i])}\\n'${last ? ',' : ''}");
    }
  }

  out.writeln('};');
  return out.toString();
}

String _previews(List<_Region> regions) {
  final libraries = regions.map((r) => r.library).toSet().toList()..sort();

  final out = StringBuffer(
    _header('A builder for every documented example, by region id.'),
  )
    ..writeln('''
/// A builder for each documented example, keyed by region id.
///
/// The counterpart to `snippets.g.dart`: the same region supplies both the
/// rendered preview and the code shown beside it.
library;

import 'package:flutter/widgets.dart';''');

  for (final library in libraries) {
    out.writeln("import 'package:example/$library';");
  }

  out
    ..writeln()
    ..writeln("/// Every example's widget, keyed by its region id.")
    ..writeln(
      'final Map<String, WidgetBuilder> docPreviews = <String, WidgetBuilder>{',
    );

  for (final region in regions) {
    out.writeln("  '${region.id}': (_) => const ${region.widget}(),");
  }

  out.writeln('};');
  return out.toString();
}

/// Drops blank lines at either end of a region.
List<String> _trim(List<String> lines) {
  var start = 0;
  var end = lines.length;
  while (start < end && lines[start].trim().isEmpty) {
    start++;
  }
  while (end > start && lines[end - 1].trim().isEmpty) {
    end--;
  }
  return lines.sublist(start, end);
}

/// Escapes [line] for a single-quoted Dart literal.
String _escape(String line) => line
    .replaceAll(r'\', r'\\')
    .replaceAll(r'$', r'\$')
    .replaceAll("'", r"\'");
