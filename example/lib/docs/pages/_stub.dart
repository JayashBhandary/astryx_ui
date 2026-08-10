/// The scaffold for a page that exists but is not written yet.
///
/// The site mirrors `astryx.atmeta.com` (see `scrape/completesite_map.md`), and
/// a mirror with holes in it is worse than one with placeholders: a missing
/// route is indistinguishable from a widget nobody has thought about. A stub
/// says "this exists, here is the upstream page it will be written from, it is
/// not done".
///
/// **Pure Dart** — see the note on `model.dart`.
library;

import 'package:example/docs/model.dart';

/// A page with a route, a description and nothing else.
///
/// [description] is required, not optional: it is what the sidebar filter
/// searches, so a stub without one cannot be found by the person looking for
/// the widget it stands in for.
///
/// The default [status] is [DocStatus.planned] — upstream has it, this port
/// does not. Pass [DocStatus.stub] when the widget *is* ported and only the
/// prose is missing, and [DocStatus.notPlanned] for pages that exist to record
/// a deliberate omission.
DocPage stubPage({
  required String id,
  required String title,
  required String group,
  required String description,
  DocStatus status = DocStatus.planned,
  String? upstream,
  String? upstreamPath,
  String? source,
}) {
  return DocPage(
    id: id,
    title: title,
    group: group,
    description: description,
    status: status,
    upstream: upstream,
    upstreamPath: upstreamPath,
    source: source,
    blocks: <DocBlock>[_noteFor(status, upstreamPath)],
  );
}

/// The one block a stub carries: what state the page is in, and where to read.
DocBlock _noteFor(DocStatus status, String? upstreamPath) {
  final upstream = upstreamPath == null
      ? ''
      : ' Upstream: [$upstreamPath](https://astryx.atmeta.com$upstreamPath).';

  return switch (status) {
    DocStatus.ready => const DocProse('This page is written elsewhere.'),
    DocStatus.stub => DocCallout.note(
      'The widget is ported; this page is not written yet.$upstream',
    ),
    DocStatus.planned => DocCallout.note(
      'Not ported yet. This page exists so the route resolves and the widget '
      'is findable in search.$upstream',
    ),
    DocStatus.notPlanned => DocCallout.note(
      'Deliberately not ported — either React-specific, or covered by a '
      'Flutter idiom instead.$upstream',
    ),
  };
}
