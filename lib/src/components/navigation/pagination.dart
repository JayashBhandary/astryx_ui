/// Page-at-a-time controls.
library;

import 'package:astryx_ui/src/components/action/button.dart';
import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The controls for a list or table shown a page at a time.
///
/// Pages are **one-based**, as they are to the person reading them: "page 1 of
/// 20" is what the control says, so it is what the control counts in. An
/// off-by-one here is an off-by-one the user sees.
///
/// {@tool snippet}
/// ```dart
/// AstryxPagination(
///   page: _page,
///   pageCount: (_total / _pageSize).ceil(),
///   onPageChanged: (page) => setState(() => _page = page),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxTable`, which does not virtualise — this is how a long one is
///    made readable.
class AstryxPagination extends StatelessWidget {
  /// Creates pagination controls.
  const AstryxPagination({
    required this.page,
    required this.pageCount,
    super.key,
    this.onPageChanged,
    this.siblings = 1,
    this.showEdges = true,
    this.label,
  });

  /// The current page, from 1 to [pageCount].
  final int page;

  /// How many pages there are.
  final int pageCount;

  /// Called with the page the user chose. Null makes the control read-only.
  final ValueChanged<int>? onPageChanged;

  /// How many page numbers to show on each side of the current one.
  final int siblings;

  /// Whether the first and last pages are always shown.
  ///
  /// They are the two a reader jumps to most, and the two that tell them how
  /// much there is — a trail of numbers with no end in sight says less than
  /// "… 20".
  final bool showEdges;

  /// The control's accessible name.
  final String? label;

  /// The page numbers to draw, with nulls where a gap goes.
  ///
  /// Static and pure, so the arithmetic that decides what a reader sees can be
  /// read — and tested — without a widget tree.
  static List<int?> pagesFor({
    required int page,
    required int pageCount,
    int siblings = 1,
    bool showEdges = true,
  }) {
    if (pageCount <= 0) return const <int?>[];

    final wanted = <int>{
      if (showEdges) 1,
      if (showEdges) pageCount,
      for (var i = page - siblings; i <= page + siblings; i++) i,
    }.where((p) => p >= 1 && p <= pageCount).toList()..sort();

    final out = <int?>[];
    for (var i = 0; i < wanted.length; i++) {
      // A gap of exactly one page is drawn as the page: "1 … 3" hides nothing
      // and costs a press.
      if (i > 0 && wanted[i] - wanted[i - 1] > 1) out.add(null);
      out.add(wanted[i]);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    if (pageCount <= 1) return const SizedBox.shrink();

    final interactive = onPageChanged != null;
    final pages = pagesFor(
      page: page,
      pageCount: pageCount,
      siblings: siblings,
      showEdges: showEdges,
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label ?? l10n.paginationLabel,
      // The whole control announces where the reader is, so a screen-reader
      // user who lands on it is told "Page 3 of 20" before they hear a single
      // number.
      value: l10n.paginationPage(page, pageCount),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing(AstryxSpacingToken.spacing1),
        children: <Widget>[
          AstryxIconButton(
            icon: AstryxIconName.chevronLeft,
            label: l10n.paginationPrevious,
            tooltip: l10n.paginationPrevious,
            size: AstryxButtonSize.sm,
            variant: AstryxButtonVariant.ghost,
            // Disabled at the ends rather than hidden: a control that vanishes
            // moves everything beside it, and the reader loses their place in
            // a row they were about to press again.
            enabled: interactive && page > 1,
            onPressed: () => onPageChanged!(page - 1),
          ),
          for (final entry in pages)
            if (entry == null)
              const _Gap()
            else
              AstryxButton(
                label: '$entry',
                size: AstryxButtonSize.sm,
                variant: entry == page
                    ? AstryxButtonVariant.secondary
                    : AstryxButtonVariant.ghost,
                enabled: interactive,
                onPressed: () => onPageChanged!(entry),
              ),
          AstryxIconButton(
            icon: AstryxIconName.chevronRight,
            label: l10n.paginationNext,
            tooltip: l10n.paginationNext,
            size: AstryxButtonSize.sm,
            variant: AstryxButtonVariant.ghost,
            enabled: interactive && page < pageCount,
            onPressed: () => onPageChanged!(page + 1),
          ),
        ],
      ),
    );
  }
}

/// The gap where pages were left out.
///
/// Not a button: it stands for a range rather than a page, and a control that
/// cannot say where it would take you is not one worth offering. The numbers
/// on either side of it are how a reader crosses it.
class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AstryxTheme.of(
          context,
        ).spacing(AstryxSpacingToken.spacing1),
      ),
      child: const AstryxText('…', color: AstryxTextColor.secondary),
    ),
  );
}
