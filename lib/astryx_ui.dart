/// astryx_ui — an unofficial Flutter port of Astryx, Meta's design system.
///
/// Import this library to get the full public surface: the theme engine, the
/// prebuilt themes, and every component.
///
/// ```dart
/// import 'package:astryx_ui/astryx_ui.dart';
/// ```
///
/// If you only need tokens and theme types — for example to configure a
/// charting library or a non-Astryx widget — import the lighter
/// `package:astryx_ui/theme.dart` instead.
library;

// The theme layer is part of the full surface too.
export 'src/app/astryx_app.dart';
export 'src/app/astryx_theme_provider.dart';
export 'src/components/action/action.dart';
export 'src/components/data/data.dart';
export 'src/components/feedback/feedback.dart';
export 'src/components/forms/forms.dart';
export 'src/components/layout/layout.dart';
export 'src/components/overlay/overlay.dart';
export 'src/components/surface/surface.dart';
export 'src/foundation/foundation.dart';
export 'src/icons/icon_registry.dart';
export 'src/localizations/astryx_localizations.dart';
export 'theme.dart';

// Phases 5–10 shipped the whole Tier-1 component inventory: layout and
// typography, actions, status, forms, overlays, surfaces and data display.
