/// The component categories on the `/components` overview, and which page
/// belongs to each.
///
/// The eleven categories are upstream's, in upstream's order, so the overview
/// reads like `astryx.atmeta.com/components`. They are separate from
/// [DocGroup]: the groups decide where a page is published (the markdown in
/// `doc/`, the agent skill), the categories only decide where its tile sits on
/// the overview.
///
/// **Pure Dart** — see the note on `model.dart`.
library;

import 'package:example/docs/model.dart';

/// The category names, as they appear as overview headings.
abstract final class DocCategory {
  /// Action.
  static const String action = 'Action';

  /// Chat.
  static const String chat = 'Chat';

  /// Container.
  static const String container = 'Container';

  /// Content.
  static const String content = 'Content';

  /// Feedback & Status.
  static const String feedback = 'Feedback & Status';

  /// Form Controls.
  static const String formControls = 'Form Controls';

  /// Layout.
  static const String layout = 'Layout';

  /// Navigation.
  static const String navigation = 'Navigation';

  /// Overlay.
  static const String overlay = 'Overlay';

  /// Table & List.
  static const String tableList = 'Table & List';

  /// Utility.
  static const String utility = 'Utility';

  /// Every category, in display order.
  static const List<String> all = <String>[
    action,
    chat,
    container,
    content,
    feedback,
    formControls,
    layout,
    navigation,
    overlay,
    tableList,
    utility,
  ];
}

/// The category of each component page, by page id.
///
/// A page missing from this map has no tile on the overview. That is right for
/// guides, hooks, providers and templates, and is checked for components by
/// `test/components_overview_test.dart`.
const Map<String, String> docCategoryOf = <String, String>{
  // Action
  'button': DocCategory.action,
  'button_group': DocCategory.action,
  'dropdown_menu': DocCategory.action,
  'icon_button': DocCategory.action,
  'link': DocCategory.action,
  'more_menu': DocCategory.action,
  'segmented_control': DocCategory.action,
  'toggle_button': DocCategory.action,
  'toggle_button_group': DocCategory.action,
  'toolbar': DocCategory.action,
  // Chat
  'chat_composer': DocCategory.chat,
  'chat_composer_token': DocCategory.chat,
  'chat_dictation_button': DocCategory.chat,
  'chat_layout': DocCategory.chat,
  'chat_message': DocCategory.chat,
  'chat_send_button': DocCategory.chat,
  'chat_system_message': DocCategory.chat,
  'chat_tokenized_text': DocCategory.chat,
  'chat_tool_calls': DocCategory.chat,
  // Container
  'card': DocCategory.container,
  'carousel': DocCategory.container,
  'collapsible': DocCategory.container,
  'collapsible_group': DocCategory.container,
  'selectable_card': DocCategory.container,
  // Content
  'avatar': DocCategory.content,
  'avatar_group': DocCategory.content,
  'blockquote': DocCategory.content,
  'citation': DocCategory.content,
  'code': DocCategory.content,
  'code_block': DocCategory.content,
  'empty_state': DocCategory.content,
  'heading': DocCategory.content,
  'icon': DocCategory.content,
  'kbd': DocCategory.content,
  'markdown': DocCategory.content,
  'text': DocCategory.content,
  'thumbnail': DocCategory.content,
  'timestamp': DocCategory.content,
  'token': DocCategory.content,
  // Feedback & Status
  'badge': DocCategory.feedback,
  'banner': DocCategory.feedback,
  'progress_bar': DocCategory.feedback,
  'skeleton': DocCategory.feedback,
  'spinner': DocCategory.feedback,
  'status_dot': DocCategory.feedback,
  // Form Controls
  'base_typeahead': DocCategory.formControls,
  'calendar': DocCategory.formControls,
  'checkbox': DocCategory.formControls,
  'checkbox_list': DocCategory.formControls,
  'complex_selector': DocCategory.formControls,
  'date_input': DocCategory.formControls,
  'date_range_input': DocCategory.formControls,
  'date_time_input': DocCategory.formControls,
  'field': DocCategory.formControls,
  'file_input': DocCategory.formControls,
  'indicator': DocCategory.formControls,
  'input_group': DocCategory.formControls,
  'multi_selector': DocCategory.formControls,
  'number_input': DocCategory.formControls,
  'power_search': DocCategory.formControls,
  'radio_list': DocCategory.formControls,
  'selector': DocCategory.formControls,
  'slider': DocCategory.formControls,
  'switch': DocCategory.formControls,
  'text_area': DocCategory.formControls,
  'text_input': DocCategory.formControls,
  'time_input': DocCategory.formControls,
  'tokenizer': DocCategory.formControls,
  'typeahead': DocCategory.formControls,
  // Layout
  'app_shell': DocCategory.layout,
  'aspect_ratio': DocCategory.layout,
  'center': DocCategory.layout,
  'divider': DocCategory.layout,
  'form_layout': DocCategory.layout,
  'grid': DocCategory.layout,
  'layout': DocCategory.layout,
  'resize_handle': DocCategory.layout,
  'section': DocCategory.layout,
  'stack': DocCategory.layout,
  // Navigation
  'breadcrumbs': DocCategory.navigation,
  'mobile_nav': DocCategory.navigation,
  'nav_heading_menu': DocCategory.navigation,
  'nav_icon': DocCategory.navigation,
  'outline': DocCategory.navigation,
  'pagination': DocCategory.navigation,
  'side_nav': DocCategory.navigation,
  'stepper': DocCategory.navigation,
  'tab_list': DocCategory.navigation,
  'tab_menu': DocCategory.navigation,
  'top_nav': DocCategory.navigation,
  // Overlay
  'alert_dialog': DocCategory.overlay,
  'bottom_sheet': DocCategory.overlay,
  'bottom_sheet_switcher': DocCategory.overlay,
  'command_palette': DocCategory.overlay,
  'context_menu': DocCategory.overlay,
  'dialog': DocCategory.overlay,
  'hover_card': DocCategory.overlay,
  'lightbox': DocCategory.overlay,
  'overlay': DocCategory.overlay,
  'popover': DocCategory.overlay,
  'toast': DocCategory.overlay,
  'tooltip': DocCategory.overlay,
  // Table & List
  'item': DocCategory.tableList,
  'list': DocCategory.tableList,
  'metadata_list': DocCategory.tableList,
  'overflow_list': DocCategory.tableList,
  'table': DocCategory.tableList,
  'tree_list': DocCategory.tableList,
  // Utility
  'media_theme': DocCategory.utility,
  'visually_hidden': DocCategory.utility,
};

/// The overview category of [page], or null when it has no tile.
String? docCategory(DocPage page) => docCategoryOf[page.id];

/// The name a reader looks for: `AstryxButtonGroup` → `Button Group`.
///
/// Upstream names its pages this way, and an alphabetical sidebar of
/// `Astryx…` titles would sort every entry under A. Anything that is not an
/// `Astryx` class name — `The indicators`, a guide title — is returned as is.
String docDisplayName(DocPage page) {
  final title = page.title;
  if (!title.contains('Astryx')) return title;
  return title.replaceAllMapped(
    RegExp('Astryx([A-Z][A-Za-z0-9]*)'),
    (match) => _spaceWords(match.group(1)!),
  );
}

/// `ButtonGroup` → `Button Group`, `HStack` → `H Stack`.
String _spaceWords(String name) => name.replaceAllMapped(
  RegExp('(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])'),
  (_) => ' ',
);
