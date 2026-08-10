import 'dart:async';

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/pages.dart';
import 'package:example/examples/theming_examples.dart' show acmeTheme;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The themes the docs site can be viewed in: the seven Astryx ships, plus one
/// defined in `lib/examples/theming_examples.dart` to prove the engine works.
enum DocsTheme {
  neutral('Neutral'),
  matcha('Matcha'),
  stone('Stone'),
  gothic('Gothic'),
  chocolate('Chocolate'),
  y2k('Y2K'),
  butter('Butter'),
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

/// Everything the docs chrome can change about how the pages render, plus which
/// page is showing.
///
/// It feeds `AstryxThemeProvider` directly, so the docs exercise the same path
/// an application takes rather than a parallel one.
class DocsController extends ChangeNotifier {
  /// Opens the group holding whichever page the URL asked for.
  DocsController() {
    final page = docPageOrNull(_pageId);
    if (page != null) _openGroups.add(page.group);
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
    // Keep the sidebar showing where you are, whether you arrived by clicking
    // the item, by the previous/next footer, or by a link inside the prose.
    final page = docPageOrNull(value);
    if (page != null) _openGroups.add(page.group);
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
  }, _pageId == value);

  /// The page the current URL asks for, or the first page.
  ///
  /// Reads the path first and the fragment second: `/#card` links were shared
  /// before the switch to path URLs, and breaking them would be rude.
  static String _pageFromUrl() {
    final segments = Uri.base.pathSegments.where((s) => s.isNotEmpty).toList();
    final path = segments.isEmpty ? '' : segments.last;
    if (docPageOrNull(path) != null) return path;

    final fragment = Uri.base.fragment.replaceAll('/', '');
    if (docPageOrNull(fragment) != null) return fragment;

    return docPages.first.id;
  }

  /// The sidebar filter.
  String get query => _query;
  String _query = '';
  set query(String value) => _set(() => _query = value, _query == value);

  /// Whether the sidebar hides the pages that are only placeholders.
  ///
  /// Most of the site is a placeholder — the registry mirrors every component
  /// upstream ships, and most are not written up. Someone looking for
  /// documentation wants this on; someone auditing the port against upstream
  /// wants it off.
  bool get writtenOnly => _writtenOnly;
  bool _writtenOnly = false;
  set writtenOnly(bool value) =>
      _set(() => _writtenOnly = value, _writtenOnly == value);

  /// The sidebar groups that are expanded.
  ///
  /// Collapsed by default, because seventeen groups of two hundred pages is not
  /// a list anyone reads. The group holding the current page starts open, and
  /// opens again whenever the page changes, so navigating never leaves the
  /// sidebar pointing at nothing.
  final Set<String> _openGroups = <String>{};

  /// Whether [group] is expanded.
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
