/// Cascading control size.
library;

import 'package:flutter/widgets.dart';

/// The standard control sizes.
///
/// A port of upstream's `ElementSize`. The three values map to the
/// `--size-element-*` tokens.
enum AstryxElementSize {
  /// 28px tall. Dense toolbars and inline controls.
  sm,

  /// 32px tall. The default.
  md,

  /// 36px tall. Prominent actions and touch-leaning layouts.
  lg,
}

/// Cascades a default control size to descendants.
///
/// A port of upstream's `SizeContext`. A container — a button group, a toolbar,
/// a card header — sets a size once and the interactive widgets inside pick it
/// up, so a `sm` group does not mean writing `size: sm` on every child.
///
/// An explicit size on a widget always wins. See [AstryxSizeScope.resolve].
///
/// {@tool snippet}
/// ```dart
/// AstryxSizeScope(
///   size: AstryxElementSize.sm,
///   child: AstryxButtonGroup(children: <Widget>[…]),
/// )
/// ```
/// {@end-tool}
class AstryxSizeScope extends InheritedWidget {
  /// Creates a size scope.
  const AstryxSizeScope({
    required this.size,
    required super.child,
    super.key,
  });

  /// The size descendants inherit.
  final AstryxElementSize size;

  /// The inherited size at [context], or null if no scope is installed.
  ///
  /// Null means "no container is providing a size", which is different from
  /// "the container asked for md" — a widget whose own default is not `md`
  /// needs to tell those apart.
  static AstryxElementSize? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxSizeScope>()?.size;

  /// Resolves the effective size: [explicit], then the inherited size, then
  /// [fallback].
  ///
  /// The whole cascade in one call, so every widget resolves it the same way.
  ///
  /// {@tool snippet}
  /// ```dart
  /// final size = AstryxSizeScope.resolve(context, widget.size);
  /// ```
  /// {@end-tool}
  static AstryxElementSize resolve(
    BuildContext context,
    AstryxElementSize? explicit, {
    AstryxElementSize fallback = AstryxElementSize.md,
  }) => explicit ?? maybeOf(context) ?? fallback;

  @override
  bool updateShouldNotify(AstryxSizeScope oldWidget) => size != oldWidget.size;
}
