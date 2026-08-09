import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// A titled block inside a demo page.
///
/// Deliberately built from Astryx primitives rather than Material: the gallery
/// is the first consumer of this package, and chrome built from the widgets
/// under test is the cheapest way to notice when one of them is awkward.
class DemoSection extends StatelessWidget {
  const DemoSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => AstryxVStack(
    gap: AstryxSpacingToken.spacing2,
    align: AstryxStackAlign.stretch,
    children: <Widget>[
      AstryxHeading(title, level: 5),
      child,
      const AstryxDivider(),
    ],
  );
}

/// Wraps a demo page in scrolling and padding.
class DemoPage extends StatelessWidget {
  const DemoPage({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    return ColoredBox(
      color: theme.color(AstryxColorToken.backgroundBody),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing6)),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing6,
          align: AstryxStackAlign.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// `AstryxText` — every type, colour and weight.
abstract final class TextDemo {
  static Widget build(BuildContext context) => const DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Types',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          children: <Widget>[
            AstryxText('body — the default'),
            AstryxText('large', type: AstryxTextType.large),
            AstryxText('label', type: AstryxTextType.label),
            AstryxText('supporting', type: AstryxTextType.supporting),
            AstryxText('code_sample()', type: AstryxTextType.code),
            AstryxText('display-3', type: AstryxTextType.display3),
            AstryxText('display-2', type: AstryxTextType.display2),
            AstryxText('display-1', type: AstryxTextType.display1),
          ],
        ),
      ),
      DemoSection(
        title: 'Colours',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          children: <Widget>[
            AstryxText('primary'),
            AstryxText('secondary', color: AstryxTextColor.secondary),
            AstryxText('disabled', color: AstryxTextColor.disabled),
            AstryxText('accent', color: AstryxTextColor.accent),
          ],
        ),
      ),
      DemoSection(
        title: 'Weights',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
          children: <Widget>[
            AstryxText('normal', weight: AstryxTextWeight.normal),
            AstryxText('medium', weight: AstryxTextWeight.medium),
            AstryxText('semibold', weight: AstryxTextWeight.semibold),
            AstryxText('bold', weight: AstryxTextWeight.bold),
          ],
        ),
      ),
      DemoSection(
        title: 'Truncation and decoration',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxText(
              'A single line that will be cut off with an ellipsis once it '
              'runs past the width available to it in this column.',
              maxLines: 1,
            ),
            AstryxText('struck through', strikethrough: true),
            AstryxText('1,234,567 tabular', tabularNumbers: true),
          ],
        ),
      ),
    ],
  );
}

/// `AstryxHeading` — all six levels, plus the display sizes.
abstract final class HeadingDemo {
  static Widget build(BuildContext context) => const DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Levels',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxHeading('Heading 1 — 24px', level: 1),
            AstryxHeading('Heading 2 — 20px'),
            AstryxHeading('Heading 3 — 17px', level: 3),
            AstryxHeading('Heading 4 — 14px, the anchor', level: 4),
            AstryxHeading('Heading 5 — 12px', level: 5),
            AstryxHeading('Heading 6 — 10px', level: 6),
          ],
        ),
      ),
      DemoSection(
        title: 'Display sizes, still an h1',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxHeading(
              'Display 3',
              level: 1,
              type: AstryxHeadingType.display3,
            ),
            AstryxHeading(
              'Display 1',
              level: 1,
              type: AstryxHeadingType.display1,
            ),
          ],
        ),
      ),
    ],
  );
}

/// `AstryxHStack` and `AstryxVStack`.
abstract final class StackDemo {
  static Widget build(BuildContext context) => const DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Gap, from the spacing scale',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            _GapRow(gap: AstryxSpacingToken.spacing1, label: 'spacing1 — 4px'),
            _GapRow(gap: AstryxSpacingToken.spacing2, label: 'spacing2 — 8px'),
            _GapRow(gap: AstryxSpacingToken.spacing4, label: 'spacing4 — 16px'),
          ],
        ),
      ),
      DemoSection(
        title: 'Wrapping',
        child: AstryxHStack(
          wrap: true,
          gap: AstryxSpacingToken.spacing2,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            _Swatch(label: 'one'),
            _Swatch(label: 'two'),
            _Swatch(label: 'three'),
            _Swatch(label: 'four'),
            _Swatch(label: 'five'),
            _Swatch(label: 'six'),
            _Swatch(label: 'seven'),
            _Swatch(label: 'eight'),
          ],
        ),
      ),
    ],
  );
}

