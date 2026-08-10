import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example text_demo -> TextDemoExample
class TextDemoExample extends StatelessWidget {
  const TextDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxText('Requests are up 12% this week.'),
        AstryxText(
          'Compared with the seven days before.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example text_types -> TextTypesExample
class TextTypesExample extends StatelessWidget {
  const TextTypesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxText('display1', type: AstryxTextType.display1),
        AstryxText('display2', type: AstryxTextType.display2),
        AstryxText('display3', type: AstryxTextType.display3),
        AstryxText('large', type: AstryxTextType.large),
        AstryxText('body — the default'),
        AstryxText('label', type: AstryxTextType.label),
        AstryxText('supporting', type: AstryxTextType.supporting),
        AstryxText('code_sample()', type: AstryxTextType.code),
      ],
    );
  }
}
// #end

// #example text_colors -> TextColorsExample
class TextColorsExample extends StatelessWidget {
  const TextColorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxText('primary'),
        AstryxText('secondary', color: AstryxTextColor.secondary),
        AstryxText('placeholder', color: AstryxTextColor.placeholder),
        AstryxText('disabled', color: AstryxTextColor.disabled),
        AstryxText('accent', color: AstryxTextColor.accent),
      ],
    );
  }
}
// #end

// #example text_weights -> TextWeightsExample
class TextWeightsExample extends StatelessWidget {
  const TextWeightsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      wrap: true,
      children: <Widget>[
        AstryxText('normal', weight: AstryxTextWeight.normal),
        AstryxText('medium', weight: AstryxTextWeight.medium),
        AstryxText('semibold', weight: AstryxTextWeight.semibold),
        AstryxText('bold', weight: AstryxTextWeight.bold),
      ],
    );
  }
}
// #end

// #example text_truncation -> TextTruncationExample
class TextTruncationExample extends StatelessWidget {
  const TextTruncationExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `truncateTooltip` shows the full string on hover — but only when the
    // text is genuinely cut off, so a tooltip never repeats what is already
    // legible. A screen reader always gets the whole string.
    return const SizedBox(
      width: 240,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(
            'analytics-pipeline-eu-west-1.internal.example.com',
            maxLines: 1,
            truncateTooltip: true,
          ),
          AstryxText(
            'A description long enough to need two lines and then some more, '
            'which is where the ellipsis lands.',
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
// #end

// #example text_numbers -> TextNumbersExample
class TextNumbersExample extends StatelessWidget {
  const TextNumbersExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Tabular figures line the digits up, so a column of numbers is
    // comparable at a glance.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.start,
      children: <Widget>[
        AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          align: AstryxStackAlign.end,
          children: <Widget>[
            AstryxText('Proportional', type: AstryxTextType.label),
            AstryxText('1,118'),
            AstryxText('92,300'),
            AstryxText('4,201'),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          align: AstryxStackAlign.end,
          children: <Widget>[
            AstryxText('tabularNumbers', type: AstryxTextType.label),
            AstryxText('1,118', tabularNumbers: true),
            AstryxText('92,300', tabularNumbers: true),
            AstryxText('4,201', tabularNumbers: true),
          ],
        ),
      ],
    );
  }
}
// #end

// #example text_semantics -> TextSemanticsExample
class TextSemanticsExample extends StatelessWidget {
  const TextSemanticsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // What is read aloud need not be what is painted. `$1.2M` is a glyph
    // salad to a screen reader; the label says it in words.
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxText(
          r'$1.2M',
          type: AstryxTextType.display3,
          semanticsLabel: '1.2 million dollars',
        ),
        AstryxText(
          'Annual recurring revenue',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end
