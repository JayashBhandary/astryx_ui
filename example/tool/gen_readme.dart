// This is a command-line tool: printing is how it reports.
// ignore_for_file: avoid_print

/// Turns `README.md` into documentation blocks for the landing page.
///
/// The README is written once, at the repository root, because that is what pub
/// renders on the package page and what GitHub shows to anybody who finds the
/// repository. The landing page needs the same answers — what this is, how to
/// install it, what it will not do — and a hand-written second copy of them is
/// a copy that goes stale the first time the README is edited.
///
/// So the front page does not paraphrase the README, it compiles it: this
/// script parses the markdown into `lib/docs/readme.g.dart`, and
/// `docs_landing.dart` picks the sections it wants by heading.
///
/// What it understands is exactly what the README uses:
///
/// - `## Install` — a section. Its blocks run to the next `##`.
/// - `### A custom theme` — a subsection. It becomes a `DocHeading(level: 3)`
///   inside its parent *and* an entry of its own, so the landing page can pull
///   `For AI coding agents` without the whole of `Documentation`.
/// - a fenced block — a `DocCode`, keeping the fence's language.
/// - `> quoted` — a `DocCallout`, which is what the status note is.
/// - `- item`, with two-space continuation lines — a `DocList`.
/// - anything else — a paragraph.
///
/// Two things are dropped: the `# astryx_ui` title, which the page already has
/// in its hero, and the shields.io badge row, which is a picture of facts the
/// page states in words.
///
/// Relative links are rewritten to absolute repository URLs. A link written
/// against `CHANGELOG.md` resolves on GitHub and against nothing at all on a
/// site served from `/`, so leaving them as written would put dead links on the
/// front page.
///
/// Run it from the `example/` directory, before `gen_docs_md.dart`:
///
/// ```bash
/// dart run tool/gen_readme.dart
/// dart run tool/gen_docs_md.dart
/// ```
library;

import 'dart:io';

import 'package:example/docs/issue_links.dart';

/// The README, relative to `example/`.
const String _source = '../README.md';

/// Where the parsed blocks are written, relative to `example/`.
const String _output = 'lib/docs/readme.g.dart';

/// Where a relative link in the README resolves to.
///
/// The branch is named rather than left to the default: a link to `blob/main`
/// keeps working when the reader is on a tag, and one to `blob/HEAD` does not
/// exist.
const String _blob = '$astryxRepoUrl/blob/main';

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

  final document = _parse(file.readAsLinesSync());
  if (document.sections.isEmpty) {
    stderr.writeln(
      'No `## ` sections found in $_source. Is it still markdown?',
    );
    exit(1);
  }

  File(_output).writeAsStringSync(_render(document));
  print(
    'Wrote ${document.sections.length} sections to $_output '
    '(${document.intro.length} intro blocks).',
  );
}

// ---------------------------------------------------------------------------
// The parsed shapes
// ---------------------------------------------------------------------------

/// One parsed block, in the order it appears.
sealed class _Block {
  const _Block();
}

/// A subsection heading inside a section — `### A custom theme`.
class _Heading extends _Block {
  const _Heading(this.text);

  final String text;
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

/// A fenced code block.
class _Code extends _Block {
  const _Code(this.code, this.language);

  final String code;
  final String language;
}

/// A block quote — in this README, the pre-alpha status note.
class _Quote extends _Block {
  const _Quote(this.text);

  final String text;
}

/// One `##` or `###` section, and everything under it.
class _Section {
  _Section(this.title, this.level);

  final String title;
  final int level;
  final List<_Block> blocks = <_Block>[];
}

/// The whole file: what comes before the first heading, and the sections.
class _Document {
  const _Document({required this.intro, required this.sections});

