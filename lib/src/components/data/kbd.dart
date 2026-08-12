/// A keyboard key, or a chord of them.
library;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/hotkeys.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How large a key cap is drawn.
enum AstryxKbdSize {
  /// Beside `supporting` text — a hint in a menu row, a footnote.
  sm(AstryxTextSizeToken.xs),

  /// The default, beside `body` text.
  md(AstryxTextSizeToken.sm);

  const AstryxKbdSize(this.textSize);

  /// The size the cap's glyph takes.
  final AstryxTextSizeToken textSize;
}

/// One key, or several pressed together, drawn as key caps.
///
/// {@tool snippet}
/// ```dart
/// AstryxKbd('K')
/// const AstryxKbd.chord(<String>['Ctrl', 'K'])
/// ```
/// {@end-tool}
///
/// **The glyphs are yours.** This does not translate `Ctrl` to `⌘` on a Mac,
/// because only the caller knows whether the shortcut it is describing is the
/// platform's or the product's own — and a key cap that shows the wrong
/// modifier is worse than one that shows a name.
///
/// The exception is [AstryxKbd.hotkey]: an `AstryxHotkey` already knows which
/// modifier it resolved to, so there is nothing left to guess.
class AstryxKbd extends StatelessWidget {
  /// Creates a single key cap.
  AstryxKbd(
    String label, {
    super.key,
    this.size = AstryxKbdSize.md,
    this.semanticsLabel,
  }) : keys = <String>[label],
       hotkey = null;

  /// Creates several caps, pressed together.
  const AstryxKbd.chord(
    this.keys, {
    super.key,
    this.size = AstryxKbdSize.md,
    this.semanticsLabel,
  }) : hotkey = null;

  /// Creates the caps for a bound [AstryxHotkey], resolved for the platform.
  ///
  /// The one case where the glyphs are *not* the caller's: a hotkey knows which
  /// modifier it resolved to, so `AstryxHotkey.mod` draws `⌘K` on a Mac and
  /// `Ctrl+K` elsewhere — and it is drawn from the same object that gets bound,
  /// so the hint and the shortcut cannot drift apart.
  const AstryxKbd.hotkey(
    this.hotkey, {
    super.key,
    this.size = AstryxKbdSize.md,
    this.semanticsLabel,
  }) : keys = const <String>[];

  /// The keys, in the order they are shown.
  ///
  /// Empty for [AstryxKbd.hotkey], which resolves its own at build time.
  final List<String> keys;

  /// The shortcut being described, for [AstryxKbd.hotkey].
  final AstryxHotkey? hotkey;

  /// How large the caps are drawn.
  final AstryxKbdSize size;

  /// What a screen reader announces.
  ///
  /// Defaults to the keys with "then" between them — `⌘ K` read out as a
  /// string of symbols is not a shortcut anyone can follow.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final shortcut = hotkey;

    final caps = shortcut == null
        ? keys
        : shortcut.capsFor(theme.platform);
    // The symbols are drawn and the words are spoken: `⌘ K` read out as a
    // string of symbols is not a shortcut anybody can follow.
    final spoken =
        semanticsLabel ??
        (shortcut == null
            ? keys.join(' ')
            : shortcut.describeFor(theme.platform));

    return Semantics(
      container: true,
      label: spoken,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: theme.spacing(AstryxSpacingToken.spacing1),
          children: <Widget>[
            for (final key in caps) _Cap(label: key, size: size),
          ],
        ),
      ),
    );
  }
}

/// One key cap.
class _Cap extends StatelessWidget {
  const _Cap({required this.label, required this.size});

  final String label;
  final AstryxKbdSize size;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final inset = theme.spacing(AstryxSpacingToken.spacing1);

    return Container(
      // Square until the label is wider than it is tall, so a single letter
      // reads as a key rather than as a very short word.
      constraints: BoxConstraints(minWidth: theme.textSize(size.textSize) * 2),
      padding: EdgeInsets.symmetric(
        horizontal: inset,
        vertical: theme.spacing(AstryxSpacingToken.spacing0_5),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundSurface),
        borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
        border: Border.all(
          color: theme.color(AstryxColorToken.borderEmphasized),
          width: theme.borderWidth(),
        ),
      ),
      child: AstryxText(
        label,
        type: AstryxTextType.code,
        size: size.textSize,
        color: AstryxTextColor.secondary,
      ),
    );
  }
}
