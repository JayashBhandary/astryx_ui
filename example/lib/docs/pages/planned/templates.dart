/// Whole screens, assembled from the components.
///
/// A template is not a widget the package exports — it is a composition worth
/// copying. Ids carry no `Astryx` prefix and, where a template shares a name
/// with a component, take a suffix: `table_template`, not `table`.
///
/// **Pure Dart** — see the note on `model.dart`. Generated from
/// `scrape/completesite_map.md`, then maintained by hand: a page
/// graduates out of here when someone writes it.
///
/// The nineteen written ones are in `pages/templates.dart`. What is left is
/// here because nobody has written it yet, or because it is still *blocked* on
/// something the package does not have:
///
/// - **Written** — `shell_nav`, `documentation`, `ai_chat`, `table_page` and
///   `classic_gallery` graduated once the shell, chat, pagination and media
///   components landed. Their neighbours below are now unblocked too: they need
///   writing, not waiting.
/// - **Grouped table rows** — `table_grouped`. `AstryxTable` has no row
///   grouping, and faking it with a header row that is not a header row is
///   worse than a placeholder.
/// - **Drag and drop** — `kanban_board`. Nothing in this package moves under a
///   pointer, and a board whose cards can only be moved by a menu is a
///   different screen.
/// - **A charting widget**, which the package does not intend to ship —
///   `dashboard_portfolio`, `table_page_chart`, `table_page_heatmap_status`,
///   `table_page_shoe_store_heatmap`.
///
/// Writing one of these before its components land would mean either faking
/// the missing widget or documenting a screen nobody can build, and a template
/// that does not compile from the exported API is worse than a placeholder.
library;

import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/pages/_stub.dart';

/// Every page template, alphabetical by upstream slug.
final List<DocPage> plannedTemplatePages = <DocPage>[
  stubPage(
    id: 'ai_chat_landing',
    title: 'AI chat landing',
    group: DocGroup.templates,
    description:
        'The pre-conversation screen: prompt suggestions and a '
        'centred composer.',
    upstreamPath: '/templates/ai-chat-landing',
  ),
  stubPage(
    id: 'dashboard_portfolio',
    title: 'Portfolio dashboard',
    group: DocGroup.templates,
    description: 'A dashboard built around a chart and a holdings table.',
    upstreamPath: '/templates/dashboard-portfolio',
  ),
  stubPage(
    id: 'documentation_design',
    title: 'Design documentation',
    group: DocGroup.templates,
    description: 'A docs page for a design topic, heavy on specimens.',
    upstreamPath: '/templates/documentation-design',
  ),
  stubPage(
    id: 'documentation_technical',
    title: 'Technical documentation',
    group: DocGroup.templates,
    description: 'A docs page for an API, heavy on code and property tables.',
    upstreamPath: '/templates/documentation-technical',
  ),
  stubPage(
    id: 'editor',
    title: 'Editor',
    group: DocGroup.templates,
    description:
        'A document editor: toolbar, canvas, and an inspector '
        'panel.',
    upstreamPath: '/templates/editor',
  ),
  stubPage(
    id: 'file_explorer',
    title: 'File explorer',
    group: DocGroup.templates,
    description: 'A tree of folders beside a list of files.',
    upstreamPath: '/templates/file-explorer',
  ),
  stubPage(
    id: 'gallery_hero',
    title: 'Gallery hero',
    group: DocGroup.templates,
    description: 'A hero whose supporting content is a media grid.',
    upstreamPath: '/templates/gallery-hero',
  ),
  stubPage(
    id: 'ide',
    title: 'IDE',
    group: DocGroup.templates,
    description: 'A code workspace: file tree, tabbed editors, and a panel.',
    upstreamPath: '/templates/ide',
  ),
  stubPage(
    id: 'incident_console',
    title: 'Incident console',
    group: DocGroup.templates,
    description:
        'A live operations view: severity, timeline, and the '
        'current on-call.',
    upstreamPath: '/templates/incident-console',
  ),
  stubPage(
    id: 'kanban_board',
    title: 'Kanban board',
    group: DocGroup.templates,
    description: 'Columns of draggable cards.',
    upstreamPath: '/templates/kanban-board',
  ),
  stubPage(
    id: 'library',
    title: 'Library',
    group: DocGroup.templates,
    description: 'A browsable collection with filters beside the results.',
    upstreamPath: '/templates/library',
  ),
  stubPage(
    id: 'messaging_shell',
    title: 'Messaging shell',
    group: DocGroup.templates,
    description: 'A conversation list beside the open conversation.',
    upstreamPath: '/templates/messaging-shell',
  ),
  stubPage(
    id: 'mixed_gallery',
    title: 'Mixed gallery',
    group: DocGroup.templates,
    description: 'A gallery of items at mixed sizes.',
    upstreamPath: '/templates/mixed-gallery',
  ),
  stubPage(
    id: 'product_detail',
    title: 'Product detail',
    group: DocGroup.templates,
    description: 'Gallery, price, options, and the add-to-cart action.',
    upstreamPath: '/templates/product-detail',
  ),
  stubPage(
    id: 'product_gallery',
    title: 'Product gallery',
    group: DocGroup.templates,
    description: 'A filterable grid of products.',
    upstreamPath: '/templates/product-gallery',
  ),
  stubPage(
    id: 'settings_sidebar',
    title: 'Settings with sidebar',
    group: DocGroup.templates,
    description: 'Settings sections reached from a sidebar.',
    upstreamPath: '/templates/settings-sidebar',
  ),
  stubPage(
    id: 'shell_side_nav',
    title: 'Shell with side nav',
    group: DocGroup.templates,
    description: 'The shell with a vertical rail only.',
    upstreamPath: '/templates/shell-side-nav',
  ),
  stubPage(
    id: 'shell_top_nav',
    title: 'Shell with top nav',
    group: DocGroup.templates,
    description: 'The shell with a horizontal bar only.',
    upstreamPath: '/templates/shell-top-nav',
  ),
  stubPage(
    id: 'side_gallery',
    title: 'Side gallery',
    group: DocGroup.templates,
    description: 'A gallery with the selected item beside the strip.',
    upstreamPath: '/templates/side-gallery',
  ),
  stubPage(
    id: 'table_grouped',
    title: 'Grouped table',
    group: DocGroup.templates,
    description: 'A table whose rows are grouped under collapsible headers.',
    upstreamPath: '/templates/table-grouped',
  ),
  stubPage(
    id: 'table_page_chart',
    title: 'Table page with chart',
    group: DocGroup.templates,
    description: 'A table screen with a summary chart above it.',
    upstreamPath: '/templates/table-page-chart',
  ),
  stubPage(
    id: 'table_page_heatmap_status',
    title: 'Table page with heatmap',
    group: DocGroup.templates,
    description:
        'A table screen whose cells carry heatmap and status '
        'colouring.',
    upstreamPath: '/templates/table-page-heatmap-status',
  ),
  stubPage(
    id: 'table_page_shoe_store_heatmap',
    title: 'Retail heatmap table',
    group: DocGroup.templates,
    description: 'The heatmap table screen with a retail data set.',
    upstreamPath: '/templates/table-page-shoe-store-heatmap',
  ),
];
