/// The guide topics upstream has that this port does not.
///
/// All three that remain are `notPlanned`: they document StyleX and the Node
/// CLI, neither of which has a Flutter counterpart. They are pages rather than
/// omissions so the parity check against `scrape/upstream_pages.txt` stays
/// honest — a deliberate decision and an oversight look identical from the
/// outside otherwise.
///
/// **Pure Dart** — see the note on `model.dart`. Generated from
/// `scrape/completesite_map.md`, then maintained by hand: a page graduates out
/// of here when someone writes it, which is how `migration`,
/// `working_with_ai`, `themes`, `changelog` and `community` left.
library;

import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/pages/_stub.dart';

/// The missing documentation topics, plus the deliberate omissions.
final List<DocPage> plannedGuidePages = <DocPage>[
  stubPage(
    id: 'styling_libraries',
    title: 'Styling libraries',
    group: DocGroup.gettingStarted,
    description:
        'Upstream covers integrating StyleX with other CSS-in-JS '
        'libraries. There is no Flutter counterpart.',
    status: DocStatus.notPlanned,
    upstreamPath: '/docs/styling-libraries',
  ),
  stubPage(
    id: 'astryx_cli',
    title: 'The Astryx CLI',
    group: DocGroup.gettingStarted,
    description:
        'Upstream ships a Node CLI for agents and scaffolding. This '
        'port has no Dart equivalent; the agent skill covers the '
        'same ground.',
    status: DocStatus.notPlanned,
    upstreamPath: '/docs/cli',
  ),
  stubPage(
    id: 'cli_integrations',
    title: 'CLI integrations',
    group: DocGroup.gettingStarted,
    description:
        'Editor and agent integrations for the upstream Node CLI. '
        'Not applicable.',
    status: DocStatus.notPlanned,
    upstreamPath: '/docs/cli-integrations',
  ),
];
