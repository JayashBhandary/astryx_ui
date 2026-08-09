/// Overlays — everything that floats above the page.
///
/// Four of the five are anchored to a trigger and share one positioning
/// engine; `AstryxDialog` is anchored to the viewport instead. All five share
/// the focus trap, the dismissal stack and the surface.
library;

export 'anchored_overlay.dart' hide AstryxAnchoredOverlay;
export 'dialog.dart';
export 'dropdown_menu.dart';
export 'popover.dart';
export 'toast.dart';
export 'tooltip.dart';
