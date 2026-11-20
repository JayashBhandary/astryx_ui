import 'dart:async';

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/playground/playground_theme.dart';
import 'package:example/examples/theming_examples.dart' show acmeTheme;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The themes the docs site can be viewed in: the seven Astryx ships,
/// `transit` — hand-authored in this repository and solved for contrast — and
/// one defined in `lib/examples/theming_examples.dart` to prove the engine
/// works.
enum DocsTheme {
  neutral('Neutral'),
  matcha('Matcha'),
  stone('Stone'),
  gothic('Gothic'),
  chocolate('Chocolate'),
  y2k('Y2K'),
  butter('Butter'),
  transit('Transit'),
  acme('Acme (custom)');

  const DocsTheme(this.label);

  final String label;

  /// The resolved theme. A getter, because each one runs the engine at
  /// initialisation and so cannot be a constant.
  AstryxDefinedTheme get theme => switch (this) {
    DocsTheme.neutral => neutralTheme,
    DocsTheme.matcha => matchaTheme,
    DocsTheme.stone => stoneTheme,
    DocsTheme.gothic => gothicTheme,
    DocsTheme.chocolate => chocolateTheme,
    DocsTheme.y2k => y2kTheme,
    DocsTheme.butter => butterTheme,
    DocsTheme.transit => transitTheme,
    DocsTheme.acme => acmeTheme,
  };
}

/// The width an example is previewed at.
///
/// Not an emulator: it constrains the width and nothing else. That is enough
/// for what it demonstrates, because every responsive decision in this package
/// comes from a `LayoutBuilder` reading its constraints. Touch density is a
/// separate axis with its own picker.
enum DocsPreviewWidth {
  /// However wide the page is. The default.
  desktop('Desktop', LucideIcons.monitor, null),

  /// Pinned to a phone: 390 logical pixels, with the frame's edge drawn.
  mobile('Mobile', LucideIcons.smartphone, 390);

  const DocsPreviewWidth(this.label, this.icon, this.width);

  /// The accessible name, and the tooltip. Not drawn — a monitor and a phone
  /// carry two choices without words.
  final String label;

  /// The glyph. Lucide, which is what the icon registry resolves to as well:
  /// `AstryxIconName` names neither of these, being a transcription of
  /// upstream's `IconName` union rather than a catalogue.
  final IconData icon;

  /// The width to pin to, or null to take the page's own.
  final double? width;
}

/// The example the playground opens on.
const String playgroundDefaultExample = 'template_theme_showcase';

/// The top-level sections of the site, as the top bar names them.
enum DocsSection {
  /// The guides: installation, theming, tokens and the rest.
  docs('Docs'),

  /// Every component, the overview first.
  components('Components'),

  /// Whole screens built from the components.
  templates('Templates');

  const DocsSection(this.label);

  /// The top-bar label.
  final String label;
}

/// The section [page] belongs to.
DocsSection docsSectionOf(DocPage page) => switch (page.group) {
  DocGroup.gettingStarted => DocsSection.docs,
  DocGroup.templates => DocsSection.templates,
  _ => DocsSection.components,
};

/// Everything the docs chrome can change about how the pages render, plus which
/// page is showing.
///
/// It feeds `AstryxThemeProvider` directly, so the docs exercise the same path
/// an application takes rather than a parallel one.
class DocsController extends ChangeNotifier {
  /// Creates the controller.
  ///
  /// Every sidebar group starts collapsed, including the one holding whichever
  /// page the URL asked for. Opening a group is the reader's to do.
  DocsController();

  /// Whether the landing page is showing rather than a documentation page.
  ///
  /// True when the URL named no page — `/`, or anything that is not a page id.
  /// Somebody arriving from a search result or a package listing has one
  /// question first, and the sidebar is not an answer to it.
  bool get onLanding => _onLanding;
  bool _onLanding =
      _pageIdFromUrl() == null &&
      !_overviewInUrl() &&
      !_segmentInUrl('playground');

  /// Whether the `/components` overview is showing: every component as a
  /// tile, by category.
  bool get onComponentsOverview => _onOverview;
  bool _onOverview = _pageIdFromUrl() == null && _overviewInUrl();

  /// Whether the playground is showing.
  bool get onPlayground => _onPlayground;
  bool _onPlayground = _pageIdFromUrl() == null && _segmentInUrl('playground');

  /// The theme the playground is editing. Seeded from the share link.
  PlaygroundTheme get playgroundTheme => _playgroundTheme;
  PlaygroundTheme _playgroundTheme =
      PlaygroundTheme.decode(Uri.base.queryParameters['t']) ??
      const PlaygroundTheme();
  set playgroundTheme(PlaygroundTheme value) => _set(() {
    _playgroundTheme = value;
    _syncPlaygroundUrl();
  }, false);

