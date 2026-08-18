/// The content frame inside the shell.
library;

import 'package:astryx_ui/src/components/layout/center.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/overlay/collapsible.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
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
    this.panelCollapseBelow = 640,
    this.panelLabel,
    this.panelInitiallyExpanded = false,
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

  /// How wide [panel] is while it sits beside the body.
  final double panelWidth;

  /// The width below which [panel] stops sitting beside the body.
  ///
  /// **Narrower than this, the panel becomes a disclosure banded across the
  /// top (or the bottom, for [AstryxLayoutPanelSide.end]) of the page** — the
  /// same content, collapsed, reachable in one press. A 240px rail beside a
  /// 390px phone leaves 150px for the body, which is not a narrow page but a
  /// broken one.
  ///
  /// The threshold is a number rather than an entry in a breakpoint table, for
  /// the reason `AstryxAppShell.compactBelow` is: the width at which *your*
  /// panel stops fitting is a fact about your panel. Set it to
  /// `double.negativeInfinity` for a panel that must never collapse, and to
  /// [double.infinity] for one that never sits beside the body.
  ///
  /// Ignored while [panel] is null.
  final double panelCollapseBelow;

  /// The disclosure's title once [panel] has collapsed.
  ///
  /// Name it: "Filters", "On this page", "Details". Null falls back to
  /// `AstryxLocalizations.layoutPanelLabel`, which can only be generic.
  final String? panelLabel;

  /// Whether the collapsed [panel] starts open.
  ///
  /// False, because the reason it collapsed is that there was no room — and a
  /// filter rail that opens over the results on a phone hides the thing it
  /// filters.
  final bool panelInitiallyExpanded;

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
      final beside = body;

      body = LayoutBuilder(
        builder: (context, constraints) {
          // Not `MediaQuery`: what matters is the room *this* layout was
          // given, which a shell's sidebar has already taken a bite out of.
          if (constraints.maxWidth >= panelCollapseBelow) {
            final column = <Widget>[
              // The rule sits between the two either way, which is why it is
              // built into the order rather than attached to the panel.
              const AstryxDivider(axis: Axis.vertical),
              SizedBox(
                width: panelWidth,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(inset),
                    child: panel,
                  ),
                ),
              ),
            ];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (panelSide == AstryxLayoutPanelSide.start)
                  ...column.reversed,
                Expanded(child: beside),
                if (panelSide == AstryxLayoutPanelSide.end) ...column,
              ],
            );
          }

          final band = _CollapsedPanel(
            title:
                panelLabel ?? AstryxLocalizations.of(context).layoutPanelLabel,
            initiallyExpanded: panelInitiallyExpanded,
            inset: inset,
            // Half the frame at most. An opened rail that fills the page has
            // pushed the body it belongs to off the bottom of it, and the
            // reader has no way of telling that from a page that ended.
            maxHeight: constraints.hasBoundedHeight
                ? constraints.maxHeight / 2
                : double.infinity,
            child: panel,
          );

          // The body keeps the `Expanded`, so `scrollable: false` bodies — a
          // transcript, a table with its own scroller — still get a bounded
          // height to divide.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (panelSide == AstryxLayoutPanelSide.start) ...<Widget>[
                band,
                const AstryxDivider(),
              ],
              Expanded(child: beside),
              if (panelSide == AstryxLayoutPanelSide.end) ...<Widget>[
                const AstryxDivider(),
                band,
              ],
            ],
          );
        },
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

/// An `AstryxLayout` panel with nowhere to sit beside the body.
///
/// The panel's own content, unchanged, behind one disclosure — rather than a
/// second copy of it written for narrow windows. It scrolls inside [maxHeight]
/// so that opening it never costs the body more than half the page.
class _CollapsedPanel extends StatelessWidget {
  const _CollapsedPanel({
    required this.title,
    required this.child,
    required this.inset,
    required this.maxHeight,
    required this.initiallyExpanded,
  });

  final String title;
  final Widget child;
  final double inset;
  final double maxHeight;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) => AstryxCollapsible(
    title: title,
    initiallyExpanded: initiallyExpanded,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        // Only the sides and the bottom: the collapsible's header has already
        // paid for the space above.
        padding: EdgeInsets.fromLTRB(inset, 0, inset, inset),
        child: child,
      ),
    ),
  );
}
