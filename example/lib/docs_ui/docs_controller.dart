import 'dart:async';

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/pages.dart';
import 'package:example/examples/theming_examples.dart' show acmeTheme;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

/// Everything the docs chrome can change about how the pages render, plus which
/// page is showing.
///
/// It feeds `AstryxThemeProvider` directly, so the docs exercise the same path
/// an application takes rather than a parallel one.
class DocsController extends ChangeNotifier {
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

  /// Which page is showing.
  ///
  /// Seeded from the URL, so `/card` opens the card page and any page can be
  /// linked to.
  String get pageId => _pageId;
  String _pageId = _pageFromUrl();
  set pageId(String value) => _set(() {
    _pageId = value;
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
    final controller = context
        .dependOnInheritedWidgetOfExactType<DocsScope>()
        ?.notifier;
    assert(controller != null, 'No DocsScope above this context.');
    return controller!;
  }
}
