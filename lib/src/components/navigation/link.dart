/// Inline navigation in running text.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/link_delegate.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// When a link draws its underline.
enum AstryxLinkUnderline {
  /// Always. The default in running text, where colour alone does not tell a
  /// link from an emphasised word — and would be the only signal for a
  /// colour-blind reader.
  always,

  /// On hover and focus only. For a link that is obviously one from its
  /// position: a row in a list, a name in a table cell.
  hover,

  /// Never. For a link inside something that is already visibly interactive.
  never,
}

/// A link: text that goes somewhere.
///
/// Navigation is the application's concern, so a link with an [href] hands it
/// to the [AstryxLinkDelegate] and never decides what following means. A link
/// with an [onPressed] just calls it.
///
/// {@tool snippet}
/// ```dart
/// AstryxLink('Read the guide', onPressed: _open)
/// ```
/// {@end-tool}
///
/// Flutter has no inline element, so a widget cannot sit inside a string. Use
/// [AstryxLink.span] with `Text.rich` to put one *in* a sentence:
///
/// {@tool snippet}
/// ```dart
/// Text.rich(
///   TextSpan(
///     children: <InlineSpan>[
///       const TextSpan(text: 'See the '),
///       AstryxLink.span('installation guide', onPressed: _open),
///       const TextSpan(text: ' to begin.'),
///     ],
///   ),
/// )
/// ```
/// {@end-tool}
class AstryxLink extends StatefulWidget {
  /// Creates a link.
  const AstryxLink(
    this.label, {
    super.key,
    this.onPressed,
    this.href,
    this.external = false,
    this.visited = false,
    this.underline = AstryxLinkUnderline.always,
    this.type = AstryxTextType.body,
    this.enabled = true,
    this.semanticsLabel,
    this.focusNode,
  });

  /// The text.
  final String label;

  /// Called when the link is followed.
  final VoidCallback? onPressed;

  /// A destination for the [AstryxLinkDelegate].
  final Uri? href;

  /// Whether following this leaves the application.
  ///
  /// Draws the external-link glyph after the text **and** says so in the
  /// accessible name, because a user who cannot see the glyph is exactly the
  /// user most disrupted by a new window they did not expect.
  final bool external;

  /// Whether this link has already been followed.
  ///
  /// Yours to track. A browser knows a link's history and Flutter does not, so
  /// there is nothing here to read it from — pass it if your application keeps
  /// the answer, and leave it alone if it does not.
  final bool visited;

  /// When the underline is drawn.
  final AstryxLinkUnderline underline;

  /// The type role the text takes, so a link matches the copy around it.
  final AstryxTextType type;

  /// Whether the link can be followed.
  final bool enabled;

  /// Overrides what a screen reader announces.
  final String? semanticsLabel;

  /// The focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// This link as an inline span, for use inside `Text.rich`.
  static InlineSpan span(
    String label, {
    VoidCallback? onPressed,
    Uri? href,
    bool external = false,
    bool visited = false,
    AstryxLinkUnderline underline = AstryxLinkUnderline.always,
    String? semanticsLabel,
  }) => WidgetSpan(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    child: AstryxLink(
      label,
      onPressed: onPressed,
      href: href,
      external: external,
      visited: visited,
      underline: underline,
      semanticsLabel: semanticsLabel,
    ),
  );

  @override
  State<AstryxLink> createState() => _AstryxLinkState();
}

class _AstryxLinkState extends State<AstryxLink> {
  bool _hovered = false;
  bool _focused = false;

  bool get _followable =>
      widget.enabled && (widget.onPressed != null || widget.href != null);

  void _set(void Function() change) {
    if (!mounted) return;
    setState(change);
  }

  void _follow() {
    if (!_followable) return;
    widget.onPressed?.call();
    final href = widget.href;
    if (href != null) {
      AstryxLinkDelegate.of(context).followLink(
        href,
        target: widget.external ? '_blank' : null,
      );
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || !_followable) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.enter && key != LogicalKeyboardKey.space) {
      return KeyEventResult.ignored;
    }
    _follow();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final hovered = _hovered && AstryxTheme.densityOf(context).supportsHover;

    final underlined = switch (widget.underline) {
      AstryxLinkUnderline.always => true,
      AstryxLinkUnderline.hover => hovered || _focused,
      AstryxLinkUnderline.never => false,
    };

    final color = !widget.enabled
        ? AstryxColorToken.textDisabled
        : widget.visited
        // Upstream's visited colour. Nothing sets it for you.
        ? AstryxColorToken.textPurple
        : AstryxColorToken.textAccent;

    Widget content = AstryxText(
      widget.label,
      type: widget.type,
      color: AstryxTextColor.inherit,
      style: TextStyle(
        color: theme.color(color),
        decoration: underlined ? TextDecoration.underline : null,
        decorationColor: theme.color(color),
      ),
    );

    if (widget.external) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing(AstryxSpacingToken.spacing1),
        children: <Widget>[
          Flexible(child: content),
          // Decoration: the fact that it opens elsewhere is in the name, so a
          // screen reader hears it rather than being read a glyph.
          ExcludeSemantics(
            child: IconTheme.merge(
              data: IconThemeData(color: theme.color(color)),
              child: const AstryxIcon(
                AstryxIconName.externalLink,
                size: AstryxIconSize.xsm,
              ),
            ),
          ),
        ],
      );
    }

    content = AstryxFocusRing(
      focused: _focused && AstryxFocusVisible.of(context),
      borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      child: content,
    );

    if (_followable) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _set(() => _hovered = true),
        onExit: (_) => _set(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _follow,
          child: content,
        ),
      );
    }

    content = Focus(
      focusNode: widget.focusNode,
      canRequestFocus: _followable,
      onFocusChange: (value) => _set(() => _focused = value),
      onKeyEvent: _handleKey,
      child: content,
    );

    final name = widget.semanticsLabel ?? widget.label;

    return Semantics(
      container: true,
      link: true,
      enabled: widget.enabled,
      label: widget.external ? '$name, ${l10n.linkExternal}' : name,
      onTap: _followable ? _follow : null,
      child: ExcludeSemantics(
        // A link in running text must not gain a 44px tap target, which would
        // push the lines around it apart. Only a standalone one does.
        child: widget.type == AstryxTextType.body
            ? content
            : AstryxTapTarget(expandHorizontally: false, child: content),
      ),
    );
  }
}
