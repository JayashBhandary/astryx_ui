import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// The seven themes Astryx ships upstream.
enum GalleryTheme {
  neutral('Neutral'),
  matcha('Matcha'),
  stone('Stone'),
  gothic('Gothic'),
  chocolate('Chocolate'),
  y2k('Y2K'),
  butter('Butter');

  const GalleryTheme(this.label);

  final String label;

  /// The resolved Astryx theme this entry selects.
  ///
  /// A getter rather than a constructor field: each theme runs the engine at
  /// initialisation, so they are `final`, not `const`, and an enum value's
  /// arguments have to be constant.
  AstryxDefinedTheme get theme => switch (this) {
    GalleryTheme.neutral => neutralTheme,
    GalleryTheme.matcha => matchaTheme,
    GalleryTheme.stone => stoneTheme,
    GalleryTheme.gothic => gothicTheme,
    GalleryTheme.chocolate => chocolateTheme,
    GalleryTheme.y2k => y2kTheme,
    GalleryTheme.butter => butterTheme,
  };
}

/// Which brightness the gallery renders in.
enum GalleryBrightness {
  system('System'),
  light('Light'),
  dark('Dark');

  const GalleryBrightness(this.label);

  final String label;

  Brightness? resolve(Brightness platform) => switch (this) {
    GalleryBrightness.system => platform,
    GalleryBrightness.light => Brightness.light,
    GalleryBrightness.dark => Brightness.dark,
  };

  /// The equivalent `AstryxColorMode`.
  AstryxColorMode get colorMode => switch (this) {
    GalleryBrightness.system => AstryxColorMode.system,
    GalleryBrightness.light => AstryxColorMode.light,
    GalleryBrightness.dark => AstryxColorMode.dark,
  };
}

/// Which interaction density the gallery renders at.
enum GalleryDensity {
  pointer('Pointer', AstryxDensity.pointer),
  touch('Touch', AstryxDensity.touch);

  const GalleryDensity(this.label, this.density);

  final String label;

  /// The `AstryxDensity` this entry selects.
  final AstryxDensity density;
}

/// Holds everything the gallery chrome can change about how demos render.
///
/// Feeds `AstryxThemeProvider` directly, so the gallery exercises the same
/// path an application takes rather than a parallel one.
class GalleryController extends ChangeNotifier {
  GalleryTheme get theme => _theme;
  GalleryTheme _theme = GalleryTheme.neutral;
  set theme(GalleryTheme value) {
    if (_theme == value) return;
    _theme = value;
    notifyListeners();
  }

  GalleryBrightness get brightness => _brightness;
  GalleryBrightness _brightness = GalleryBrightness.system;
  set brightness(GalleryBrightness value) {
    if (_brightness == value) return;
    _brightness = value;
    notifyListeners();
  }

  GalleryDensity get density => _density;
  GalleryDensity _density = GalleryDensity.pointer;
  set density(GalleryDensity value) {
    if (_density == value) return;
    _density = value;
    notifyListeners();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection = TextDirection.ltr;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    notifyListeners();
  }
}
