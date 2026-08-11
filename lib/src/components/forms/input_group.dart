/// Adjacent inputs and affixes joined into one bordered control.
library;

import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/size_scope.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A row of inputs and affixes that reads as one control.
///
/// `https://` before a text field, `.00` after a number, a unit selector at the
/// end of an amount. The children keep their own borders where the group's edge
/// is and square them where they meet, so a reader sees one box rather than
/// three.
///
/// {@tool snippet}
/// ```dart
/// AstryxInputGroup(
///   label: 'Project URL',
///   children: <Widget>[
///     const AstryxInputGroupText('https://'),
///     Expanded(
///       child: AstryxTextInput(
///         label: 'Project URL',
///         labelHidden: true,
///         controller: _slug,
///       ),
///     ),
///     const AstryxInputGroupText('.example.com'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// The group carries the label, the description and the status for the whole
/// row, so each input inside it takes `labelHidden: true` and says nothing of
/// its own. That is upstream's arrangement too: one `Field` around a `role=
/// "group"`.
class AstryxInputGroup extends StatelessWidget {
  /// Creates an input group.
  const AstryxInputGroup({
    required this.label,
    required this.children,
    super.key,
    this.description,
    this.status,
    this.size,
    this.enabled = true,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.width,
  });

  /// {@macro AstryxField.label}
  final String label;

  /// The inputs and affixes, in reading order.
  ///
  /// Wrap the one that should take the leftover width in an `Expanded`; the
  /// affixes size to their content.
  final List<Widget> children;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  ///
  /// Applies to the whole group's border, not to one input inside it.
  final AstryxFieldStatus? status;

  /// The size every input in the group takes unless it sets its own.
  final AstryxInputSize? size;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// A fixed width for the whole field.
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final resolvedSize = resolveAstryxInputSize(context, size);

    final joined = <Widget>[
      for (var i = 0; i < children.length; i++)
        AstryxInputGroupScope(
          position: AstryxInputGroupPosition.of(i, children.length),
          status: status,
          child: children[i],
        ),
    ];

    return AstryxField(
      label: label,
      description: description,
      status: status,
      required: required,
      optional: optional,
      enabled: enabled,
      labelHidden: labelHidden,
      width: width,
      child: AstryxSizeScope(
        size: resolvedSize.elementSize,
        child: Semantics(
          container: true,
          label: label,
          // Each input keeps its own node: they are separate controls that
          // happen to share a border, and merging them would leave a reader
          // with one field of indeterminate content.
          explicitChildNodes: true,
          child: Opacity(
            opacity: enabled ? 1 : 0.5,
            // Centred, not stretched: `stretch` hands every child an infinite
            // height, and an affix that asks for a minimum height of its own
            // then has nothing to measure against. Each child already knows the
            // height its size token gives it.
            child: Row(children: joined),
          ),
        ),
      ),
    );
  }
}

/// Where a child sits in its [AstryxInputGroup].
enum AstryxInputGroupPosition {
  /// The reading-start end. Rounds its start corners only.
  start,

  /// Between two others. Square on both ends.
  middle,

  /// The reading-end end. Rounds its end corners only.
  end,

  /// The only child, which is round on both ends and therefore ungrouped in
  /// appearance.
  only;

  /// The position of the child at [index] of [count].
  static AstryxInputGroupPosition of(int index, int count) {
    if (count == 1) return AstryxInputGroupPosition.only;
    if (index == 0) return AstryxInputGroupPosition.start;
    if (index == count - 1) return AstryxInputGroupPosition.end;
    return AstryxInputGroupPosition.middle;
  }

  /// The radii for this position, given the theme's element radius.
  ///
  /// Directional, so the "start" child rounds its reading-start corners — the
  /// left in LTR, the right in RTL — without knowing which it is.
  BorderRadiusGeometry radius(Radius corner) => switch (this) {
    AstryxInputGroupPosition.only => BorderRadius.all(corner),
    AstryxInputGroupPosition.start => BorderRadiusDirectional.horizontal(
      start: corner,
    ),
    AstryxInputGroupPosition.end => BorderRadiusDirectional.horizontal(
      end: corner,
    ),
    AstryxInputGroupPosition.middle => BorderRadius.zero,
  };
}

/// Tells a control that it is part of an [AstryxInputGroup].
///
/// The port of upstream's `InputGroupContext`, which is how a text field in a
/// group knows to drop the border radius on the edges that meet its
/// neighbours. `AstryxInputContainer` is the only reader.
class AstryxInputGroupScope extends InheritedWidget {
  /// Creates an input group scope.
  const AstryxInputGroupScope({
    required super.child,
    required this.position,
    super.key,
    this.status,
  });

  /// Where this child sits in the group.
  final AstryxInputGroupPosition position;

  /// The group's status, which every child paints rather than only the one that
  /// caused it.
  final AstryxFieldStatus? status;

  /// The group at [context], or null outside one.
  static AstryxInputGroupScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxInputGroupScope>();

  @override
  bool updateShouldNotify(AstryxInputGroupScope oldWidget) =>
      position != oldWidget.position || status != oldWidget.status;
}

/// A text affix inside an [AstryxInputGroup] — a prefix, a suffix, a unit.
///
/// Not a control: it takes no focus, holds no value and is not announced on its
/// own. Anything it says that the group's label does not belongs in the label
/// or the description.
class AstryxInputGroupText extends StatelessWidget {
  /// Creates an affix from a string.
  const AstryxInputGroupText(String this.text, {super.key}) : child = null;

  /// Creates an affix from a widget — an icon, a small row.
  const AstryxInputGroupText.custom({required Widget this.child, super.key})
    : text = null;

  /// The affix text.
  final String? text;

  /// The affix content, for [AstryxInputGroupText.custom].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final group = AstryxInputGroupScope.maybeOf(context);
    final size = resolveAstryxInputSize(context, null);

    final corner = Radius.circular(theme.radius(AstryxRadiusToken.element));
    final position = group?.position ?? AstryxInputGroupPosition.only;

    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.color(AstryxColorToken.backgroundMuted),
          borderRadius: position.radius(corner),
          border: Border.all(
            color: theme.color(
              group?.status == null
                  ? AstryxColorToken.borderEmphasized
                  : group!.status!.type.color,
            ),
            width: theme.borderWidth(),
          ),
        ),
        child: SizedBox(
          // The same height the inputs beside it take, so the joined border is
          // one rectangle rather than a staircase.
          height: theme.size(size.token),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: theme.spacing(AstryxSpacingToken.spacing2),
            ),
            child: Center(
              child:
                  child ??
                  AstryxText(
                    text!,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
