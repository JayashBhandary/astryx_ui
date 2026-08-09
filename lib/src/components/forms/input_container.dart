/// The bordered box every text-like control sits in.
///
/// Shared by `AstryxTextInput`, `AstryxTextArea` and `AstryxSelector` — the
/// exit criteria for Phase 8 require it to be shared rather than duplicated,
/// because three controls drifting apart on border colour and focus ring is
/// exactly how a design system stops looking like one.
library;

import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/foundation/density.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/size_scope.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// The control heights a text-like input can take.
enum AstryxInputSize {
  /// 28px. Dense forms and inline editing.
  sm(AstryxSizeToken.elementSm, AstryxElementSize.sm),

  /// 32px. The default.
  md(AstryxSizeToken.elementMd, AstryxElementSize.md),

  /// 36px. Prominent or touch-leaning forms.
  lg(AstryxSizeToken.elementLg, AstryxElementSize.lg);

  const AstryxInputSize(this.token, this.elementSize);

  /// The size token giving this control's height.
  final AstryxSizeToken token;

  /// The equivalent [AstryxElementSize], for the inherited size cascade.
  final AstryxElementSize elementSize;

  /// The input size matching an inherited [AstryxElementSize].
  static AstryxInputSize fromElementSize(AstryxElementSize size) =>
      switch (size) {
        AstryxElementSize.sm => AstryxInputSize.sm,
        AstryxElementSize.md => AstryxInputSize.md,
        AstryxElementSize.lg => AstryxInputSize.lg,
      };
}

/// The bordered surface a text-like control paints on.
///
/// Owns the border, background, focus ring and status ring, and the
/// click-to-focus behaviour — a port of upstream's `useInputContainer`, where
/// a press anywhere on the container focuses the control inside it. A user who
/// clicks the padding of a text field expects a caret, not nothing.
@internal
class AstryxInputContainer extends StatelessWidget {
  /// Creates an input container.
  const AstryxInputContainer({
    required this.child,
    required this.focused,
    super.key,
    this.size = AstryxInputSize.md,
    this.status,
    this.enabled = true,
    this.readOnly = false,
    this.leading,
    this.trailing,
    this.onTap,
    this.multiline = false,
    this.minHeight,
  });

  /// The control itself.
  final Widget child;

  /// Whether the control holds focus.
  final bool focused;

  /// The control height.
  final AstryxInputSize size;

  /// The validation state, which draws an inset ring.
  final AstryxFieldStatus? status;

  /// Whether the control accepts input.
  final bool enabled;

  /// Whether the value can be read but not changed.
  final bool readOnly;

  /// Content before the control — an icon, a prefix.
  final Widget? leading;

  /// Content after the control — a clear button, a status icon.
  final Widget? trailing;

  /// Called when the container is pressed, to focus the control.
  final VoidCallback? onTap;

  /// Whether the control grows vertically rather than sitting at one height.
  final bool multiline;

  /// A minimum height, for a multiline control.
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final density = AstryxTheme.densityOf(context);

    final height = theme.size(size.token);
    // Touch density floors the height, and the padding scales with it so the
    // text baseline stays centred rather than being clipped at the top.
    final effectiveHeight = multiline
        ? null
        : (density == AstryxDensity.touch
              ? (height < density.minimumTapTarget
                    ? density.minimumTapTarget
                    : height)
              : height);

    final borderColor = switch (status?.type) {
      null when focused => theme.color(AstryxColorToken.accent),
      null => theme.color(AstryxColorToken.borderEmphasized),
      final type => theme.color(type.color),
    };

    final shadows = <BoxShadow>[
      // The status ring is an inset shadow token — `--shadow-inset-error` and
      // friends — which is what those five tokens exist for. Flutter cannot
      // paint an inset BoxShadow, so it is drawn as an inner border instead;
      // see the Border below.
      if (focused && status == null)
        ...theme.boxShadows(AstryxShadowToken.insetSelected),
    ];

    Widget container = AnimatedContainer(
      duration: motion.duration(AstryxDurationToken.fastMin),
      curve: motion.curve(),
      height: effectiveHeight,
      constraints: multiline && minHeight != null
          ? BoxConstraints(minHeight: minHeight!)
          : null,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing2),
        vertical: multiline ? theme.spacing(AstryxSpacingToken.spacing2) : 0,
      ),
      decoration: BoxDecoration(
        color: theme.color(
          enabled && !readOnly
              ? AstryxColorToken.backgroundSurface
              : AstryxColorToken.backgroundMuted,
        ),
        borderRadius: theme.borderRadius(AstryxRadiusToken.element),
        border: Border.all(
          color: borderColor,
          // Doubled when focused or in a status state, which is how the ring
          // reads as a ring rather than as a slightly darker border.
          width: theme.borderWidth() * (focused || status != null ? 2 : 1),
        ),
        boxShadow: shadows.isEmpty ? null : shadows,
      ),
      child: Row(
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        spacing: theme.spacing(AstryxSpacingToken.spacing2),
        children: <Widget>[
          ?leading,
          Expanded(child: child),
          ?trailing,
        ],
      ),
    );

    if (onTap != null && enabled) {
      container = MouseRegion(
        cursor: SystemMouseCursors.text,
        child: GestureDetector(
          // Opaque so a press on the container's padding — not just on the
          // text — reaches this and focuses the control. Upstream's
          // `useInputContainer` does the same.
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: container,
        ),
      );
    }

    return container;
  }
}

/// Resolves the effective status for a control: its own, then its field's.
@internal
AstryxFieldStatus? resolveAstryxStatus(
  BuildContext context,
  AstryxFieldStatus? own,
) => own ?? AstryxFieldScope.maybeOf(context)?.status;

/// Resolves the effective size, honouring the inherited size cascade.
@internal
AstryxInputSize resolveAstryxInputSize(
  BuildContext context,
  AstryxInputSize? own,
) =>
    own ??
    AstryxInputSize.fromElementSize(
      AstryxSizeScope.resolve(context, null),
    );
