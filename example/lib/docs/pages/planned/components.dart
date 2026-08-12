/// Components upstream ships that this port has not written up yet.
///
/// One page per widget, not per upstream URL: a sub-component that is not a
/// public Dart type in its own right is a section on its parent's page, and is
/// listed in that page's `upstream:` so the parity check can see it.
///
/// **Pure Dart** — see the note on `model.dart`. Generated from
/// `scrape/completesite_map.md`, then maintained by hand: a page
/// graduates out of here when someone writes it.
library;

import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/pages/_stub.dart';

/// Every component page that is a placeholder, in upstream nav order.
final List<DocPage> plannedComponentPages = <DocPage>[
  stubPage(
    id: 'stack_item',
    title: 'StackItem',
    group: DocGroup.layout,
    description: 'A stack child with its own flex, alignment and order.',
    upstream: 'StackItem',
    upstreamPath: '/components/StackItem',
  ),
];
