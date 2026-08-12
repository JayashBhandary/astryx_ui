/// The page registry.
///
/// **Pure Dart** — see the note on `model.dart`. `tool/gen_docs_md.dart` reads
/// this same list to emit `docs/components/*.md`, so the site and the markdown
/// cannot describe different APIs.
library;

import 'package:example/docs/model.dart';
import 'package:example/docs/pages/actions.dart';
import 'package:example/docs/pages/app_shell.dart';
import 'package:example/docs/pages/chat.dart';
import 'package:example/docs/pages/data.dart';
import 'package:example/docs/pages/data_lists.dart';
import 'package:example/docs/pages/date_time.dart';
import 'package:example/docs/pages/feedback.dart';
import 'package:example/docs/pages/forms.dart';
import 'package:example/docs/pages/guides.dart';
import 'package:example/docs/pages/hooks.dart';
import 'package:example/docs/pages/layout.dart';
import 'package:example/docs/pages/media.dart';
import 'package:example/docs/pages/navigation.dart';
import 'package:example/docs/pages/overlays.dart';
import 'package:example/docs/pages/planned/components.dart';
import 'package:example/docs/pages/planned/guides.dart';
import 'package:example/docs/pages/providers.dart';
import 'package:example/docs/pages/search.dart';
import 'package:example/docs/pages/surfaces.dart';
import 'package:example/docs/pages/templates.dart';

export 'package:example/docs/groups.dart';
export 'package:example/docs/model.dart';

/// Every page, in navigation order.
///
/// The written pages first, then the placeholders. Two planned lists are gone
/// rather than empty: every upstream hook has a written page, and so does every
/// upstream template — `planned/hooks.dart` and `planned/templates.dart` were
/// deleted when the last entry in each graduated. Order matters twice: a
/// group's position in [docPagesByGroup] is where its first page appears, and a
/// page's position within its group is its position here. Appending the planned
/// lists therefore lands each placeholder underneath the written pages of the
/// same group.
final List<DocPage> docPages = <DocPage>[
  ...guidePages,
  ...layoutPages,
  ...actionPages,
  ...formPages,
  ...dateTimePages,
  ...feedbackPages,
  ...overlayPages,
  ...surfacePages,
  ...dataPages,
  ...listPages,
  ...navigationPages,
  ...appShellPages,
  ...mediaPages,
  ...searchPages,
  ...chatPages,
  ...providerPages,
  ...hookPages,
  ...templatePages,
  ...plannedGuidePages,
  ...plannedComponentPages,
];

/// The pages with content — what `doc/` and the agent skill are built from.
Iterable<DocPage> get writtenDocPages =>
    docPages.where((page) => page.isWritten);

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