  /// The example the playground previews: a region id from `lib/examples/`.
  String get playgroundExample => _playgroundExample;
  String _playgroundExample =
      Uri.base.queryParameters['ex'] ?? playgroundDefaultExample;
  set playgroundExample(String value) => _set(() {
    _playgroundExample = value;
    _syncPlaygroundUrl();
  }, _playgroundExample == value);

  /// The playground's own preview mode. Null follows the site.
  AstryxColorMode? get playgroundMode => _playgroundMode;
  AstryxColorMode? _playgroundMode;
  set playgroundMode(AstryxColorMode? value) =>
      _set(() => _playgroundMode = value, _playgroundMode == value);

  /// The link that reproduces the playground as it is now.
  Uri get playgroundUri => Uri(
    path: '/playground',
    queryParameters: <String, String>{
      'ex': _playgroundExample,
      if (_playgroundTheme.isEdited ||
          _playgroundTheme.base != DocsTheme.neutral)
        't': _playgroundTheme.encode(),
    },
  );

  void _syncPlaygroundUrl() {
    if (!_onPlayground) return;
    unawaited(
      SystemNavigator.routeInformationUpdated(
        uri: playgroundUri,
        replace: true,
      ),
    );
  }

  /// Opens the playground.
  void goPlayground() => _set(() {
    _onLanding = false;
    _onOverview = false;
    _onPlayground = true;
    _syncPlaygroundUrl();
  }, _onPlayground && !_onLanding);

  /// Goes back to the landing page.
  void goHome() => _set(() {
    _onLanding = true;
    _onOverview = false;
    _onPlayground = false;
    _query = '';
    unawaited(
      SystemNavigator.routeInformationUpdated(
        uri: Uri(path: '/'),
        replace: true,
      ),
    );
  }, _onLanding);

  /// Opens the components overview.
  void goComponents() => _set(() {
    _onLanding = false;
    _onOverview = true;
    _onPlayground = false;
    unawaited(
      SystemNavigator.routeInformationUpdated(
        uri: Uri(path: '/components'),
        replace: true,
      ),
    );
  }, _onOverview && !_onLanding);

  /// The top-level section the reader is in — what the top bar highlights and
  /// what the sidebar lists.
  DocsSection get section {
    if (_onOverview) return DocsSection.components;
    return docsSectionOf(page.page);
  }

  /// Opens [section]: the overview for components, the first page otherwise.
  void goSection(DocsSection section) {
    // A filter typed for one section means nothing in another.
    _query = '';
    switch (section) {
      case DocsSection.components:
        goComponents();
      case DocsSection.docs:
      case DocsSection.templates:
        final first = docPages.firstWhere(
          (page) => docsSectionOf(page) == section,
        );
        pageId = first.id;
    }
  }

  DocsTheme get theme => _theme;
  DocsTheme _theme = DocsTheme.neutral;
  set theme(DocsTheme value) => _set(() => _theme = value, _theme == value);

  AstryxColorMode get mode => _mode;
  AstryxColorMode _mode = AstryxColorMode.system;
  set mode(AstryxColorMode value) => _set(() => _mode = value, _mode == value);

  /// Null follows the platform, which is what an application should normally
  /// do.
  AstryxDensity? get density => _density;
  AstryxDensity? _density;
  set density(AstryxDensity? value) =>
      _set(() => _density = value, _density == value);

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection = TextDirection.ltr;
  set textDirection(TextDirection value) =>
      _set(() => _textDirection = value, _textDirection == value);

  /// The theme the Themes page previews.
  ///
  /// Separate from [theme]: picking a card on that page restyles the preview,
  /// not the site around it.
  DocsTheme get previewTheme => _previewTheme;
  DocsTheme _previewTheme = DocsTheme.neutral;
  set previewTheme(DocsTheme value) =>
      _set(() => _previewTheme = value, _previewTheme == value);

  /// The colour mode of the Themes page preview. Null follows the site.
  AstryxColorMode? get previewMode => _previewMode;
  AstryxColorMode? _previewMode;
  set previewMode(AstryxColorMode? value) =>
      _set(() => _previewMode = value, _previewMode == value);

  /// The width every example previews at.
  ///
  /// On the controller rather than on each example block, so the choice is made
  /// once: every preview on the page follows it, and it survives navigating to
  /// another page. A reader comparing how two components behave on a phone
  /// should not have to ask twice.
  DocsPreviewWidth get previewWidth => _previewWidth;
  DocsPreviewWidth _previewWidth = DocsPreviewWidth.desktop;
  set previewWidth(DocsPreviewWidth value) =>
      _set(() => _previewWidth = value, _previewWidth == value);