  final List<_Block> intro;
  final List<_Section> sections;
}

// ---------------------------------------------------------------------------
// Parsing
// ---------------------------------------------------------------------------

final RegExp _sectionHeading = RegExp(r'^(#{2,3})\s+(.+?)\s*$');
final RegExp _fence = RegExp('^```([a-zA-Z]*)');
final RegExp _bullet = RegExp(r'^\s*[-*]\s+(.*)$');

/// A line that is nothing but a linked badge image.
final RegExp _badge = RegExp(r'^\[!\[');

/// An inline link, for [_absolute].
final RegExp _link = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');

/// Whether [target] already says where it goes.
bool _isAbsolute(String target) =>
    target.startsWith('http://') ||
    target.startsWith('https://') ||
    target.startsWith('mailto:') ||
    target.startsWith('#');

/// Rewrites the relative links in [text] to absolute repository URLs.
String _absolute(String text) => text.replaceAllMapped(_link, (match) {
  final label = match.group(1)!;
  final target = match.group(2)!;
  if (_isAbsolute(target)) return match.group(0)!;
  final path = target.startsWith('./') ? target.substring(2) : target;
  return '[$label]($_blob/$path)';
});

/// Parses [lines] into an intro and a list of sections.
_Document _parse(List<String> lines) {
  final intro = <_Block>[];
  final sections = <_Section>[];

  // Where blocks are being appended: the intro until the first heading, then
  // the innermost open section. A `###` writes into itself *and* into the `##`
  // above it, which is what lets the landing page take either one.
  _Section? section;
  _Section? parent;

  var items = <String>[];
  var paragraph = <String>[];
  var quote = <String>[];
  var code = <String>[];
  String? fence;

  void emit(_Block block) {
    final current = section;
    if (current == null) {
      intro.add(block);
      return;
    }
    current.blocks.add(block);
    if (current != parent) parent?.blocks.add(block);
  }

  void closeParagraph() {
    if (paragraph.isEmpty) return;
    emit(_Prose(_absolute(paragraph.join(' '))));
    paragraph = <String>[];
  }

  void closeItems() {
    if (items.isEmpty) return;
    emit(_Items(<String>[for (final item in items) _absolute(item)]));
    items = <String>[];
  }

  void closeQuote() {
    if (quote.isEmpty) return;
    emit(_Quote(_absolute(quote.join(' '))));
    quote = <String>[];
  }

  void close() {
    closeParagraph();
    closeItems();
    closeQuote();
  }

  for (final line in lines) {
    // Inside a fence nothing is markup: a `#` is a comment and a `-` is a
    // flag.
    if (fence != null) {
      if (line.trimRight() == '```') {
        emit(_Code(code.join('\n'), fence.isEmpty ? 'text' : fence));
        code = <String>[];
        fence = null;
      } else {
        code.add(line);
      }
      continue;
    }

    final opening = _fence.firstMatch(line);
    if (opening != null) {
      close();
      fence = opening.group(1) ?? '';
      continue;
    }

    final heading = _sectionHeading.firstMatch(line);
    if (heading != null) {
      close();
      final level = heading.group(1)!.length;
      final title = heading.group(2)!;
      final next = _Section(title, level);
      sections.add(next);
      if (level == 2) {
        parent = next;
      } else {
        // A subsection is announced in its parent before its blocks arrive, so
        // reading the parent whole still shows where one subsection ends and
        // the next begins.
        parent?.blocks.add(_Heading(title));
      }
      section = next;
      continue;
    }

    // The title, and the badge row under it.
    if (line.startsWith('# ') || _badge.hasMatch(line)) continue;

    if (line.trim().isEmpty) {
      close();
      continue;
    }

    if (line.startsWith('>')) {
      closeParagraph();
      closeItems();
      quote.add(line.replaceFirst(RegExp('^>[ ]?'), '').trim());
      continue;
    }

    final bullet = _bullet.firstMatch(line);
    if (bullet != null) {
      closeParagraph();
      closeQuote();
      items.add(bullet.group(1)!.trim());
      continue;
    }

    // An indented line continues the item above it; the README wraps its
    // bullets at 80 columns, so most items arrive in pieces.
    if (items.isNotEmpty && line.startsWith('  ')) {
      items[items.length - 1] = '${items.last} ${line.trim()}';
      continue;
    }

    closeItems();
    closeQuote();
    paragraph.add(line.trim());
  }

  close();

  return _Document(intro: intro, sections: sections);
}

// ---------------------------------------------------------------------------
// Rendering
// ---------------------------------------------------------------------------

String _render(_Document document) {
  final out = StringBuffer('''
// GENERATED FILE — DO NOT EDIT.
//
// The README, parsed into documentation blocks.
//
// Regenerate with:
//
//   dart run tool/gen_readme.dart

/// The README, as documentation blocks.
///
/// Parsed from the repository's `README.md` by `tool/gen_readme.dart`, so the
/// landing page and the page pub serves cannot disagree about what the package
/// is, how it is installed, or what it will not do.
///
/// **Pure Dart** — see the note on `model.dart`.
library;

import 'package:example/docs/model.dart';

/// Everything above the first heading: what the package is, and the status
/// note under it.
const List<DocBlock> readmeIntro = <DocBlock>[
''');

  for (final block in document.intro) {
    _writeBlock(out, block, '  ');
  }

  out.write('''
];

/// Each `##` and `###` section, keyed by its heading.
///
/// A `##` section holds its subsections as well, so `Theming` includes
/// `A custom theme`; each subsection is also an entry of its own.
const Map<String, List<DocBlock>> readmeSections = <String, List<DocBlock>>{
''');

  for (final section in document.sections) {
    out.writeln("  '${_escape(section.title)}': <DocBlock>[");
    for (final block in section.blocks) {
      _writeBlock(out, block, '    ');
    }
    out.writeln('  ],');
  }

  out.writeln('};');
  return out.toString();
}

void _writeBlock(StringBuffer out, _Block block, String indent) {
  switch (block) {
    case _Heading(:final text):
      out.writeln("${indent}DocHeading('${_escape(text)}', level: 3),");
    case _Prose(:final text):
      out.writeln("${indent}DocProse('${_escape(text)}'),");
    case _Items(:final items):
      out.writeln('${indent}DocList(<String>[');
      for (final item in items) {
        out.writeln("$indent  '${_escape(item)}',");
      }
      out.writeln('$indent]),');
    case _Code(:final code, :final language):
      out.writeln(
        "${indent}DocCode('''${_escapeBlock(code)}''', "
        "language: '${_escape(language)}'),",
      );
    case _Quote(:final text):
      out.writeln("${indent}DocCallout.note('${_escape(text)}'),");
  }
}

/// Escapes [text] for a single-quoted Dart literal.
String _escape(String text) =>
    text.replaceAll(r'\', r'\\').replaceAll(r'$', r'\$').replaceAll("'", r"\'");

/// Escapes [text] for a triple-quoted Dart literal.
///
/// The apostrophes survive — that is the point of the triple quote — but a
/// trailing one would close the literal a character early, and `$` still
/// interpolates.
String _escapeBlock(String text) {
  final escaped = text
      .replaceAll(r'\', r'\\')
      .replaceAll(r'$', r'\$')
      .replaceAll("'''", r"\'\'\'");
  return escaped.endsWith("'")
      ? "${escaped.substring(0, escaped.length - 1)}\\'"
      : escaped;
}
