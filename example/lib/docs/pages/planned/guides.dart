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
    id: 'principles',
    title: 'Principles',
    group: DocGroup.gettingStarted,
    description:
        'What the design system optimises for, and the decisions '
        'that follow from it.',
    upstreamPath: '/docs/principles',
  ),
  stubPage(
    id: 'color',
    title: 'Colour',
    group: DocGroup.gettingStarted,
    description:
        'The colour system: the families, the semantic roles, and '
        'which one to reach for.',
    upstreamPath: '/docs/color',
  ),
  stubPage(
    id: 'typography',
    title: 'Typography',
    group: DocGroup.gettingStarted,
    description:
        'The type scale, the roles, and how a heading level maps '
        'onto them.',
    upstreamPath: '/docs/typography',
  ),
  stubPage(
    id: 'spacing',
    title: 'Spacing',
    group: DocGroup.gettingStarted,
    description:
        'The spacing scale, and the rule that gaps come from tokens '
        'rather than magic numbers.',
    upstreamPath: '/docs/spacing',
  ),
  stubPage(
    id: 'shape',
    title: 'Shape',
    group: DocGroup.gettingStarted,
    description: 'Corner radii and how they compose when surfaces nest.',
    upstreamPath: '/docs/shape',
  ),
  stubPage(
    id: 'elevation',
    title: 'Elevation',
    group: DocGroup.gettingStarted,
    description:
        'The elevation levels, what each is for, and how they read '
        'in dark mode.',
    upstreamPath: '/docs/elevation',
  ),
  stubPage(
    id: 'motion',
    title: 'Motion',
    group: DocGroup.gettingStarted,
    description:
        'Durations, easings, and what must not move when motion is '
        'reduced.',
    upstreamPath: '/docs/motion',
  ),
  stubPage(
    id: 'layout_guide',
    title: 'Layout',
    group: DocGroup.gettingStarted,
    description:
        'Page structure: the shell, the content column, and the '
        'breakpoints between them.',
    upstreamPath: '/docs/layout',
  ),
  stubPage(
    id: 'icons',
    title: 'Icons',
    group: DocGroup.gettingStarted,
    description:
        'The icon registry, the Lucide mapping, and how to supply '
        'your own set.',
    upstreamPath: '/docs/icons',
  ),
  stubPage(
    id: 'illustrations',
    title: 'Illustrations',
    group: DocGroup.gettingStarted,
    description:
        'The upstream illustration set, and what a Flutter port '
        'would need to carry it.',
    upstreamPath: '/docs/illustrations',
  ),
  stubPage(
    id: 'styling',
    title: 'Styling',
    group: DocGroup.gettingStarted,
    description:
        "Extending a component's appearance without leaving the "
        'token system.',
    upstreamPath: '/docs/styling',
  ),
  stubPage(
    id: 'core',
    title: 'The token engine',
    group: DocGroup.gettingStarted,
    description:
        'How a theme definition becomes resolved tokens, and where '
        'the resolution happens.',
    upstreamPath: '/docs/core',
  ),
  stubPage(
    id: 'platform_support',
    title: 'Platform support',
    group: DocGroup.gettingStarted,
    description:
        'Which Flutter platforms are exercised, and where behaviour '
        "differs. The Flutter counterpart of upstream's "
        'browser-support page.',
    upstreamPath: '/docs/browser-support',
  ),
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
