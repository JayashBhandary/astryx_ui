/// Checks the site against the upstream one it mirrors.
///
/// `test/upstream_pages.txt` is every URL in `astryx.atmeta.com/sitemap.xml`,
/// captured on 2026-08-10. Without a check like this the port drifts silently:
/// upstream ships a component, nobody notices, and the gap is invisible because
/// a missing page looks exactly like a component nobody has thought about.
///
/// The fixture lives beside the test rather than in `scrape/`, which is
/// git-ignored — a check whose data is absent from a fresh clone is not a
/// check. Refresh it by re-capturing the sitemap; `scrape/completesite_map.md`
/// documents how.
///
/// A component URL passes if some [DocPage] claims it in `upstream:` — either
/// as its own page, or folded in as a section of its parent's. A doc topic or
/// a template passes if some page names it in `upstreamPath`.
library;

import 'dart:io';

import 'package:example/docs/pages.dart';
import 'package:flutter_test/flutter_test.dart';

/// Upstream sections this port deliberately does not mirror.
///
/// The blog is Meta's, about the React library. The playground needs a live
/// Dart compiler. `llms.txt` is a build artefact, not a page.
bool _outOfScope(String path) =>
    path.startsWith('/blog') || path == '/playground' || path == '/llms.txt';

/// Upstream's section landing pages.
///
/// This site has no equivalent: the sidebar *is* the index, so there is nothing
/// for a page to claim. `/` is the exception — the `introduction` page claims
/// it, because the site does open on something.
const Set<String> _sectionIndexes = <String>{
  '/docs',
  '/components',
  '/templates',
};

void main() {
  final file = File('test/upstream_pages.txt');

  test('the upstream page list is present', () {
    expect(
      file.existsSync(),
      isTrue,
      reason:
          'No ${file.path}. It is the captured upstream sitemap, and the '
          'test is meaningless without it.',
    );
  });

  final upstreamPaths = file
      .readAsLinesSync()
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !_outOfScope(line))
      .toList();

  /// Every upstream component slug some page claims, from `upstream:`.
  final claimedComponents = <String>{
    for (final page in docPages)
      if (page.upstream != null)
        ...page.upstream!.split('/').map((name) => name.trim()),
  };

  /// Every upstream path some page names directly.
  final claimedPaths = <String>{
    for (final page in docPages)
      if (page.upstreamPath != null) page.upstreamPath!,
  };

  test('every upstream component is claimed by a page', () {
    final missing = <String>[
      for (final path in upstreamPaths)
        if (path.startsWith('/components/') &&
            !claimedComponents.contains(path.split('/').last))
          path,
    ];

    expect(
      missing,
      isEmpty,
      reason:
          'Upstream ships these and no page claims them. Either give one its '
          'own page, or add it to the `upstream:` of the page it belongs to:\n'
          '${missing.join('\n')}',
    );
  });

  test('every upstream doc topic and template is claimed by a page', () {
    final missing = <String>[
      for (final path in upstreamPaths)
        if ((path.startsWith('/docs') || path.startsWith('/templates')) &&
            !_sectionIndexes.contains(path) &&
            !claimedPaths.contains(path))
          path,
    ];

    expect(
      missing,
      isEmpty,
      reason: 'No page names these in `upstreamPath`:\n${missing.join('\n')}',
    );
  });

  test('no page claims an upstream path that does not exist', () {
    // Catches a typo in an `upstreamPath`, which would otherwise satisfy the
    // checks above by accident and send a reader to a 404.
    final all = file
        .readAsLinesSync()
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toSet();

    final unknown = claimedPaths.where((path) => !all.contains(path)).toList()
      ..sort();

    expect(
      unknown,
      isEmpty,
      reason: 'These are not in the captured sitemap:\n${unknown.join('\n')}',
    );
  });

  test(
    'a placeholder carries no examples, and a written page carries some',
    () {
      final wrong = <String>[];
      for (final page in docPages) {
        final examples = page.blocks.whereType<DocExample>().length;
        if (page.isWritten &&
            examples == 0 &&
            page.group != 'Getting started') {
          wrong.add('${page.id}: written but shows nothing');
        }
        if (!page.isWritten && examples > 0) {
          wrong.add('${page.id}: a placeholder with $examples examples');
        }
      }

      expect(wrong, isEmpty, reason: wrong.join('\n'));
    },
  );

  test('every page has a description worth searching', () {
    // The sidebar filter matches title and description only, so a page with a
    // thin description cannot be found by anyone who does not already know
    // what it is called.
    final thin = <String>[
      for (final page in docPages)
        if (page.description.trim().length < 25)
          '${page.id}: '
              '"${page.description}"',
    ];

    expect(thin, isEmpty, reason: thin.join('\n'));
  });
}
