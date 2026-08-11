/// Overlays — everything that floats above the page, and the disclosures that
/// do the same job in the flow of the page.
///
/// Most are anchored to a trigger and share one positioning engine;
/// `AstryxDialog`, `AstryxAlertDialog` and `AstryxOverlay` are anchored to the
/// viewport instead. All of them share the focus trap, the dismissal stack and
/// the surface.
library;

export 'alert_dialog.dart';
export 'anchored_overlay.dart' hide AstryxAnchoredOverlay;
export 'collapsible.dart' hide AstryxCollapsibleGroupScope;
export 'collapsible_group.dart';
export 'context_menu.dart';
export 'dialog.dart';
export 'dropdown_menu.dart';
export 'hover_card.dart';
export 'menu_entry.dart';
export 'overlay_layer.dart';
export 'popover.dart';
export 'toast.dart';
export 'tooltip.dart';
