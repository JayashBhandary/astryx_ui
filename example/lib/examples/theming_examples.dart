import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// A theme defined here, not shipped with the package.
///
/// One hex accent is enough: the engine derives the whole palette from it,
/// including the `--color-on-*` foregrounds that keep text legible.
final AstryxDefinedTheme acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(accent: '#0F62FE'),
    radius: AstryxRadiusScaleConfig(base: 2, multiplier: 2),
  ),
);

// #example theming_themes -> ThemingThemesExample
class ThemingThemesExample extends StatelessWidget {
  const ThemingThemesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Every theme is a value. Nesting a provider re-themes a subtree, which is
    // how a preview like this one can show all seven at once.
    return AstryxGrid(
      minWidth: 150,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final theme in <(String, AstryxDefinedTheme)>[
          ('neutral', neutralTheme),
          ('matcha', matchaTheme),
          ('stone', stoneTheme),
          ('gothic', gothicTheme),
          ('chocolate', chocolateTheme),
          ('y2k', y2kTheme),
          ('butter', butterTheme),
          ('acme (custom)', acmeTheme),
        ])
          AstryxThemeProvider(
            theme: theme.$2,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(theme.$1, type: AstryxTextType.label),
                  AstryxButton(
                    label: 'Primary',
                    variant: AstryxButtonVariant.primary,
                    size: AstryxButtonSize.sm,
                    onPressed: () {},
                  ),
                  const AstryxHStack(
                    gap: AstryxSpacingToken.spacing1,
                    wrap: true,
                    runGap: AstryxSpacingToken.spacing1,
                    children: <Widget>[
                      AstryxBadge('A', variant: AstryxBadgeVariant.info),
                      AstryxBadge('B', variant: AstryxBadgeVariant.success),
                      AstryxBadge('C', variant: AstryxBadgeVariant.error),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
// #end

// #example theming_modes -> ThemingModesExample
class ThemingModesExample extends StatelessWidget {
  const ThemingModesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `mode` defaults to `system`, which tracks the platform's own preference
    // through `MediaQuery` — no rebuild of your own required.
    return AstryxGrid(
      minWidth: 200,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final mode in <AstryxColorMode>[
          AstryxColorMode.light,
          AstryxColorMode.dark,
        ])
          AstryxThemeProvider(
            mode: mode,
            child: Builder(
              builder: (context) => ColoredBox(
                color: AstryxTheme.of(
                  context,
                ).color(AstryxColorToken.backgroundBody),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing2,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      AstryxText(mode.name, type: AstryxTextType.label),
                      const AstryxText(
                        'Body copy on the page background.',
                        color: AstryxTextColor.secondary,
                      ),
                      AstryxButton(
                        label: 'Primary',
                        variant: AstryxButtonVariant.primary,
                        size: AstryxButtonSize.sm,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
// #end

// #example theming_tokens -> ThemingTokensExample
class ThemingTokensExample extends StatelessWidget {
  const ThemingTokensExample({super.key});

  /// The tokens a page reaches for most often. There are 100-odd in total.
  static const List<AstryxColorToken> _tokens = <AstryxColorToken>[
    AstryxColorToken.accent,
    AstryxColorToken.accentMuted,
    AstryxColorToken.backgroundBody,
    AstryxColorToken.backgroundSurface,
    AstryxColorToken.backgroundCard,
    AstryxColorToken.backgroundMuted,
    AstryxColorToken.border,
    AstryxColorToken.borderEmphasized,
    AstryxColorToken.success,
    AstryxColorToken.warning,
    AstryxColorToken.error,
    AstryxColorToken.backgroundInverted,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 180,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final token in _tokens)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(token),
                  borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
                  border: Border.all(
                    color: theme.color(AstryxColorToken.border),
                  ),
                ),
                child: const SizedBox(width: 24, height: 24),
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
    );
  }
}
// #end

// #example theming_spacing -> ThemingSpacingExample
class ThemingSpacingExample extends StatelessWidget {
  const ThemingSpacingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final token in AstryxSpacingToken.values)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              SizedBox(
                width: 96,
                child: AstryxText(
                  token.name,
                  type: AstryxTextType.code,
                  maxLines: 1,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.accentMuted),
                ),
                child: SizedBox(height: 12, width: theme.spacing(token)),
              ),
              AstryxText(
                '${theme.spacing(token)}px',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example theming_density -> ThemingDensityExample
class ThemingDensityExample extends StatelessWidget {
  const ThemingDensityExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Touch density raises every tap target to 48px and suppresses hover-only
    // affordances. The control's painted height does not change — the region
    // that responds to a finger does.
    return AstryxGrid(
      minWidth: 220,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final density in AstryxDensity.values)
          AstryxThemeProvider(
            density: density,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(
                    '${density.name} · min target '
                    '${density.minimumTapTarget.toInt()}px',
                    type: AstryxTextType.label,
                  ),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      AstryxButton(label: 'Save', onPressed: () {}),
                      AstryxIconButton(
                        icon: AstryxIconName.copy,
                        label: 'Copy',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  AstryxCheckbox(
                    label: 'Also a target',
                    value: true,
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
// #end

// #example theming_rtl -> ThemingRtlExample
class ThemingRtlExample extends StatelessWidget {
  const ThemingRtlExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Nothing in the tree below asks about direction. Padding, alignment, icon
    // mirroring, overlay sides and keyboard arrows are all logical.
    return AstryxGrid(
      minWidth: 240,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final direction in TextDirection.values)
          Directionality(
            textDirection: direction,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(
                    direction.name.toUpperCase(),
                    type: AstryxTextType.label,
                  ),
                  AstryxButton(
                    label: 'Next',
                    trailing: const AstryxIcon(AstryxIconName.chevronRight),
                    onPressed: () {},
                  ),
                  AstryxCheckbox(
                    label: 'Label follows the reading edge',
                    value: true,
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
// #end

// #example theming_type_scale -> ThemingTypeScaleExample
class ThemingTypeScaleExample extends StatelessWidget {
  const ThemingTypeScaleExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final role in AstryxTypeRole.values)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.end,
            children: <Widget>[
              SizedBox(
                width: 92,
                child: AstryxText(
                  role.name,
                  type: AstryxTextType.code,
                  color: AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ),
              Flexible(
                child: Text(
                  'The quick brown fox',
                  style: theme.textStyle(role),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
// #end
