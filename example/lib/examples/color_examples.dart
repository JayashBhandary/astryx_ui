import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example color_roles -> ColorRolesExample
class ColorRolesExample extends StatelessWidget {
  const ColorRolesExample({super.key});

  /// The semantic tokens, grouped by the job they do rather than by hue.
  ///
  /// A token is chosen by what it is *for* — the surface a card sits on, the
  /// line that bounds a control — which is why none of them is named after a
  /// colour.
  static const List<(String, List<AstryxColorToken>)> _groups =
      <(String, List<AstryxColorToken>)>[
        (
          'Surfaces',
          <AstryxColorToken>[
            AstryxColorToken.backgroundBody,
            AstryxColorToken.backgroundSurface,
            AstryxColorToken.backgroundCard,
            AstryxColorToken.backgroundMuted,
            AstryxColorToken.backgroundInverted,
          ],
        ),
        (
          'Text and icon',
          <AstryxColorToken>[
            AstryxColorToken.textPrimary,
            AstryxColorToken.textSecondary,
            AstryxColorToken.textDisabled,
            AstryxColorToken.textAccent,
            AstryxColorToken.iconSecondary,
          ],
        ),
        (
          'Lines and fills',
          <AstryxColorToken>[
            AstryxColorToken.border,
            AstryxColorToken.borderEmphasized,
            AstryxColorToken.skeleton,
            AstryxColorToken.track,
            AstryxColorToken.tintHover,
          ],
        ),
        (
          'Sentiment',
          <AstryxColorToken>[
            AstryxColorToken.accent,
            AstryxColorToken.success,
            AstryxColorToken.warning,
            AstryxColorToken.error,
            AstryxColorToken.errorMuted,
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 210,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (title, tokens) in _groups)
          AstryxCard(
            padding: AstryxSpacingToken.spacing3,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxText(title, type: AstryxTextType.label),
                for (final token in tokens)
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.color(token),
                          borderRadius: theme.borderRadius(
                            AstryxRadiusToken.inner,
                          ),
                          border: Border.all(
                            color: theme.color(AstryxColorToken.border),
                          ),
                        ),
                        child: const SizedBox(width: 20, height: 20),
                      ),
                      Flexible(
                        child: AstryxText(
                          token.name,
                          type: AstryxTextType.supporting,
                          color: AstryxTextColor.secondary,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
// #end

// #example color_on_pairs -> ColorOnPairsExample
class ColorOnPairsExample extends StatelessWidget {
  const ColorOnPairsExample({super.key});

  /// Each fill and the foreground that is guaranteed to read on it.
  static const List<(AstryxColorToken, AstryxColorToken)> _pairs =
      <(AstryxColorToken, AstryxColorToken)>[
        (AstryxColorToken.accent, AstryxColorToken.onAccent),
        (AstryxColorToken.success, AstryxColorToken.onSuccess),
        (AstryxColorToken.warning, AstryxColorToken.onWarning),
        (AstryxColorToken.error, AstryxColorToken.onError),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Never choose the foreground yourself. Each `--color-on-*` token is
    // derived from its fill, so it stays legible when the accent changes.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final (fill, on) in _pairs)
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(fill),
              borderRadius: theme.borderRadius(AstryxRadiusToken.element),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing(AstryxSpacingToken.spacing3),
                vertical: theme.spacing(AstryxSpacingToken.spacing2),
              ),
              child: Text(
                on.name,
                style: theme
                    .textStyle(AstryxTypeRole.label)
                    .copyWith(color: theme.color(on)),
              ),
            ),
          ),
      ],
    );
  }
}
// #end

// #example color_palettes -> ColorPalettesExample
class ColorPalettesExample extends StatelessWidget {
  const ColorPalettesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Ten families, four tokens each. They name a category — a team, a label,
    // a series in a chart — and never a severity.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final palette in AstryxPalette.values)
          AstryxBadge(
            palette.name,
            variant: AstryxBadgeVariant.palette(palette),
          ),
      ],
    );
  }
}
// #end
