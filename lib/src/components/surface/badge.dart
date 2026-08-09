/// A small status label.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/surface/palette.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/widgets.dart';

/// A badge's colour.
///
/// Two families, and the distinction matters:
///
///  * **Sentiment** — [neutral], [info], [success], [warning], [error] — a
///    solid fill with an `--color-on-*` foreground. These say something is
///    good or bad.
///  * **Categorical** — the nine [AstryxPalette] families — a tinted fill with
///    a matching text colour. These say something *is a category*: a team, a
///    label, an environment. They carry no judgement.
///
/// Reaching for `AstryxBadgeVariant.palette(AstryxPalette.red)` to mean "bad"
/// is the mistake this split exists to prevent; use [error], which pairs the
/// colour with a token that guarantees its foreground contrast.
@immutable
class AstryxBadgeVariant {
  const AstryxBadgeVariant._(this._background, this._foreground, this._palette);

  /// Creates a categorical badge from [palette].
  const AstryxBadgeVariant.palette(AstryxPalette palette)
    : _background = null,
      _foreground = null,
      _palette = palette;

  /// `--color-neutral` with primary text. The default.
  static const AstryxBadgeVariant neutral = AstryxBadgeVariant._(
    AstryxColorToken.neutral,
    AstryxColorToken.textPrimary,
    null,
  );

  /// The accent fill.
  static const AstryxBadgeVariant info = AstryxBadgeVariant._(
    AstryxColorToken.accent,
    AstryxColorToken.onAccent,
    null,
  );

  /// The success fill.
  static const AstryxBadgeVariant success = AstryxBadgeVariant._(
    AstryxColorToken.success,
    AstryxColorToken.onSuccess,
    null,
  );

  /// The warning fill.
  static const AstryxBadgeVariant warning = AstryxBadgeVariant._(
    AstryxColorToken.warning,
    AstryxColorToken.onWarning,
    null,
  );

  /// The error fill.
  ///
  /// Note that upstream's `stone` theme has `--color-on-error` equal to
  /// `--color-error`, a 1.00:1 contrast failure reproduced faithfully and
  /// pinned by a test rather than corrected (ADR-023). A badge is where that
  /// defect is most visible.
  static const AstryxBadgeVariant error = AstryxBadgeVariant._(
    AstryxColorToken.error,
    AstryxColorToken.onError,
    null,
  );

  final AstryxColorToken? _background;
  final AstryxColorToken? _foreground;
  final AstryxPalette? _palette;

  /// The fill token.
  AstryxColorToken get backgroundToken => _palette?.background ?? _background!;

  /// The text token.
  AstryxColorToken get foregroundToken => _palette?.text ?? _foreground!;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxBadgeVariant &&
          other._background == _background &&
          other._foreground == _foreground &&
          other._palette == _palette;

  @override
  int get hashCode => Object.hash(_background, _foreground, _palette);
}

/// A small pill showing a status, a count or a category.
///
/// {@tool snippet}
/// ```dart
/// const AstryxBadge('Active', variant: AstryxBadgeVariant.success);
/// const AstryxBadge('3', variant: AstryxBadgeVariant.error);
/// const AstryxBadge(
///   'Engineering',
///   variant: AstryxBadgeVariant.palette(AstryxPalette.purple),
/// );
/// ```
/// {@end-tool}
///
/// **A badge is not a button.** It has no press state and takes no callback; if
/// something should happen when it is pressed, it is a button that happens to
/// be small.
class AstryxBadge extends StatelessWidget {
  /// Creates a badge.
  const AstryxBadge(
    this.label, {
    super.key,
    this.variant = AstryxBadgeVariant.neutral,
    this.icon,
    this.semanticsLabel,
  });

  /// The text.
  final String label;

  /// The colour.
  final AstryxBadgeVariant variant;

  /// An icon before the text.
  ///
  /// Any widget. Pass `AstryxIcon(AstryxIconName.check)` for one of the
  /// registry's semantic names, or any other icon widget for something the
  /// registry has no name for — a consumer's menu will want "edit" and
  /// "delete", which are not in upstream's 28 (ADR-043).
  ///
  /// Size and colour come from the enclosing `IconTheme`, so an
  /// `AstryxIcon` with the default `AstryxIconColor.inherit` and a plain
  /// `Icon` both come out looking right.
  final Widget? icon;

  /// Overrides what a screen reader announces.
  ///
  /// For a badge whose visible text is a bare number: "3" is meaningless
  /// spoken aloud, "3 unread" is not.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final style = theme
        .textStyle(AstryxTypeRole.supporting)
        .copyWith(
          color: theme.color(variant.foregroundToken),
          fontWeight: theme.fontWeight(AstryxFontWeightToken.medium),
        );

    return Semantics(
      container: true,
      label: semanticsLabel ?? label,
      child: ExcludeSemantics(
        child: Container(
          // A *minimum* height, not a fixed one. Upstream hard-codes
          // `--spacing-5`, which is right at 100% and clips the label at 200%
          // — the height is a token, the text is not (ADR-042).
          constraints: BoxConstraints(
            minHeight: theme.spacing(AstryxSpacingToken.spacing5),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing(AstryxSpacingToken.spacing2),
          ),
          decoration: BoxDecoration(
            color: theme.color(variant.backgroundToken),
            borderRadius: theme.borderRadius(AstryxRadiusToken.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: theme.spacing(AstryxSpacingToken.spacing1),
            children: <Widget>[
              if (icon != null)
                // The *text* token, not `--color-icon-*`. Upstream's badge
                // icon inherits `currentColor`, and the icon tokens are tuned
                // for a body background rather than for a tint — on a yellow
                // badge in light mode they land at 1.4:1 (ADR-040).
                IconTheme.merge(
                  data: IconThemeData(
                    size: AstryxIconSize.xsm.pixels,
                    color: theme.color(variant.foregroundToken),
                  ),
                  child: icon!,
                ),
              // `Flexible`, so a badge in a tight row ellipsises rather than
              // overflowing its parent.
              Flexible(
                child: Text(
                  label,
                  style: style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
