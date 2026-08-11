/// The examples on the Themes page.
///
/// Every other page renders in one theme — whichever the picker at the top of
/// the site is set to. These render all eight at once, which is possible only
/// because a theme is a value rather than a global: nesting
/// `AstryxThemeProvider` re-themes a subtree, and nothing above or below it
/// needs to know.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/examples/theming_examples.dart';
import 'package:flutter/widgets.dart';

/// The eight themes, in the order the picker at the top of the page lists them.
///
/// Seven ship with the package. `acme` is `defineTheme`d from one hex accent in
/// `theming_examples.dart`, and is in the gallery deliberately: a theme the
/// engine generated should be indistinguishable from the seven that were tuned
/// by hand.
final List<(String, AstryxDefinedTheme)> galleryThemes =
    <(String, AstryxDefinedTheme)>[
      ('neutral', neutralTheme),
      ('matcha', matchaTheme),
      ('stone', stoneTheme),
      ('gothic', gothicTheme),
      ('chocolate', chocolateTheme),
      ('y2k', y2kTheme),
      ('butter', butterTheme),
      ('acme', acmeTheme),
    ];

/// The tokens the swatch example samples, left to right.
///
/// Six of the seventy-nine, chosen because they are the ones that differ most
/// visibly between themes: the accent, the two surfaces a page is built from,
/// the line between them, and the two statuses every theme keeps
/// convention-bound.
const List<AstryxColorToken> gallerySwatchTokens = <AstryxColorToken>[
  AstryxColorToken.accent,
  AstryxColorToken.backgroundBody,
  AstryxColorToken.backgroundCard,
  AstryxColorToken.border,
  AstryxColorToken.success,
  AstryxColorToken.error,
];

// #example themes_gallery -> ThemesGalleryExample
class ThemesGalleryExample extends StatelessWidget {
  const ThemesGalleryExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 210,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (name, theme) in galleryThemes)
          AstryxThemeProvider(
            theme: theme,
            // Each cell paints its own page background rather than borrowing
            // the site's: `--color-background-body` is the first thing that
            // separates one theme from the next, and a gallery that hides it
            // would be comparing seven cards on one page.
            child: Builder(
              builder: (context) {
                final t = AstryxTheme.of(context);

                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: t.color(AstryxColorToken.backgroundBody),
                    borderRadius: t.borderRadius(AstryxRadiusToken.container),
                    border: Border.all(
                      color: t.color(AstryxColorToken.border),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      t.spacing(AstryxSpacingToken.spacing3),
                    ),
                    child: AstryxVStack(
                      gap: AstryxSpacingToken.spacing2,
                      align: AstryxStackAlign.stretch,
                      children: <Widget>[
                        AstryxHeading(name, level: 4),
                        const AstryxText(
                          'Body copy, on the page.',
                          type: AstryxTextType.supporting,
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
                );
              },
            ),
          ),
      ],
    );
  }
}
// #end

// #example themes_light_dark -> ThemesLightDarkExample
class ThemesLightDarkExample extends StatelessWidget {
  const ThemesLightDarkExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (name, theme) in galleryThemes)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(name, type: AstryxTextType.label),
              // A colour token is not a colour: it is a `light-dark()` pair,
              // and the mode picks a half. Both halves come from the one
              // definition — dark mode is not a second theme to maintain.
              for (final mode in <AstryxColorMode>[
                AstryxColorMode.light,
                AstryxColorMode.dark,
              ])
                AstryxThemeProvider(
                  theme: theme,
                  mode: mode,
                  child: Builder(
                    builder: (context) {
                      final t = AstryxTheme.of(context);

                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: t.color(AstryxColorToken.backgroundBody),
                          border: Border.all(
                            color: t.color(AstryxColorToken.border),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            t.spacing(AstryxSpacingToken.spacing2),
                          ),
                          child: AstryxHStack(
                            gap: AstryxSpacingToken.spacing2,
                            children: <Widget>[
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: t.color(AstryxColorToken.accent),
                                  borderRadius: t.borderRadius(
                                    AstryxRadiusToken.inner,
                                  ),
                                ),
                                child: const SizedBox(width: 18, height: 18),
                              ),
                              AstryxText(
                                mode.name,
                                type: AstryxTextType.supporting,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example themes_swatches -> ThemesSwatchesExample
class ThemesSwatchesExample extends StatelessWidget {
  const ThemesSwatchesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final (name, theme) in galleryThemes)
          Row(
            children: <Widget>[
              SizedBox(
                width: 84,
                child: AstryxText(
                  name,
                  type: AstryxTextType.code,
                  color: AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ),
              // The swatches resolve inside the theme they belong to. Reading a
              // token is the only way to sample one: the values live in the
              // resolved token set, not in a constant anybody can import.
              Expanded(
                child: AstryxThemeProvider(
                  theme: theme,
                  child: Builder(
                    builder: (context) {
                      final t = AstryxTheme.of(context);

                      return Row(
                        children: <Widget>[
                          for (final token in gallerySwatchTokens)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: t.color(token),
                                    borderRadius: t.borderRadius(
                                      AstryxRadiusToken.inner,
                                    ),
                                    border: Border.all(
                                      color: t.color(AstryxColorToken.border),
                                    ),
                                  ),
                                  child: const SizedBox(height: 24),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example themes_components -> ThemesComponentsExample
class ThemesComponentsExample extends StatelessWidget {
  const ThemesComponentsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 250,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (name, theme) in galleryThemes)
          AstryxThemeProvider(
            theme: theme,
            // The same four controls, eight times. Nothing below this line
            // names a colour, a radius or a size: every one of them is a token
            // the provider above resolved.
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(name, type: AstryxTextType.label),
                  AstryxTextInput(
                    label: 'Service',
                    placeholder: 'api-gateway',
                    size: AstryxInputSize.sm,
                    onChanged: (_) {},
                  ),
                  AstryxSwitch(
                    label: 'Alert on failure',
                    value: true,
                    size: AstryxToggleSize.sm,
                    onChanged: (_) {},
                  ),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      AstryxButton(
                        label: 'Deploy',
                        variant: AstryxButtonVariant.primary,
                        size: AstryxButtonSize.sm,
                        onPressed: () {},
                      ),
                      AstryxIconButton(
                        icon: AstryxIconName.moreHorizontal,
                        label: 'More',
                        size: AstryxButtonSize.sm,
                        onPressed: () {},
                      ),
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
