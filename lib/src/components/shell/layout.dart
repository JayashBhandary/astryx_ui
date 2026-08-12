/// The content frame inside the shell.
library;

import 'package:astryx_ui/src/components/layout/center.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Which edge a layout's panel sits against.
enum AstryxLayoutPanelSide {
  /// The reading-start edge — a filter rail, a table of contents.
  start,

  /// The reading-end edge. The default: a details panel about whatever is
  /// selected in the body.
  end,
}

/// A page: a pinned header, a scrolling body, an optional panel and footer.
///
/// **The header and the footer do not scroll; the body does.** That is the
/// whole of it, and the reason it is a widget rather than a `Column`: a page
/// title that scrolls away takes the user's place in the hierarchy with it, and
/// a Save button that scrolls away is a Save button people cannot find.
///
/// {@tool snippet}
/// ```dart
/// AstryxLayout(
///   header: const AstryxHeading('Deploys', level: 1),
///   footer: AstryxButton(label: 'Save', onPressed: save),
///   panel: const DeployDetails(),
///   child: const DeployTable(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxAppShell`, the frame *around* this one — the application's own
///    header and navigation.
///  * `AstryxCenter`, which is what [maxContentWidth] uses: a page with no
///    measure is a page whose paragraphs run the width of a monitor.
class AstryxLayout extends StatelessWidget {
  /// Creates a page layout.
  const AstryxLayout({
    required this.child,
    super.key,
    this.header,
    this.footer,
    this.panel,
    this.panelSide = AstryxLayoutPanelSide.end,
    this.panelWidth = 320,
    this.scrollable = true,
    this.scrollController,
    this.padding = AstryxSpacingToken.spacing6,
    this.maxContentWidth,
  }) : assert(
         scrollController == null || scrollable,
         'A scrollController is meaningless with scrollable: false — the body '
         'owns its own scroll view there, so give the controller to that.',
       );

  /// The body, which is what scrolls.
  final Widget child;

  /// The band above the body — a title, a breadcrumb trail, tabs.
  ///
  /// Stays put while the body scrolls, with a rule under it. That rule is what
  /// makes a pinned header read as pinned rather than as content that happens
  /// to be at the top.
  final Widget? header;

  /// The band below the body — the actions a form is submitted with.
  final Widget? footer;

  /// A column beside the body — details, filters, an outline.
  ///
  /// It scrolls on its own, because a panel tied to the body's scroll position
  /// is a panel that disappears while you are reading it.
  final Widget? panel;

  /// Which edge [panel] sits against.
  final AstryxLayoutPanelSide panelSide;

  /// How wide [panel] is.
  final double panelWidth;

  /// Whether the body scrolls.
  ///
  /// False for a body that manages its own scrolling — a table with a pinned
  /// header row, a chat transcript that stays at the bottom. Two scroll views
  /// inside one another is one too many.
  final bool scrollable;

  /// The body's scroll controller.
  ///
  /// Needed by anything that has to know where the body has got to — an
  /// `AstryxOutline` in [panel] tracking the reader's position cannot do it
  /// without one, and the body's scroll view belongs to this widget.
  ///
  /// Only legal while [scrollable] is true.
  final ScrollController? scrollController;

  /// The inset around the body, the header and the footer.
  final AstryxSpacingToken padding;

  /// A measure for the body.
  ///
  /// Null lets it fill. Set it for a page of prose or a single form; leave it
  /// null for a table, which has its own reasons to be wide.
  final double? maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final inset = theme.spacing(padding);
    final bandInset = theme.spacing(AstryxSpacingToken.spacing3);

    Widget body = Padding(padding: EdgeInsets.all(inset), child: child);

    if (maxContentWidth != null) {
      body = AstryxCenter(
        axis: AstryxCenterAxis.horizontal,
        maxWidth: maxContentWidth,
        child: body,
      );
    }

    if (scrollable) {
      body = SingleChildScrollView(controller: scrollController, child: body);
    }

    final panel = this.panel;
    if (panel != null) {
      final column = <Widget>[
        // The rule sits between the two either way, which is why it is built
        // into the order rather than attached to the panel.
        const AstryxDivider(axis: Axis.vertical),
        SizedBox(
          width: panelWidth,
          child: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.all(inset), child: panel),
          ),
        ),
      ];

      body = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (panelSide == AstryxLayoutPanelSide.start) ...column.reversed,
          Expanded(child: body),
          if (panelSide == AstryxLayoutPanelSide.end) ...column,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (header != null) ...<Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: inset,
              vertical: bandInset,
            ),
            child: header,
          ),
          const AstryxDivider(),
        ],
        Expanded(child: body),
        if (footer != null) ...<Widget>[
          const AstryxDivider(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: inset,
              vertical: bandInset,
            ),
            child: footer,
          ),
        ],
      ],
    );
  }
}
