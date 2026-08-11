/// An on-this-page table of contents.
library;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One heading in an [AstryxOutline].
@immutable
class AstryxOutlineEntry {
  /// Creates an entry.
  const AstryxOutlineEntry({
    required this.id,
    required this.label,
    this.level = 2,
    this.anchor,
  });

  /// This entry's identity, unique within the outline.
  final String id;

  /// The heading text, as it appears in the outline.
  final String label;

  /// The heading level, which sets the indent.
  ///
  /// The same number `AstryxSection` resolves for its heading — 2 for a
  /// top-level section, 3 for one nested inside it.
  final int level;

  /// A key on the heading this entry points at.
  ///
  /// Both halves of "tracking the reader's position" need it: without an
  /// anchor the outline cannot know where the heading is, and pressing an
  /// entry has nowhere to scroll to. Upstream gets the same thing from the DOM
  /// id it links to.
  final GlobalKey? anchor;
}

/// The headings of a page, in order, with the one being read marked.
///
/// **What it tracks is where the anchors are, not where the scroll offset is.**
/// A scroll position means nothing on its own — a page of short sections and a
/// page of long ones put the same offset in different places — so the active
/// entry is the last one whose heading has passed the top of the viewport.
///
/// {@tool snippet}
/// ```dart
/// AstryxOutline(
///   controller: _scroll,
///   entries: <AstryxOutlineEntry>[
///     AstryxOutlineEntry(id: 'setup', label: 'Setup', anchor: _setupKey),
///     AstryxOutlineEntry(id: 'usage', label: 'Usage', anchor: _usageKey),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxSection`, whose `headerKey` is what an entry's anchor usually is.
///  * `AstryxLayout`, whose `panel` is where an outline usually goes.
class AstryxOutline extends StatefulWidget {
  /// Creates an outline.
  const AstryxOutline({
    required this.entries,
    super.key,
    this.controller,
    this.activeId,
    this.onSelected,
    this.label,
    this.topOffset = 24,
  });

  /// The headings, in the order they appear on the page.
  final List<AstryxOutlineEntry> entries;

  /// The scroll view the anchors live in.
  ///
  /// Given one, the outline tracks the reader by itself. Without one it is a
  /// list of links, and [activeId] is the caller's to set.
  final ScrollController? controller;

  /// Marks an entry active, whatever the scroll position says.
  ///
  /// Set it to drive the outline from outside — from a router, say. It wins
  /// over tracking.
  final String? activeId;

  /// Called with the id of the entry the reader chose.
  ///
  /// Null scrolls to the entry's [AstryxOutlineEntry.anchor] instead, which is
  /// what an outline is normally for.
  final ValueChanged<String>? onSelected;

  /// The outline's accessible name. Defaults to nothing.
  final String? label;

  /// How far below the top of the viewport a heading counts as reached.
  ///
  /// A heading exactly on the edge is a heading the reader has not got to yet;
  /// this is the slack that stops the active entry flickering between two.
  final double topOffset;

  @override
  State<AstryxOutline> createState() => _AstryxOutlineState();
}

