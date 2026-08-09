/// The fourteen semantic type roles of the Astryx type scale.
library;

import 'package:astryx_ui/src/theme/tokens/tokens.dart';

/// A semantic typography role — one row of the type scale.
///
/// The 42 type-scale tokens are fourteen roles × three properties (size, weight
/// and leading). This enum names the roles and derives the three token names
/// from each, so callers ask for a role rather than assembling
/// `--text-heading-1-size` by hand.
///
/// The mapping from role to font family follows upstream's
/// `generateTypeScaleComponents`: headings and display sizes use the heading
/// family, `code` uses the code family, everything else uses the body family.
///
/// {@tool snippet}
/// ```dart
/// final style = theme.textStyle(AstryxTypeRole.body);
/// ```
/// {@end-tool}
enum AstryxTypeRole {
  /// The largest heading.
  heading1('heading-1', AstryxTypographyToken.heading),

  /// A section heading.
  heading2('heading-2', AstryxTypographyToken.heading),

  /// A subsection heading.
  heading3('heading-3', AstryxTypographyToken.heading),

  /// A heading at the base size — the type scale's anchor.
  heading4('heading-4', AstryxTypographyToken.heading),

  /// A small heading.
  heading5('heading-5', AstryxTypographyToken.heading),

  /// The smallest heading.
  heading6('heading-6', AstryxTypographyToken.heading),

  /// Default body copy.
  body('body', AstryxTypographyToken.body),

  /// Body copy one step up, for emphasis.
  large('large', AstryxTypographyToken.body),

  /// Form and control labels.
  label('label', AstryxTypographyToken.body),

  /// Inline and block code.
  code('code', AstryxTypographyToken.code),

  /// Secondary copy — hints, captions, helper text.
  supporting('supporting', AstryxTypographyToken.body),

  /// The largest display size, above every heading.
  display1('display-1', AstryxTypographyToken.heading),

  /// The middle display size.
  display2('display-2', AstryxTypographyToken.heading),

  /// The smallest display size, nearest [heading1].
  display3('display-3', AstryxTypographyToken.heading);

  const AstryxTypeRole(this.cssSegment, this.familyToken);

  /// The role's segment of its token names, such as `heading-1` or `body`.
  final String cssSegment;

  /// The typography token naming this role's font family.
  final AstryxTypographyToken familyToken;

  /// The CSS custom property holding this role's font size.
  String get sizeName => '--text-$cssSegment-size';

  /// The CSS custom property holding this role's font weight.
  String get weightName => '--text-$cssSegment-weight';

  /// The CSS custom property holding this role's line-height ratio.
  String get leadingName => '--text-$cssSegment-leading';

  /// The heading level this role represents, or null if it is not a heading.
  int? get headingLevel => switch (this) {
    heading1 => 1,
    heading2 => 2,
    heading3 => 3,
    heading4 => 4,
    heading5 => 5,
    heading6 => 6,
    _ => null,
  };

  /// The role for heading [level], 1 through 6.
  ///
  /// Throws a [RangeError] outside that range.
  static AstryxTypeRole heading(int level) => switch (level) {
    1 => heading1,
    2 => heading2,
    3 => heading3,
    4 => heading4,
    5 => heading5,
    6 => heading6,
    _ => throw RangeError.range(level, 1, 6, 'level'),
  };
}
