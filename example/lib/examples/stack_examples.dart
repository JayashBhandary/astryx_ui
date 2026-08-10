import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// A visible block, so a stack's spacing and alignment can be seen.
class _Box extends StatelessWidget {
  const _Box(this.label, {this.height = 32});

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
        border: Border.all(color: theme.color(AstryxColorToken.border)),
      ),
      child: SizedBox(
        height: height,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing(AstryxSpacingToken.spacing3),
          ),
          child: Center(
            child: AstryxText(label, type: AstryxTextType.supporting),
          ),
        ),
      ),
    );
  }
}

// #example stack_demo -> StackDemoExample
class StackDemoExample extends StatelessWidget {
  const StackDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const AstryxHeading('Invite teammates', level: 4),
        const AstryxText(
          'They will get an email with a link that expires in seven days.',
          color: AstryxTextColor.secondary,
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AstryxButton(label: 'Cancel', onPressed: () {}),
            AstryxButton(
              label: 'Send invites',
              variant: AstryxButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
// #end

// #example stack_justify -> StackJustifyExample
class StackJustifyExample extends StatelessWidget {
  const StackJustifyExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `justify` only bites when the stack has room to distribute, which is why
    // each row asks for `MainAxisSize.max`.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final justify in AstryxStackJustify.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(justify.name, type: AstryxTextType.label),
              AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                justify: justify,
                mainAxisSize: MainAxisSize.max,
                children: const <Widget>[
                  _Box('one'),
                  _Box('two'),
                  _Box('three'),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example stack_align -> StackAlignExample
class StackAlignExample extends StatelessWidget {
  const StackAlignExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final align in AstryxStackAlign.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(align.name, type: AstryxTextType.label),
              SizedBox(
                height: 72,
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  align: align,
                  children: const <Widget>[
                    _Box('24', height: 24),
                    _Box('40', height: 40),
                    _Box('56', height: 56),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example stack_wrap -> StackWrapExample
class StackWrapExample extends StatelessWidget {
  const StackWrapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 280,
      child: AstryxHStack(
        wrap: true,
        gap: AstryxSpacingToken.spacing2,
        runGap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxBadge('flutter'),
          AstryxBadge('design-system'),
          AstryxBadge('tokens'),
          AstryxBadge('accessibility'),
          AstryxBadge('theming'),
          AstryxBadge('rtl'),
        ],
      ),
    );
  }
}
// #end

// #example stack_nested -> StackNestedExample
class StackNestedExample extends StatelessWidget {
  const StackNestedExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The everyday shape: a row that spreads, holding a column that does not.
    return AstryxCard(
      maxWidth: 420,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing4,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // `Flexible`, because a spreading row hands its children their
          // natural width — and two lines of copy will happily exceed a card.
          const Flexible(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing0_5,
              children: <Widget>[
                AstryxText('Two-factor authentication'),
                AstryxText(
                  'Required for every admin',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
          AstryxButton(
            label: 'Manage',
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
// #end
