/// The geometry a form's fields share.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How a [AstryxFormLayout] arranges its fields.
enum AstryxFormLayoutDirection {
  /// Stacked, one per line. The default, and what most forms want.
  vertical,

  /// Side by side in equal columns.
  horizontal,

  /// Stacked, with each label to the reading-start side of its own control.
  ///
  /// The settings-panel arrangement. Collapses to [vertical] below
  /// [AstryxFormLayout.labelCollapseWidth], because a label column and a
  /// usable control do not both fit on a phone.
  horizontalLabels,
}

/// Arranges form fields with one gap and one label geometry.
///
/// It is not a `Form`: submission, validation and state are the application's,
/// and this only decides where the fields sit. Nesting works — a horizontal
/// layout inside a vertical one is a row of fields inside a column of them.
///
/// {@tool snippet}
/// ```dart
/// AstryxFormLayout(
///   children: <Widget>[
///     AstryxTextInput(label: 'Name', controller: _name),
///     AstryxTextInput(label: 'Email', controller: _email),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// [AstryxFormLayoutDirection.horizontalLabels] is the one that does more than
/// space things out: every `AstryxField` below it moves its label beside its
/// control instead of above it, through [AstryxFormLayoutScope].
class AstryxFormLayout extends StatelessWidget {
  /// Creates a form layout.
  const AstryxFormLayout({
    required this.children,
    super.key,
    this.direction = AstryxFormLayoutDirection.vertical,
    this.gap,
    this.labelWidth,
  });

  /// The width below which [AstryxFormLayoutDirection.horizontalLabels]
  /// collapses to a stack — upstream's own 480px.
  static const double labelCollapseWidth = 480;

  /// The fields, in order.
  final List<Widget> children;

  /// How to arrange them.
  final AstryxFormLayoutDirection direction;

  /// The space between fields. Defaults to `--spacing-4`.
  final AstryxSpacingToken? gap;

  /// The width of the label column under
  /// [AstryxFormLayoutDirection.horizontalLabels].
  ///
  /// Upstream sizes the column to its widest label, which CSS grid does for
  /// free and Flutter cannot without measuring every label twice. A number is
  /// the honest version: pick one that fits the longest label in the form.
  final double? labelWidth;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final theme = AstryxTheme.of(context);
    final spacing = theme.spacing(gap ?? AstryxSpacingToken.spacing4);

    switch (direction) {
      case AstryxFormLayoutDirection.vertical:
        return _scope(
          AstryxFormLayoutDirection.vertical,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: spacing,
            children: children,
          ),
        );

      case AstryxFormLayoutDirection.horizontal:
        // Equal columns, which is what `grid-auto-columns: 1fr` gives upstream.
        return _scope(
          AstryxFormLayoutDirection.horizontal,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing,
            children: <Widget>[
              for (final child in children) Expanded(child: child),
            ],
          ),
        );

      case AstryxFormLayoutDirection.horizontalLabels:
        return LayoutBuilder(
          builder: (context, constraints) {
            // The collapse is a real change of arrangement, not a reflow: below
            // the threshold the labels go back above their controls, so the
            // scope has to say `vertical` or every field would still reserve a
            // label column.
            final collapsed = constraints.maxWidth < labelCollapseWidth;

            return _scope(
              collapsed
                  ? AstryxFormLayoutDirection.vertical
                  : AstryxFormLayoutDirection.horizontalLabels,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                spacing: collapsed
                    ? spacing
                    : theme.spacing(AstryxSpacingToken.spacing3),
                children: children,
              ),
            );
          },
        );
    }
  }

  Widget _scope(AstryxFormLayoutDirection resolved, Widget child) =>
      AstryxFormLayoutScope(
        direction: resolved,
        labelWidth: labelWidth,
        child: child,
      );
}

/// Tells the fields below it how the form is arranged.
///
/// The port of upstream's `FormLayoutContext`. `AstryxField` is the only thing
/// in the package that reads it, and it reads it for one reason: to put the
/// label beside the control rather than above it.
class AstryxFormLayoutScope extends InheritedWidget {
  /// Creates a form layout scope.
  const AstryxFormLayoutScope({
    required super.child,
    required this.direction,
    super.key,
    this.labelWidth,
  });

  /// The arrangement in force, already resolved for the current width.
  final AstryxFormLayoutDirection direction;

  /// The width of the label column, when there is one.
  final double? labelWidth;

  /// The layout at [context], or null outside one.
  static AstryxFormLayoutScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxFormLayoutScope>();

  /// Whether a field under [context] should put its label beside its control.
  static bool labelsBesideAt(BuildContext context) =>
      maybeOf(context)?.direction == AstryxFormLayoutDirection.horizontalLabels;

  @override
  bool updateShouldNotify(AstryxFormLayoutScope oldWidget) =>
      direction != oldWidget.direction || labelWidth != oldWidget.labelWidth;
}