  /// Which page is showing.
  ///
  /// Seeded from the URL, so `/card` opens the card page and any page can be
  /// linked to.
  String get pageId => _pageId;
  String _pageId = _pageFromUrl();
  set pageId(String value) => _set(() {
    _pageId = value;
    // Choosing a page leaves the front door, wherever the choice came from.
    _onLanding = false;
    _onOverview = false;
    _onPlayground = false;
    // Navigating does not open anything. A group the reader closed stays
    // closed, whether they arrived by pressing an item, by the previous/next
    // footer, or by a link inside the prose — a sidebar that reopens a group
    // behind you is a sidebar you cannot keep tidy.
    // Keeps the address bar in step on the web — `/card`, because the app
    // installs the path URL strategy. A no-op elsewhere, and nothing depends on
    // the platform having answered.
    //
    // `replace: true` deliberately: nothing here listens for the platform
    // pushing a route back, so pushing history entries would give a Back button
    // that changes the URL and leaves the page where it was. Replacing keeps
    // the address bar and the content in agreement, at the cost of in-site
    // Back.
    unawaited(
      SystemNavigator.routeInformationUpdated(
        uri: Uri(path: '/$value'),
        replace: true,
      ),
    );
  }, _pageId == value && !_onLanding && !_onOverview && !_onPlayground);

  /// The page the current URL asks for, or the first page.
  ///
  /// Reads the path first and the fragment second: `/#card` links were shared
  /// before the switch to path URLs, and breaking them would be rude.
  static String _pageFromUrl() => _pageIdFromUrl() ?? docPages.first.id;

  /// The page the current URL asks for, or null when it names none.
  ///
  /// Null is the whole point: it is what tells the landing page from a page
  /// that happens to be first in the registry.
  static String? _pageIdFromUrl() {
    final segments = Uri.base.pathSegments.where((s) => s.isNotEmpty).toList();
    final path = segments.isEmpty ? '' : segments.last;
    if (docPageOrNull(path) != null) return path;

    final fragment = Uri.base.fragment.replaceAll('/', '');
    if (docPageOrNull(fragment) != null) return fragment;

    return null;
  }

  /// Whether the URL's last path segment, or its fragment, is [segment].
  static bool _segmentInUrl(String segment) {
    final segments = Uri.base.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isNotEmpty && segments.last == segment) return true;
    return Uri.base.fragment.replaceAll('/', '') == segment;
  }

  /// Whether the URL asks for the components overview: `/components`.
  static bool _overviewInUrl() {
    final segments = Uri.base.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isNotEmpty && segments.last == 'components') return true;
    return Uri.base.fragment.replaceAll('/', '') == 'components';
  }

  /// The sidebar filter.
  String get query => _query;
  String _query = '';
  set query(String value) => _set(() => _query = value, _query == value);

  /// The sidebar entries that are expanded — a component family such as
  /// `Button`, or a section such as `Hooks & controllers`.
  ///
  /// Empty until somebody presses a chevron. Navigating never adds to it: the
  /// family holding the current page is drawn open by the sidebar itself, so
  /// the reader can see where they are without the sidebar rewriting what they
  /// chose to keep open.
  final Set<String> _openGroups = <String>{};

  /// Whether [group] has been expanded by the reader.
  bool isGroupOpen(String group) => _openGroups.contains(group);

  /// Expands [group] if it is collapsed, and the reverse.
  void toggleGroup(String group) => _set(() {
    if (!_openGroups.remove(group)) _openGroups.add(group);
  }, false);

  /// The page currently showing.
  DocPageRef get page => docPageRef(_pageId);

  void _set(void Function() change, bool unchanged) {
    if (unchanged) return;
    change();
    notifyListeners();
  }
}

/// Exposes a [DocsController] to the tree.
class DocsScope extends InheritedNotifier<DocsController> {
  const DocsScope({
    required DocsController super.notifier,
    required super.child,
    super.key,
  });

  static DocsController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null, 'No DocsScope above this context.');
    return controller!;
  }

  /// The controller in scope, or null when there is none.
  ///
  /// An example lifted out of the site — into `DocsPreviewHarness`, or into a
  /// scratch app — has no chrome above it. That is not an error; it just means
  /// there is nothing site-wide to read a preference from.
  static DocsController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DocsScope>()?.notifier;
}

/// Follows a link [target] from documentation content.
///
/// The same string can be either of two things, and only the registry knows
/// which: a page id — `card`, `theming` — navigates within the site, and
/// anything carrying a scheme goes to the `AstryxLinkDelegate` the app
/// installed, which is the seam the package's own `href:` parameters use.
///
/// One function rather than one per surface: the shell, the landing page and
/// the page view all render the same prose, and a link that worked on one page
/// and did nothing on another would be a real bug hiding behind three copies.
void docsFollow(BuildContext context, String target) {
  if (docPageOrNull(target) != null) {
    DocsScope.of(context).pageId = target;
    return;
  }

  final uri = Uri.tryParse(target);
  if (uri != null && uri.hasScheme) {
    AstryxLinkDelegate.of(context).followLink(uri);
  }
}