class _AstryxOutlineState extends State<AstryxOutline> {
  String? _tracked;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_track);
    // The first frame has no layout to measure yet.
    WidgetsBinding.instance.addPostFrameCallback((_) => _track());
  }

  @override
  void didUpdateWidget(AstryxOutline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_track);
      widget.controller?.addListener(_track);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_track);
    super.dispose();
  }

  String? get _active => widget.activeId ?? _tracked;

  /// The last entry whose heading has passed the top of the viewport.
  void _track() {
    if (!mounted || widget.controller == null) return;

    final own = context.findRenderObject();
    if (own is! RenderBox || !own.hasSize) return;

    String? active;
    for (final entry in widget.entries) {
      final anchorContext = entry.anchor?.currentContext;
      if (anchorContext == null) continue;
      final box = anchorContext.findRenderObject();
      if (box is! RenderBox || !box.hasSize) continue;

      // Against the viewport's own top edge rather than the window's: an
      // outline inside a panel is not measuring the page it is beside.
      final top = box.localToGlobal(Offset.zero).dy;
      if (top <= widget.topOffset) {
        active = entry.id;
      } else {
        break;
      }
    }

    // Before the first heading has been reached, the first entry is still the
    // section the reader is in — nothing above it is part of the outline.
    active ??= widget.entries.isEmpty ? null : widget.entries.first.id;
    if (active != _tracked) setState(() => _tracked = active);
  }

  void _select(AstryxOutlineEntry entry) {
    if (widget.onSelected != null) {
      widget.onSelected!(entry.id);
      return;
    }

    final anchorContext = entry.anchor?.currentContext;
    if (anchorContext == null) return;
    Scrollable.ensureVisible(
      anchorContext,
      duration: AstryxMotion.of(context).duration(AstryxDurationToken.medium),
      curve: AstryxMotion.of(context).curve(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final entry in widget.entries)
            _OutlineRow(
              entry: entry,
              active: entry.id == _active,
              indent:
                  theme.spacing(AstryxSpacingToken.spacing3) *
                  (entry.level - 2).clamp(0, 4),
              onPressed: () => _select(entry),
            ),
        ],
      ),
    );
  }
}

/// One row: a rule, the heading text, and the state of being read.
class _OutlineRow extends StatefulWidget {
  const _OutlineRow({
    required this.entry,
    required this.active,
    required this.indent,
    required this.onPressed,
  });

  final AstryxOutlineEntry entry;
  final bool active;
  final double indent;
  final VoidCallback onPressed;

  @override
  State<_OutlineRow> createState() => _OutlineRowState();
}

class _OutlineRowState extends State<_OutlineRow> {
  bool _hovered = false;
  bool _focused = false;

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.enter && key != LogicalKeyboardKey.space) {
      return KeyEventResult.ignored;
    }
    widget.onPressed();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final hovered = _hovered && AstryxTheme.densityOf(context).supportsHover;

    // The rule down the side is the second signal, so the entry being read is
    // not marked by colour alone.
    final rule = AnimatedContainer(
      duration: motion.duration(AstryxDurationToken.fast),
      curve: motion.curve(),
      width: widget.active ? 2 : theme.borderWidth(),
      decoration: BoxDecoration(
        color: theme.color(
          widget.active ? AstryxColorToken.accent : AstryxColorToken.border,
        ),
        borderRadius: theme.borderRadius(AstryxRadiusToken.full),
      ),
    );

    Widget row = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          rule,
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start:
                    theme.spacing(AstryxSpacingToken.spacing2) + widget.indent,
                top: theme.spacing(AstryxSpacingToken.spacing1_5),
                bottom: theme.spacing(AstryxSpacingToken.spacing1_5),
                end: theme.spacing(AstryxSpacingToken.spacing2),
              ),
              child: AstryxText(
                widget.entry.label,
                type: AstryxTextType.supporting,
                color: widget.active || hovered
                    ? AstryxTextColor.accent
                    : AstryxTextColor.secondary,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );

    row = AstryxFocusRing(
      focused: _focused && AstryxFocusVisible.of(context),
      borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      child: row,
    );

    row = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: row,
      ),
    );

    return Semantics(
      container: true,
      button: true,
      // An outline entry is a link to a place on the page, and the one being
      // read is the one selected — which is what tells a screen-reader user
      // where they are without their having to read back up the page.
      selected: widget.active ? true : null,
      label: widget.entry.label,
      onTap: widget.onPressed,
      child: ExcludeSemantics(
        child: Focus(
          onFocusChange: (value) => setState(() => _focused = value),
          onKeyEvent: _handleKey,
          child: AstryxTapTarget(expandHorizontally: false, child: row),
        ),
      ),
    );
  }
}
