import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example styling_scopes -> StylingScopesExample
class StylingScopesExample extends StatelessWidget {
  const StylingScopesExample({super.key});

  /// Square corners and a heavier label, as a component theme.
  ///
  /// Every field is nullable, and null means "fall through to the token
  /// default" — so this changes two things and inherits the rest.
  static const AstryxButtonTheme _squared = AstryxButtonTheme(
    borderRadius: BorderRadius.zero,
  );

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 210,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        _Scope(
          title: 'the theme',
          note: 'Nothing overridden.',
          child: AstryxButton(
            label: 'Save',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ),
        _Scope(
          title: 'one button',
          note: '`theme:` on the widget.',
          child: AstryxButton(
            label: 'Save',
            variant: AstryxButtonVariant.primary,
            theme: _squared,
            onPressed: () {},
          ),
        ),
        // Everything below inherits it — including a button three widgets deep
        // that knows nothing about this.
        AstryxTheme(
          data: AstryxTheme.of(context).copyWith(button: _squared),
          density: AstryxTheme.densityOf(context),
          icons: AstryxTheme.iconsOf(context),
          child: _Scope(
            title: 'a subtree',
            note: '`AstryxTheme` with `copyWith`.',
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxButton(
                  label: 'Save',
                  variant: AstryxButtonVariant.primary,
                  onPressed: () {},
                ),
                AstryxButton(label: 'Cancel', onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Scope extends StatelessWidget {
  const _Scope({required this.title, required this.note, required this.child});

  final String title;
  final String note;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(title, type: AstryxTextType.label),
          child,
          AstryxText(
            note,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
// #end
