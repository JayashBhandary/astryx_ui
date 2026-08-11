// This is a command-line tool: printing is how it reports.
// ignore_for_file: avoid_print

/// Turns `CHANGELOG.md` into documentation blocks.
///
/// The changelog is written once, at the repository root, because that is where
/// pub, GitHub and a person cloning the package look for it. The site should
/// not be a second copy somebody has to remember to update — so it is not
/// written at all, it is compiled: this script parses the Keep a Changelog
/// markdown into `lib/docs/changelog.g.dart`, and the `changelog` page is that
/// list with a paragraph in front of it.
///
/// What it understands is exactly what the file uses:
///
/// - `## [0.0.6-dev]` — a release, becoming a level-2 heading.
/// - `### Added` — a section, becoming a level-3 heading.
/// - `- item`, with two-space continuation lines — a list. An indented bullet
///   is flattened into a sibling, because `DocList` does not nest.
/// - anything else — a paragraph.
///
/// Two things are dropped. The preamble above the first release is prose about
/// the format, and the page says it better in its own words. The link-reference
/// definitions at the foot (`[0.0.6-dev]: https://…/compare/…`) are markdown
/// plumbing for a renderer this site does not have; the page links to the
/// releases page instead.
///
/// Run it from the `example/` directory, before `gen_docs_md.dart`:
///
/// ```bash
/// dart run tool/gen_changelog.dart
/// dart run tool/gen_docs_md.dart
/// ```
library;

import 'dart:io';

/// The changelog, relative to `example/`.
const String _source = '../CHANGELOG.md';

/// Where the parsed blocks are written, relative to `example/`.
const String _output = 'lib/docs/changelog.g.dart';

void main() {
  if (!Directory('lib/docs').existsSync()) {
    stderr.writeln('Run this from the example/ directory.');
    exit(1);
  }

  final file = File(_source);
  if (!file.existsSync()) {
    stderr.writeln('No $_source.');
    exit(1);
  }

  final blocks = _parse(file.readAsLinesSync());
  if (blocks.isEmpty) {
    stderr.writeln(
      'No releases found in $_source. Is it still Keep a '
      'Changelog?',
    );
    exit(1);
  }

  File(_output).writeAsStringSync(_render(blocks));

  final releases = blocks.whereType<_Release>().length;
  print('Wrote $releases releases to $_output.');
}

// ---------------------------------------------------------------------------
// The parsed shapes
// ---------------------------------------------------------------------------

/// One parsed block, in the order it appears.
sealed class _Block {
  const _Block();
}

/// A release heading — `## [0.0.6-dev]`.
class _Release extends _Block {
  const _Release(this.version);

  final String version;
}

/// A section heading inside a release — `### Added`.
class _Section extends _Block {
  const _Section(this.title);

  final String title;
}

/// A paragraph of prose.
class _Prose extends _Block {
  const _Prose(this.text);

  final String text;
}

/// A bulleted list.
class _Items extends _Block {
  const _Items(this.items);

  final List<String> items;
}

// ---------------------------------------------------------------------------
// Parsing
// ---------------------------------------------------------------------------

final RegExp _releaseHeading = RegExp(r'^##\s+\[?([^\]]+?)\]?\s*$');
final RegExp _sectionHeading = RegExp(r'^###\s+(.+?)\s*$');

/// A bullet at any indent.
///
/// Indented ones are flattened into siblings rather than dropped: `DocList`
/// does not nest, and a sub-bullet swallowed into the item above it — which is
/// what the continuation rule would do with it — reads as a run-on sentence.
/// A parent that ends in a colon survives the flattening intact.
final RegExp _bullet = RegExp(r'^\s*[-*]\s+(.*)$');
final RegExp _linkDefinition = RegExp(r'^\[[^\]]+\]:\s');

/// Parses [lines] into blocks, starting at the first release heading.
List<_Block> _parse(List<String> lines) {
  final blocks = <_Block>[];

  // Everything before the first `## [` is the file's own preamble.
  var started = false;

  // The list being accumulated, and the paragraph being accumulated. Only one
  // can be open at a time; a blank line closes a paragraph, and anything that
  // is not a continuation closes a list.
  var items = <String>[];
  var paragraph = <String>[];

  void closeParagraph() {
    if (paragraph.isEmpty) return;
    blocks.add(_Prose(paragraph.join(' ')));
    paragraph = <String>[];
  }

  void closeItems() {
    if (items.isEmpty) return;
    blocks.add(_Items(items));
    items = <String>[];
  }

  void close() {
    closeParagraph();
    closeItems();
  }

  for (final line in lines) {
    final release = _releaseHeading.firstMatch(line);
    if (release != null) {
      close();
      started = true;
      blocks.add(_Release(release.group(1)!));
      continue;
    }

    if (!started) continue;
    if (_linkDefinition.hasMatch(line)) continue;

    final section = _sectionHeading.firstMatch(line);
    if (section != null) {
      close();
      blocks.add(_Section(section.group(1)!));
      continue;
    }

    if (line.trim().isEmpty) {
      close();
      continue;
    }

    final bullet = _bullet.firstMatch(line);
    if (bullet != null) {
      closeParagraph();
      items.add(bullet.group(1)!.trim());
      continue;
    }

    // An indented line continues the item above it; the changelog wraps its
    // bullets at 80 columns, so most items arrive in pieces.
    if (items.isNotEmpty && line.startsWith('  ')) {
      items[items.length - 1] = '${items.last} ${line.trim()}';
      continue;
    }

    closeItems();
    paragraph.add(line.trim());
  }

  close();

  // A release with nothing under it — `## [Unreleased]` between releases — is
  // a heading the page would render over empty space.
  return <_Block>[
    for (var i = 0; i < blocks.length; i++)
      if (!(blocks[i] is _Release &&
          (i == blocks.length - 1 || blocks[i + 1] is _Release)))
        blocks[i],
  ];
}

// ---------------------------------------------------------------------------
// Rendering
// ---------------------------------------------------------------------------

String _render(List<_Block> blocks) {
  final out = StringBuffer('''
// GENERATED FILE — DO NOT EDIT.
//
// The release history, parsed from CHANGELOG.md.
//
// Regenerate with:
//
//   dart run tool/gen_changelog.dart

/// The release history, as documentation blocks.
///
/// Parsed from the repository's `CHANGELOG.md` by `tool/gen_changelog.dart`,
/// so the page and the file pub serves cannot disagree about what shipped.
///
/// **Pure Dart** — see the note on `model.dart`.
library;

import 'package:example/docs/model.dart';

/// Every release, newest first.
const List<DocBlock> changelogBlocks = <DocBlock>[
''');

  for (final block in blocks) {
    switch (block) {
      case _Release(:final version):
        out.writeln("  DocHeading('${_escape(version)}'),");
      case _Section(:final title):
        out.writeln("  DocHeading('${_escape(title)}', level: 3),");
      case _Prose(:final text):
        out.writeln("  DocProse('${_escape(text)}'),");
      case _Items(:final items):
        out.writeln('  DocList(<String>[');
        for (final item in items) {
          out.writeln("    '${_escape(item)}',");
        }
        out.writeln('  ]),');
    }
  }

  out.writeln('];');
  return out.toString();
}

/// Escapes [text] for a single-quoted Dart literal.
String _escape(String text) =>
    text.replaceAll(r'\', r'\\').replaceAll(r'$', r'\$').replaceAll("'", r"\'");
