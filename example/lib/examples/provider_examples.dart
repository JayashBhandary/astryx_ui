import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example provider_theme -> ProviderThemeExample
class ProviderThemeExample extends StatefulWidget {
  const ProviderThemeExample({super.key});

  @override
  State<ProviderThemeExample> createState() => _ProviderThemeExampleState();
}

class _ProviderThemeExampleState extends State<ProviderThemeExample> {
  AstryxDefinedTheme _theme = butterTheme;
  AstryxColorMode _mode = AstryxColorMode.light;

  @override
  Widget build(BuildContext context) {
    // A provider can be nested: this one re-themes its own subtree and leaves
    // the page around it alone. Everything below it — including any overlay it
    // opens — resolves the theme installed here.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxSegmentedControl<AstryxDefinedTheme>(
              label: 'Theme',
              value: _theme,
              segments: <AstryxSegment<AstryxDefinedTheme>>[
                AstryxSegment(value: butterTheme, label: 'Butter'),
                AstryxSegment(value: matchaTheme, label: 'Matcha'),
                AstryxSegment(value: gothicTheme, label: 'Gothic'),
              ],
              onChanged: (theme) => setState(() => _theme = theme),
            ),
            AstryxSegmentedControl<AstryxColorMode>(
              label: 'Mode',
              value: _mode,
              segments: const <AstryxSegment<AstryxColorMode>>[
                AstryxSegment(value: AstryxColorMode.light, label: 'Light'),
                AstryxSegment(value: AstryxColorMode.dark, label: 'Dark'),
              ],
              onChanged: (mode) => setState(() => _mode = mode),
            ),
          ],
        ),
        AstryxThemeProvider(
          theme: _theme,
          mode: _mode,
          child: AstryxCard(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'Inside the provider',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxText(
                  'Colour, radius, type and motion all come from the theme '
                  'installed here — no widget below reads a raw value.',
                ),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxButton(label: 'Primary', onPressed: () {}),
                    const AstryxBadge('Badge'),
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

// #example provider_layer -> ProviderLayerExample
class ProviderLayerExample extends StatefulWidget {
  const ProviderLayerExample({super.key});

  @override
  State<ProviderLayerExample> createState() => _ProviderLayerExampleState();
}

class _ProviderLayerExampleState extends State<ProviderLayerExample> {
  final AstryxOverlayController _layer = AstryxOverlayController();

  @override
  void dispose() {
    _layer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Two layers, one on top of the other. Escape closes the popover and leaves
    // the panel — the stack keeps the order, so one press is one layer.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Raise a layer', onPressed: _layer.show),
        AstryxOverlay(
          controller: _layer,
          label: 'Export',
          child: AstryxCard(
            width: 320,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'Export',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxText(
                  'Open the menu, then press Escape twice: the menu goes '
                  'first, this panel second.',
                ),
                AstryxDropdownMenu(
                  label: 'Format',
                  entries: <AstryxMenuEntry>[
                    AstryxMenuItem(label: 'CSV', onSelected: () {}),
                    AstryxMenuItem(label: 'JSON', onSelected: () {}),
                  ],
                  triggerBuilder: (context, controller) => AstryxButton(
                    label: 'Format',
                    onPressed: controller.toggle,
                  ),
                ),
                AstryxButton(label: 'Close', onPressed: _layer.hide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
// #end

// #example provider_link -> ProviderLinkExample
class ProviderLinkExample extends StatefulWidget {
  const ProviderLinkExample({super.key});

  @override
  State<ProviderLinkExample> createState() => _ProviderLinkExampleState();
}

class _ProviderLinkExampleState extends State<ProviderLinkExample> {
  Uri? _followed;

  @override
  Widget build(BuildContext context) {
    // The delegate stands in for your router. This one records where a link
    // wanted to go; a real one would call `GoRouter.of(context).go(...)` or
    // `launchUrl`. The package never decides what following means.
    return AstryxLinkScope(
      delegate: AstryxLinkDelegate.fromCallback((uri, {target}) {
        setState(() => _followed = uri);
      }),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxLink('Billing settings', href: Uri.parse('/settings/billing')),
          AstryxLink(
            'Status page',
            href: Uri.parse('https://status.example.com'),
            external: true,
          ),
          AstryxText(
            _followed == null
                ? 'Nothing followed yet'
                : 'The delegate was handed $_followed',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
// #end

/// A few strings, reworded. Subclass and override only what changes.
class FrenchLocalizations extends AstryxLocalizations {
  const FrenchLocalizations();

  @override
  List<String> get monthNames => const <String>[
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];

  @override
  List<String> get weekdayNamesShort => const <String>[
    'lun',
    'mar',
    'mer',
    'jeu',
    'ven',
    'sam',
    'dim',
  ];

  @override
  String get calendarPreviousMonth => 'Mois précédent';

  @override
  String get calendarNextMonth => 'Mois suivant';

  @override
  String get dialogClose => 'Fermer';
}

// #example provider_localizations -> ProviderLocalizationsExample
class ProviderLocalizationsExample extends StatefulWidget {
  const ProviderLocalizationsExample({super.key});

  @override
  State<ProviderLocalizationsExample> createState() =>
      _ProviderLocalizationsExampleState();
}

class _ProviderLocalizationsExampleState
    extends State<ProviderLocalizationsExample> {
  bool _rtl = false;
  DateTime? _day;

  @override
  Widget build(BuildContext context) {
    // Two halves, and they are independent. The strings come from a
    // localisations subclass; the direction comes from `Directionality`, which
    // is Flutter's own and needs nothing from this package.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxSwitch(
          label: 'Right to left',
          value: _rtl,
          onChanged: (value) => setState(() => _rtl = value),
        ),
        AstryxLocalizationsScope(
          localizations: const FrenchLocalizations(),
          child: Directionality(
            textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
            child: AstryxCard(
              child: AstryxCalendar(
                selected: _day,
                today: DateTime(2026, 8, 4),
                onChanged: (day) => setState(() => _day = day),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// #end

// #example provider_syntax -> ProviderSyntaxExample
class ProviderSyntaxExample extends StatelessWidget {
  const ProviderSyntaxExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final palette = theme.syntaxPalette;

    // The palette a theme carries, read back as `Color`s. Nothing in the
    // package paints with them — this is the seam for a highlighter you wire
    // yourself, so its colours come from the theme rather than from a list of
    // hex values beside it.
    if (palette.isEmpty) {
      return const AstryxEmptyState(
        title: 'This theme carries no syntax palette',
        description: 'The prebuilt themes all do.',
      );
    }

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxGrid(
          minWidth: 140,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            for (final entry in palette.entries)
              AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: entry.value,
                      borderRadius: theme.borderRadius(
                        AstryxRadiusToken.inner,
                      ),
                    ),
                  ),
                  Flexible(
                    child: AstryxText(
                      entry.key.key,
                      type: AstryxTextType.supporting,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const AstryxCodeBlock(
          '''
Color? keyword(BuildContext context) =>
    AstryxTheme.of(context).syntaxColor(AstryxSyntaxToken.keyword);''',
          language: 'dart',
        ),
      ],
    );
  }
}
// #end
