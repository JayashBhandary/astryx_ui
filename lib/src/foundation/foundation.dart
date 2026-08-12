/// Layer 3 — the shared interaction machinery every component depends on.
///
/// Nothing here is user-facing. Everything above it is.
///
/// Astryx leans on CSS features with no Flutter equivalent — `:focus-visible`,
/// `@media (hover: hover)`, `prefers-reduced-motion`, logical properties.
/// Solving each once, here, is the difference between a coherent design system
/// and 31 widgets that each guessed differently.
library;

export 'density.dart';
export 'entry_animation.dart';
export 'focus_ring.dart';
export 'focus_trap.dart';
export 'focus_visible.dart';
export 'hotkeys.dart';
export 'keyboard_hint.dart';
export 'link_delegate.dart';
export 'motion.dart';
export 'overlay_positioner.dart';
export 'overlay_stack.dart';
export 'roving_focus.dart';
export 'rtl.dart';
export 'scroll_lock.dart';
export 'scroll_overflow.dart';
export 'semantics.dart';
export 'size_scope.dart';
export 'states_controller.dart';
export 'tap_target.dart';
