// This is a command-line tool: printing is how it reports.
// ignore_for_file: avoid_print

/// Renders the documentation to markdown.
///
/// The pages in `lib/docs/pages/` are pure Dart, and so is `snippets.g.dart`.
/// That is what lets this script run on the plain Dart VM and emit the same
/// documentation the app renders — one source of truth, two outputs.
///
/// Run it from the `example/` directory, after `gen_snippets.dart`:
///
/// ```bash
/// dart run tool/gen_snippets.dart
/// dart run tool/gen_docs_md.dart
/// ```
///
/// Output lands in `../doc/`: components under `components/`, guides under
/// `guides/`, and an index at `README.md`.
library;

import 'dart:io';

import 'package:example/docs/pages.dart';
import 'package:example/docs/snippets.g.dart';

/// Where the markdown goes, relative to `example/`.
// `doc`, not `docs`: the pub package layout wants singular directory
// names, and a plural one is not recognised by pub or its tooling.
const String _root = '../doc';

/// The group that is documentation *about* the package rather than a component.
const String _guideGroup = DocGroup.gettingStarted;

void main() {
  if (!Directory('lib/docs').existsSync()) {
    stderr.writeln('Run this from the example/ directory.');
    exit(1);
  }

  Directory('$_root/components').createSync(recursive: true);
  Directory('$_root/guides').createSync(recursive: true);

  // Written pages only. The site also carries placeholders for everything
  // upstream ships (see `lib/docs/pages/planned/`); publishing an empty file
  // for each would fill `doc/` with pages that say nothing and would let the
  // index claim coverage the package does not have. The index lists them, with
  // their status, which is the honest version of the same information.
  final written = writtenDocPages.toList();
  for (final page in written) {
    File('$_root/${_pathOf(page)}').writeAsStringSync(_render(page));
  }

  File('$_root/README.md').writeAsStringSync(_index());

  final planned = docPages.length - written.length;
  print(
    'Wrote ${written.length} pages and an index to $_root/ '
    '($planned placeholders skipped).',
  );
}

/// How an unwritten page's state reads in the index.
String _statusLabel(DocStatus status) => switch (status) {
  DocStatus.ready => 'written',
  DocStatus.stub => 'ported, not written up',
  DocStatus.planned => 'not ported yet',
  DocStatus.notPlanned => 'not planned',
};

/// The file a page is written to, relative to [_root].
String _pathOf(DocPage page) => '${_dirOf(page)}/${page.id}.md';

/// The directory a page lives in, relative to [_root].
String _dirOf(DocPage page) =>
    page.group == _guideGroup ? 'guides' : 'components';

/// A link from [from] to the page with id [target].
///
/// Falls back to the raw target, so an external URL passes through untouched.
String _link(DocPage from, String target) {
  final page = docPageOrNull(target);
  if (page == null) return target;
  final sameDirectory = _dirOf(page) == _dirOf(from);
  return sameDirectory ? '${page.id}.md' : '../${_dirOf(page)}/${page.id}.md';
}

/// Rewrites the page-id links in [text] to relative markdown paths.
String _links(DocPage from, String text) => text.replaceAllMapped(
  RegExp(r'\[([^\]]+)\]\(([^)]+)\)'),
  (match) => '[${match.group(1)}](${_link(from, match.group(2)!)})',
);

String _render(DocPage page) {
  final out = StringBuffer()
    ..writeln('---')
    ..writeln('title: ${page.title}')
    ..writeln('description: ${_yaml(page.description)}');

  if (page.group != _guideGroup) out.writeln('component: true');
  out.writeln('group: ${_yaml(page.group)}');
  if (page.source != null) out.writeln('source: ${page.source}');
  if (page.upstream != null) out.writeln('upstream: ${_yaml(page.upstream!)}');
  out
    ..writeln('---')
    ..writeln()
    ..writeln('<!-- GENERATED FILE — DO NOT EDIT.')
    ..writeln('     Source: example/lib/docs/pages/')
    ..writeln('     Regenerate: cd example && dart run tool/gen_docs_md.dart')
    ..writeln('-->')
    ..writeln();

  for (final block in page.blocks) {
    out.writeln(_block(page, block));
  }

  return out.toString();
}

