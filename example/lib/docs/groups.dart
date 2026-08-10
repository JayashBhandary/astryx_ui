/// The navigation groups, and where each one is published.
///
/// One place, because three things need to agree about them: the sidebar, the
/// markdown in `doc/`, and the agent skill in `.claude/skills/`. Before this
/// file, `tool/gen_skill.dart` carried its own private group→file map, and a
/// group added to a page file but forgotten there made the generator exit 1.
/// Now a new group is a single entry in [docGroupFiles], and the analyzer sees
/// the name rather than a string literal in eight places.
///
/// **Pure Dart** — see the note on `model.dart`.
library;

/// The group names, as they appear as sidebar headings.
abstract final class DocGroup {
  /// Documentation about the package rather than about a widget.
  static const String gettingStarted = 'Getting started';

  /// Boxes, stacks, grids, text.
  static const String layout = 'Layout & typography';

  /// Buttons and the groups that join them.
  static const String actions = 'Actions';

  /// Inputs, and the field that labels one.
  static const String forms = 'Forms';

  /// Progress, and the badges and banners that report it.
  static const String status = 'Status';

  /// Anything that draws above the page.
  static const String overlays = 'Overlays';

  /// The containers.
  static const String surfaces = 'Surfaces';

  /// Tables, lists, code, metadata.
  static const String dataDisplay = 'Data display';

  /// Getting around: nav bars, tabs, breadcrumbs, pagination.
  static const String navigation = 'Navigation';

  /// The frame an application sits in.
  static const String appShell = 'App shell';

  /// Conversation surfaces, and the pieces streamed into them.
  static const String chat = 'Chat & AI';

  /// Command palettes and typeaheads.
  static const String commandSearch = 'Command & search';

  /// Calendars, date and time inputs, timestamps.
  static const String dateTime = 'Date & time';

  /// Avatars, thumbnails, carousels, lightboxes.
  static const String media = 'Media';

  /// The inherited widgets an application installs once, near the root.
  static const String providers = 'Providers';

  /// Controllers and mixins — where upstream ships a React hook.
  static const String hooks = 'Hooks & controllers';

  /// Whole screens, assembled from the components.
  static const String templates = 'Templates';
}

/// The reference file each group is published to, under `references/`.
///
/// A group missing from this map is a build failure in `tool/gen_skill.dart`,
/// which is the point: the skill must not quietly omit a group of components.
const Map<String, String> docGroupFiles = <String, String>{
  DocGroup.gettingStarted: 'guides.md',
  DocGroup.layout: 'layout.md',
  DocGroup.actions: 'actions.md',
  DocGroup.forms: 'forms.md',
  DocGroup.status: 'status.md',
  DocGroup.overlays: 'overlays.md',
  DocGroup.surfaces: 'surfaces.md',
  DocGroup.dataDisplay: 'data.md',
  DocGroup.navigation: 'navigation.md',
  DocGroup.appShell: 'app_shell.md',
  DocGroup.chat: 'chat.md',
  DocGroup.commandSearch: 'command_search.md',
  DocGroup.dateTime: 'date_time.md',
  DocGroup.media: 'media.md',
  DocGroup.providers: 'providers.md',
  DocGroup.hooks: 'hooks.md',
  DocGroup.templates: 'templates.md',
};
