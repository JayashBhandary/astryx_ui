/// The nine categorical colour families, plus the sentiment families.
library;

import 'package:astryx_ui/src/theme/tokens/tokens.dart';

/// One of upstream's nine categorical colour families.
///
/// These are the palettes upstream did the most colour work on: **every one of
/// the nine passes WCAG AA in both modes**, on its own tinted background. They
/// are reproduced exactly and must not be adjusted — a "nicer" blue here is a
/// contrast failure somewhere.
///
/// Each family has four tokens, and this enum carries all four so a widget can
/// pick the one it needs rather than four parallel switch statements.
enum AstryxPalette {
  /// `--color-*-blue`.
  blue(
    AstryxColorToken.backgroundBlue,
    AstryxColorToken.borderBlue,
    AstryxColorToken.textBlue,
    AstryxColorToken.iconBlue,
  ),

  /// `--color-*-cyan`.
  cyan(
    AstryxColorToken.backgroundCyan,
    AstryxColorToken.borderCyan,
    AstryxColorToken.textCyan,
    AstryxColorToken.iconCyan,
  ),

  /// `--color-*-gray`.
  gray(
    AstryxColorToken.backgroundGray,
    AstryxColorToken.borderGray,
    AstryxColorToken.textGray,
    AstryxColorToken.iconGray,
  ),

  /// `--color-*-green`.
  green(
    AstryxColorToken.backgroundGreen,
    AstryxColorToken.borderGreen,
    AstryxColorToken.textGreen,
    AstryxColorToken.iconGreen,
  ),

  /// `--color-*-orange`.
  orange(
    AstryxColorToken.backgroundOrange,
    AstryxColorToken.borderOrange,
    AstryxColorToken.textOrange,
    AstryxColorToken.iconOrange,
  ),

  /// `--color-*-pink`.
  pink(
    AstryxColorToken.backgroundPink,
    AstryxColorToken.borderPink,
    AstryxColorToken.textPink,
    AstryxColorToken.iconPink,
  ),

  /// `--color-*-purple`.
  purple(
    AstryxColorToken.backgroundPurple,
    AstryxColorToken.borderPurple,
    AstryxColorToken.textPurple,
    AstryxColorToken.iconPurple,
  ),

  /// `--color-*-red`.
  ///
  /// Categorical, not semantic. For "this row belongs to the Red team", not
  /// for an error — use the error tokens for that, because a colour-blind user
  /// distinguishes them by position and icon, not by hue.
  red(
    AstryxColorToken.backgroundRed,
    AstryxColorToken.borderRed,
    AstryxColorToken.textRed,
    AstryxColorToken.iconRed,
  ),

  /// `--color-*-teal`.
  teal(
    AstryxColorToken.backgroundTeal,
    AstryxColorToken.borderTeal,
    AstryxColorToken.textTeal,
    AstryxColorToken.iconTeal,
  ),

  /// `--color-*-yellow`.
  yellow(
    AstryxColorToken.backgroundYellow,
    AstryxColorToken.borderYellow,
    AstryxColorToken.textYellow,
    AstryxColorToken.iconYellow,
  );

  const AstryxPalette(this.background, this.border, this.text, this.icon);

  /// The tinted fill.
  final AstryxColorToken background;

  /// The border that goes with the fill.
  final AstryxColorToken border;

  /// Text that reads on the fill.
  final AstryxColorToken text;

  /// An icon that reads on the fill.
  final AstryxColorToken icon;
}
