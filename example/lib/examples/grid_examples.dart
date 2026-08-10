import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example grid_demo -> GridDemoExample
class GridDemoExample extends StatelessWidget {
  const GridDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxGrid(
      columns: 3,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        _Metric('Requests', '4,201'),
        _Metric('Errors', '12'),
        _Metric('p95', '318 ms'),
        _Metric('Uptime', '99.98%'),
        _Metric('Projects', '7'),
        _Metric('Seats', '24'),
      ],
    );
  }
}
// #end

// #example grid_responsive -> GridResponsiveExample
class GridResponsiveExample extends StatelessWidget {
  const GridResponsiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    // No breakpoints. The column count falls out of the width available, the
    // way `repeat(auto-fit, minmax(180px, 1fr))` does upstream. Resize the
    // window to watch it re-flow.
    return const AstryxGrid(
      minWidth: 180,
      maxColumns: 4,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        _Metric('Requests', '4,201'),
        _Metric('Errors', '12'),
        _Metric('p95', '318 ms'),
        _Metric('Uptime', '99.98%'),
        _Metric('Projects', '7'),
      ],
    );
  }
}
// #end

// #example grid_repeat -> GridRepeatExample
class GridRepeatExample extends StatelessWidget {
  const GridRepeatExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Five items in a four-column track list leave one short row. `fit`
    // stretches it; `fill` keeps the empty tracks, so the last item stays the
    // width it would have had in a full row.
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxText('repeat: fit', type: AstryxTextType.label),
        AstryxGrid(
          minWidth: 140,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            _Metric('One', '1'),
            _Metric('Two', '2'),
            _Metric('Three', '3'),
            _Metric('Four', '4'),
            _Metric('Five', '5'),
          ],
        ),
        AstryxText('repeat: fill', type: AstryxTextType.label),
        AstryxGrid(
          minWidth: 140,
          repeat: AstryxGridRepeat.fill,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            _Metric('One', '1'),
            _Metric('Two', '2'),
            _Metric('Three', '3'),
            _Metric('Four', '4'),
            _Metric('Five', '5'),
          ],
        ),
      ],
    );
  }
}
// #end

// #example grid_gaps -> GridGapsExample
class GridGapsExample extends StatelessWidget {
  const GridGapsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Rows and columns can breathe differently — tight columns, roomy rows.
    return const AstryxGrid(
      columns: 3,
      columnGap: AstryxSpacingToken.spacing1,
      rowGap: AstryxSpacingToken.spacing6,
      children: <Widget>[
        _Metric('Requests', '4,201'),
        _Metric('Errors', '12'),
        _Metric('p95', '318 ms'),
        _Metric('Uptime', '99.98%'),
        _Metric('Projects', '7'),
        _Metric('Seats', '24'),
      ],
    );
  }
}
// #end

/// A tile, so the grid's tracks are visible.
class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      variant: AstryxCardVariant.muted,
      padding: AstryxSpacingToken.spacing3,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing0_5,
        children: <Widget>[
          AstryxText(
            label,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          AstryxText(value, type: AstryxTextType.large),
        ],
      ),
    );
  }
}
