/// Documentation topics upstream has and this port does not, yet.
///
/// Three are `notPlanned`: they document StyleX and the Node CLI, neither of
/// which has a Flutter counterpart. They are pages rather than omissions so the
/// parity check against `scrape/upstream_pages.txt` stays honest.
///
/// **Pure Dart** — see the note on `model.dart`. Generated from
/// `scrape/completesite_map.md`, then maintained by hand: a page
/// graduates out of here when someone writes it.
library;

import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/pages/_stub.dart';

/// The missing documentation topics, plus the deliberate omissions.
final List<DocPage> plannedGuidePages = <DocPage>[
  stubPage(
    id: 'migration',
    title: 'Migration',
    group: DocGroup.gettingStarted,
    description:
        'Coming from Material or Cupertino: what maps, what does '
        'not, and what to stop doing.',
    upstreamPath: '/docs/migration',
  ),
  stubPage(
    id: 'working_with_ai',
    title: 'Working with AI',
    group: DocGroup.gettingStarted,
    description:
        'The generated agent skill, what it contains, and how to '
        'keep it current.',
    upstreamPath: '/docs/working-with-ai',
  ),
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
  stubPage(
    id: 'themes',
    title: 'Themes',
    group: DocGroup.gettingStarted,
    description:
        'The eight themes side by side, and the same components '
        'rendered in each. The chrome already switches between '
        'them; this page is the gallery.',
    upstreamPath: '/themes',
  ),
  stubPage(
    id: 'changelog',
    title: 'Changelog',
    group: DocGroup.gettingStarted,
    description:
        'What changed in each release. Rendered from '
        '`CHANGELOG.md`.',
    upstreamPath: '/changelog',
  ),
  stubPage(
    id: 'community',
    title: 'Community',
    group: DocGroup.gettingStarted,
    description:
        'The repository, the issue tracker, and how to contribute a '
        'component.',
    upstreamPath: '/community',
  ),
];
