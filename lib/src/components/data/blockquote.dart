/// A quotation, set apart from the prose around it.
library;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A quotation with a rule down its reading-start edge.
///
/// For someone else's words: a customer's complaint in a case study, a line
/// from a spec, the sentence an incident report turns on. Not for emphasis —
/// a paragraph of your own set in a quote is a paragraph pretending to have a
/// source. For a message the page is making, use `AstryxBanner`.
///
/// {@tool snippet}
/// ```dart
/// const AstryxBlockquote(
///   'The deploy took eleven minutes and nobody could tell why.',
///   attribution: 'Postmortem, 3 March',
/// )
/// ```
/// {@end-tool}
class AstryxBlockquote extends StatelessWidget {
  /// Creates a blockquote.
  const AstryxBlockquote(
    this.quote, {
    super.key,
    this.attribution,
    this.child,
  });

  /// The quoted text.
  ///
  /// Empty when [child] carries the quotation instead.
  final String quote;

  /// Who or what is being quoted, shown under it.
  ///
  /// Rendered as given, so it can be a name, a date, a case number — the
  /// em dash is the widget's, not yours.
  final String? attribution;

  /// Replaces [quote] with arbitrary content — a list, a table, code.
  ///
  /// A long quotation is not always one paragraph of plain text, and a
  /// blockquote that cannot hold the rest is one people work around.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // The rule runs the full height of the quotation, however tall it
          // turns out to be — which is what `IntrinsicHeight` is paying for.
          Container(
            width: theme.spacing(AstryxSpacingToken.spacing0_5),
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.borderEmphasized),
              borderRadius: theme.borderRadius(AstryxRadiusToken.full),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: theme.spacing(AstryxSpacingToken.spacing3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing(AstryxSpacingToken.spacing1),
                children: <Widget>[
                  child ?? AstryxText(quote, color: AstryxTextColor.secondary),
                  if (attribution != null)
                    AstryxText(
                      '— $attribution',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
