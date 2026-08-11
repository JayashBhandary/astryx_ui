/// Several collapsibles as one section.
library;

import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/overlay/collapsible.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A stack of [AstryxCollapsible]s that read as one section.
///
/// Two behaviours, and the second is the reason the widget exists:
///
///  * **Rules between them**, so the sections look like a list rather than a
///    pile of unrelated headers.
///  * **[exclusive]**, which makes it an accordion: opening one closes the
///    rest. The group owns which one is open; the children stop owning it.
///
/// {@tool snippet}
/// ```dart
/// AstryxCollapsibleGroup(
///   exclusive: true,
///   initialIndex: 0,
///   children: <AstryxCollapsible>[
///     AstryxCollapsible(title: 'Billing', child: BillingPanel()),
///     AstryxCollapsible(title: 'Members', child: MembersPanel()),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// Exclusive is the wrong default and is not the default here. It saves space
/// by taking away the one thing a set of sections is for — comparing two of
/// them — so use it where the panels are long enough that having two open is
/// worse than switching between them.
class AstryxCollapsibleGroup extends StatefulWidget {
  /// Creates a collapsible group.
  const AstryxCollapsibleGroup({
    required this.children,
    super.key,
    this.exclusive = false,
    this.initialIndex,
    this.divided = true,
    this.onChanged,
  });

  /// The sections, in order.
  final List<AstryxCollapsible> children;

  /// Whether opening one section closes the others.
  final bool exclusive;

  /// Which section starts open when [exclusive]. Null starts with none open.
  ///
  /// Ignored otherwise: a non-exclusive group does not own the state, so each
  /// child's own `initiallyExpanded` answers instead.
  final int? initialIndex;

  /// Whether to draw a rule between sections.
  final bool divided;

  /// Called with the index now open, or null when the group closes.
  ///
  /// Only fires for an [exclusive] group, which is the only kind that has a
  /// group-level answer to report.
  final ValueChanged<int?>? onChanged;

  @override
  State<AstryxCollapsibleGroup> createState() => _AstryxCollapsibleGroupState();
}

class _AstryxCollapsibleGroupState extends State<AstryxCollapsibleGroup> {
  late int? _open = widget.initialIndex;

  @override
  void didUpdateWidget(AstryxCollapsibleGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A shorter list must not leave the group pointing at a section that is no
    // longer there.
    final open = _open;
    if (open != null && open >= widget.children.length) _open = null;
  }

  void _toggle(int index, {required bool expand}) {
    setState(() => _open = expand ? index : null);
    widget.onChanged?.call(_open);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final rows = <Widget>[];
    for (var index = 0; index < widget.children.length; index++) {
      if (index > 0 && widget.divided) {
        rows.add(
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: theme.spacing(AstryxSpacingToken.spacing1),
            ),
            child: const AstryxDivider(),
          ),
        );
      }
      rows.add(
        AstryxCollapsibleGroupScope(
          exclusive: widget.exclusive,
          expanded: widget.exclusive && _open == index,
          onToggle: ({required expand}) => _toggle(index, expand: expand),
          child: widget.children[index],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}