/// `AstryxGrid`.
abstract final class GridDemo {
  static Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Fixed columns',
        child: AstryxGrid(
          columns: 3,
          gap: AstryxSpacingToken.spacing2,
          children: List<Widget>.generate(
            7,
            (i) => _Swatch(label: 'Cell ${i + 1}'),
          ),
        ),
      ),
      DemoSection(
        title: 'Responsive — as many 160px columns as fit',
        child: AstryxGrid(
          minWidth: 160,
          gap: AstryxSpacingToken.spacing2,
          children: List<Widget>.generate(
            6,
            (i) => _Swatch(label: 'Card ${i + 1}'),
          ),
        ),
      ),
    ],
  );
}

/// `AstryxCenter` and `AstryxDivider`.
abstract final class CenterDividerDemo {
  static Widget build(BuildContext context) => const DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Centre',
        child: AstryxCenter(
          minHeight: 120,
          padding: AstryxSpacingToken.spacing4,
          child: AstryxText('Centred in a 120px-tall box'),
        ),
      ),
      DemoSection(
        title: 'Dividers',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing4,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxDivider(),
            AstryxDivider(variant: AstryxDividerVariant.strong),
            AstryxDivider(label: 'Labelled'),
          ],
        ),
      ),
    ],
  );
}

/// `AstryxIcon` — every semantic name, size and colour.
abstract final class IconDemo {
  static Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      const DemoSection(
        title: 'Sizes',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxIcon(AstryxIconName.check, size: AstryxIconSize.xsm),
            AstryxIcon(AstryxIconName.check, size: AstryxIconSize.sm),
            AstryxIcon(AstryxIconName.check),
            AstryxIcon(AstryxIconName.check, size: AstryxIconSize.lg),
          ],
        ),
      ),
      const DemoSection(
        title: 'Colours',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxIcon(AstryxIconName.info),
            AstryxIcon(AstryxIconName.info, color: AstryxIconColor.secondary),
            AstryxIcon(AstryxIconName.info, color: AstryxIconColor.disabled),
            AstryxIcon(AstryxIconName.info, color: AstryxIconColor.accent),
            AstryxIcon(AstryxIconName.success, color: AstryxIconColor.success),
            AstryxIcon(AstryxIconName.warning, color: AstryxIconColor.warning),
            AstryxIcon(AstryxIconName.error, color: AstryxIconColor.error),
          ],
        ),
      ),
      DemoSection(
        title:
            'Every semantic name — directional ones mirror when the '
            'direction picker is set to RTL',
        child: AstryxHStack(
          wrap: true,
          gap: AstryxSpacingToken.spacing4,
          runGap: AstryxSpacingToken.spacing4,
          children: <Widget>[
            for (final name in AstryxIconName.values)
              AstryxVStack(
                gap: AstryxSpacingToken.spacing1,
                align: AstryxStackAlign.center,
                children: <Widget>[
                  AstryxIcon(name),
                  AstryxText(
                    name.name,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
          ],
        ),
      ),
    ],
  );
}

class _GapRow extends StatelessWidget {
  const _GapRow({required this.gap, required this.label});

  final AstryxSpacingToken gap;
  final String label;

  @override
  Widget build(BuildContext context) => AstryxVStack(
    gap: AstryxSpacingToken.spacing1,
    align: AstryxStackAlign.stretch,
    children: <Widget>[
      AstryxText(
        label,
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
      ),
      AstryxHStack(
        gap: gap,
        children: const <Widget>[
          _Swatch(label: 'a'),
          _Swatch(label: 'b'),
          _Swatch(label: 'c'),
        ],
      ),
    ],
  );
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        borderRadius: theme.borderRadius(AstryxRadiusToken.element),
        border: Border.all(
          color: theme.color(AstryxColorToken.border),
          width: theme.borderWidth(),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing(AstryxSpacingToken.spacing3),
          vertical: theme.spacing(AstryxSpacingToken.spacing2),
        ),
        child: AstryxText(label, type: AstryxTextType.supporting),
      ),
    );
  }
}