String _block(DocPage page, DocBlock block) => switch (block) {
  DocHeading() => '${'#' * (block.level)} ${block.text}\n',
  DocProse() => '${_links(page, block.text)}\n',
  DocList() => _list(page, block),
  DocExample() => _example(page, block),
  DocCode() => _fence(block.code, block.language, title: block.title),
  DocTree() => _fence(block.tree, 'text'),
  DocCallout() =>
    '> **${block.kind.label}**\n>\n> ${_links(page, block.text)}\n',
  DocApi() => _api(page, block),
  DocTable() => _table(page, block.headers, block.rows, title: block.title),
};

String _list(DocPage page, DocList block) {
  final out = StringBuffer();
  for (var i = 0; i < block.items.length; i++) {
    final marker = block.ordered ? '${i + 1}.' : '-';
    out.writeln('$marker ${_links(page, block.items[i])}');
  }
  return out.toString();
}

String _example(DocPage page, DocExample block) {
  final source = docSnippets[block.snippetId];
  final out = StringBuffer();

  if (block.title != null) out.writeln('**${_links(page, block.title!)}**\n');

  if (source == null) {
    out.writeln(
      '> **Missing snippet** `${block.snippetId}`. Run '
      '`dart run tool/gen_snippets.dart`.\n',
    );
  } else {
    out.writeln(_fence(source.trimRight(), 'dart'));
  }

  if (block.note != null) out.writeln('${_links(page, block.note!)}\n');
  return out.toString();
}

String _api(DocPage page, DocApi block) {
  final out = StringBuffer()..writeln('### ${block.title}\n');
  if (block.description != null) {
    out.writeln('${_links(page, block.description!)}\n');
  }

  return (out..writeln(
        _table(
          page,
          const <String>['Property', 'Type', 'Default', 'Description'],
          <List<String>>[
            for (final prop in block.props)
              <String>[
                '`${prop.name}`${prop.required ? ' *(required)*' : ''}',
                '`${prop.type}`',
                _default(prop.defaultValue),
                prop.description,
              ],
          ],
        ),
      ))
      .toString();
}

String _table(
  DocPage page,
  List<String> headers,
  List<List<String>> rows, {
  String? title,
}) {
  final out = StringBuffer();
  if (title != null) out.writeln('**${_links(page, title)}**\n');

  out
    ..writeln("| ${headers.map(_heading).join(' | ')} |")
    ..writeln('| ${headers.map((_) => '---').join(' | ')} |');

  for (final row in rows) {
    final cells = <String>[
      for (final cell in row) _cell(_links(page, cell)),
    ];
    out.writeln('| ${cells.join(' | ')} |');
  }

  return out.toString();
}

/// A default, or an em dash where there is none.
String _default(String? value) => value == null ? '—' : '`$value`';

/// A blank heading still needs a cell, or the row and the rule disagree.
String _heading(String header) => header.isEmpty ? ' ' : header;

/// Escapes what would otherwise end a markdown table cell.
String _cell(String text) => text.replaceAll('|', r'\|');

String _fence(String code, String language, {String? title}) {
  final out = StringBuffer();
  if (title != null) out.writeln('*$title*\n');
  out
    ..writeln('```$language')
    ..writeln(code)
    ..writeln('```');
  return out.toString();
}

/// Quotes a YAML scalar when it needs it.
String _yaml(String value) => RegExp(r'''^[\w][^:#'"]*$''').hasMatch(value)
    ? value
    : "'${value.replaceAll("'", "''")}'";

String _index() {
  final out = StringBuffer()
    ..writeln('# astryx_ui documentation')
    ..writeln()
    ..writeln(
      'Generated from `example/lib/docs/pages/`. Every code block is '
      'extracted from a real, compiling widget in `example/lib/examples/`, '
      'so a snippet here cannot describe something the package does not '
      'do.',
    )
    ..writeln()
    ..writeln(
      'The same pages render as a live site: `cd example && flutter run '
      '-d chrome`.',
    )
    ..writeln();

  for (final entry in docPagesByGroup.entries) {
    out
      ..writeln('## ${entry.key}')
      ..writeln();
    for (final page in entry.value) {
      // A placeholder has no file to link to, so it is named but not linked,
      // and says why.
      out.writeln(
        page.isWritten
            ? '- [${page.title}](${_pathOf(page)}) — ${page.description}'
            : '- ${page.title} — ${page.description} '
                  '*(${_statusLabel(page.status)})*',
      );
    }
    out.writeln();
  }

  return out.toString();
}
