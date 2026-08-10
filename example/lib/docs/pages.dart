/// The page registry.
///
/// **Pure Dart** — see the note on `model.dart`. `tool/gen_docs_md.dart` reads
/// this same list to emit `docs/components/*.md`, so the site and the markdown
/// cannot describe different APIs.
library;

import 'package:example/docs/model.dart';
import 'package:example/docs/pages/actions.dart';
import 'package:example/docs/pages/data.dart';
import 'package:example/docs/pages/feedback.dart';
import 'package:example/docs/pages/forms.dart';
import 'package:example/docs/pages/guides.dart';
import 'package:example/docs/pages/layout.dart';
import 'package:example/docs/pages/overlays.dart';
import 'package:example/docs/pages/surfaces.dart';

export 'package:example/docs/model.dart';

/// Every page, in navigation order.
final List<DocPage> docPages = <DocPage>[
  ...guidePages,
  ...layoutPages,
  ...actionPages,
  ...formPages,
  ...feedbackPages,
  ...overlayPages,
  ...surfacePages,
  ...dataPages,
];

/// [docPages] bucketed by group, preserving registry order.
Map<String, List<DocPage>> get docPagesByGroup {
  final grouped = <String, List<DocPage>>{};
  for (final page in docPages) {
    grouped.putIfAbsent(page.group, () => <DocPage>[]).add(page);
  }
  return grouped;
}

/// The page with [id], or null if there is none.
DocPage? docPageOrNull(String id) {
  for (final page in docPages) {
    if (page.id == id) return page;
  }
  return null;
}

/// A page together with its neighbours, for the previous/next footer.
class DocPageRef {
  const DocPageRef({required this.page, this.previous, this.next});

  final DocPage page;
  final DocPage? previous;
  final DocPage? next;
}

/// Resolves [id] to a page and its neighbours.
///
/// Falls back to the first page, so a stale id cannot leave the site blank.
DocPageRef docPageRef(String id) {
  var index = docPages.indexWhere((page) => page.id == id);
  if (index < 0) index = 0;

  return DocPageRef(
    page: docPages[index],
    previous: index > 0 ? docPages[index - 1] : null,
    next: index < docPages.length - 1 ? docPages[index + 1] : null,
  );
}
