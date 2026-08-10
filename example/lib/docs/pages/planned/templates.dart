/// Whole screens, assembled from the components.
///
/// A template is not a widget the package exports — it is a composition worth
/// copying. Ids carry no `Astryx` prefix and, where a template shares a name
/// with a component, take a suffix: `table_template`, not `table`.
///
/// **Pure Dart** — see the note on `model.dart`. Generated from
/// `scrape/completesite_map.md`, then maintained by hand: a page
/// graduates out of here when someone writes it.
library;

import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/pages/_stub.dart';

/// Every page template, alphabetical by upstream slug.
final List<DocPage> templatePages = <DocPage>[
  stubPage(
    id: 'ai_chat',
    title: 'AI chat',
    group: DocGroup.templates,
    description:
        'A full conversation screen: transcript, composer, and the '
        'empty state before the first turn.',
    upstreamPath: '/templates/ai-chat',
  ),
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
    id: 'centered_hero',
    title: 'Centred hero',
    group: DocGroup.templates,
    description:
        'A marketing hero: headline, supporting line, and one '
        'action.',
    upstreamPath: '/templates/centered-hero',
  ),
  stubPage(
    id: 'classic_gallery',
    title: 'Classic gallery',
    group: DocGroup.templates,
    description: 'A uniform grid of media cards.',
    upstreamPath: '/templates/classic-gallery',
  ),
  stubPage(
    id: 'contact_form',
    title: 'Contact form',
    group: DocGroup.templates,
    description: 'A single-column form with validation and a success state.',
    upstreamPath: '/templates/contact-form',
  ),
  stubPage(
    id: 'dashboard',
    title: 'Dashboard',
    group: DocGroup.templates,
    description: 'Summary tiles above a table, inside the application shell.',
    upstreamPath: '/templates/dashboard',
  ),
  stubPage(
    id: 'dashboard_portfolio',
    title: 'Portfolio dashboard',
    group: DocGroup.templates,
    description: 'A dashboard built around a chart and a holdings table.',
    upstreamPath: '/templates/dashboard-portfolio',
  ),
  stubPage(
    id: 'detail_page',
    title: 'Detail page',
    group: DocGroup.templates,
    description: 'One record: header, metadata list, tabs, and actions.',
    upstreamPath: '/templates/detail-page',
  ),
  stubPage(
    id: 'documentation',
    title: 'Documentation',
    group: DocGroup.templates,
    description:
        'A docs page: side navigation, content column, and an '
        'on-this-page outline.',
    upstreamPath: '/templates/documentation',
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
    id: 'form_two_column',
    title: 'Two-column form',
    group: DocGroup.templates,
    description:
        'A long form split into labelled sections across two '
        'columns.',
    upstreamPath: '/templates/form-two-column',
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
    id: 'login',
    title: 'Login',
    group: DocGroup.templates,
    description: 'A centred sign-in form, with the error and loading states.',
    upstreamPath: '/templates/login',
  ),
  stubPage(
    id: 'login_card',
    title: 'Login card',
    group: DocGroup.templates,
    description: 'Sign-in inside a bordered card.',
    upstreamPath: '/templates/login-card',
  ),
  stubPage(
    id: 'login_split',
    title: 'Split login',
    group: DocGroup.templates,
    description: 'Sign-in beside a full-height image.',
    upstreamPath: '/templates/login-split',
  ),
  stubPage(
    id: 'login_sso',
    title: 'SSO login',
    group: DocGroup.templates,
    description:
        'Sign-in through identity providers, with an email '
        'fallback.',
    upstreamPath: '/templates/login-sso',
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
    id: 'payment_form',
    title: 'Payment form',
    group: DocGroup.templates,
    description: 'Card details, billing address, and an order summary.',
    upstreamPath: '/templates/payment-form',
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
    id: 'settings',
    title: 'Settings',
    group: DocGroup.templates,
    description: 'Grouped preference rows with inline controls.',
    upstreamPath: '/templates/settings',
  ),
  stubPage(
    id: 'settings_dialog',
    title: 'Settings dialog',
    group: DocGroup.templates,
    description: 'Settings inside a modal, with its own navigation.',
    upstreamPath: '/templates/settings-dialog',
  ),
  stubPage(
    id: 'settings_sidebar',
    title: 'Settings with sidebar',
    group: DocGroup.templates,
    description: 'Settings sections reached from a sidebar.',
    upstreamPath: '/templates/settings-sidebar',
  ),
  stubPage(
    id: 'shell_nav',
    title: 'Shell navigation',
    group: DocGroup.templates,
    description: 'The application shell with both bars in place.',
    upstreamPath: '/templates/shell-nav',
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
    id: 'table_template',
    title: 'Table',
    group: DocGroup.templates,
    description: 'A data table with selection, sorting and row actions.',
    upstreamPath: '/templates/table',
  ),
  stubPage(
    id: 'table_grouped',
    title: 'Grouped table',
    group: DocGroup.templates,
    description: 'A table whose rows are grouped under collapsible headers.',
    upstreamPath: '/templates/table-grouped',
  ),
  stubPage(
    id: 'table_page',
    title: 'Table page',
    group: DocGroup.templates,
    description: 'A table as a whole screen: filters, table, pagination.',
    upstreamPath: '/templates/table-page',
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
  stubPage(
    id: 'theme_showcase',
    title: 'Theme showcase',
    group: DocGroup.templates,
    description:
        'Every component at once, for comparing themes side by '
        'side.',
    upstreamPath: '/templates/theme-showcase',
  ),
];
