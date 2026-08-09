import 'package:flutter/widgets.dart';

/// The seven themes Astryx ships upstream.
///
/// Ported one by one in Phase 3 — see `dev/phases/PHASE-03-theme-runtime.md`.
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
}

/// Placeholder for `AstryxDensity`, which arrives in Phase 3 (`P3-4`).
///
/// The picker is wired now so that no component can be built without somewhere
/// obvious to check it at both densities.
enum GalleryDensity {
  pointer('Pointer'),
  touch('Touch');

  const GalleryDensity(this.label);

  final String label;
}

/// Holds everything the gallery chrome can change about how demos render.
///
/// In Phase 3 this becomes the input to `AstryxThemeProvider`. Until then it
/// only drives the pickers, so the plumbing is proven before it carries load.
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
