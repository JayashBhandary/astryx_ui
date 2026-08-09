/// Per-widget theme classes.
///
/// One immutable `AstryxXTheme` per widget, every field nullable — null means
/// "fall through to the token default". Hand-written from the template in
/// `02-CONVENTIONS.md` §6; the helpers that make that cheap live in
/// `component_theme.dart`.
library;

export 'button.dart';
export 'component_theme.dart';
export 'divider.dart';
export 'icon.dart';
export 'text.dart';
