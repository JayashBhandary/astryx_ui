import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example core_pipeline -> CorePipelineExample
/// A definition: one seed accent, and one token set by hand.
final AstryxDefinedTheme _demoTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'engine-demo',
    color: AstryxColorScaleConfig(accent: '#B3261E'),
    tokens: <String, AstryxTokenValue>{
      '--radius-element': AstryxTokenValue('2px'),
    },
  ),
);

/// The engine's output: every token, concrete, in both modes.
///
/// Resolved once, at the top level — not per build. A theme is read far more
/// often than it changes.
final AstryxResolvedTokenSet _resolved = AstryxResolvedTokenSet.resolve(
  _demoTheme,
);

class CorePipelineExample extends StatelessWidget {
  const CorePipelineExample({super.key});

  static const List<AstryxToken> _shown = <AstryxToken>[
    // Generated from the seed.
    AstryxColorToken.accent,
    // Emitted as `var(--color-accent)`, followed by the resolver.
    AstryxColorToken.textAccent,
    // A `light-dark()` pair: one token, two halves.
    AstryxColorToken.backgroundCard,
    // Overridden by hand, beating the generated value.
    AstryxRadiusToken.element,
    // Untouched by the definition, so the token default stands.
    AstryxDurationToken.fast,
  ];

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const _Row(cells: <String>['token', 'light', 'dark'], header: true),
        for (final token in _shown)
          _Row(
            cells: <String>[
              token.cssName,
              _resolved.value(token, AstryxThemeMode.light),
              _resolved.value(token, AstryxThemeMode.dark),
            ],
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.cells, this.header = false});

  final List<String> cells;
  final bool header;

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      mainAxisSize: MainAxisSize.max,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (index, cell) in cells.indexed)
          Expanded(
            flex: index == 0 ? 2 : 1,
            child: AstryxText(
              cell,
              type: header ? AstryxTextType.label : AstryxTextType.code,
              color: header
                  ? AstryxTextColor.primary
                  : AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ),
      ],
    );
  }
}
// #end
