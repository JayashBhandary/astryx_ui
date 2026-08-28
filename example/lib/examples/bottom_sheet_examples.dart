import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example bottom_sheet_demo -> BottomSheetDemoExample
class BottomSheetDemoExample extends StatefulWidget {
  const BottomSheetDemoExample({super.key});

  @override
  State<BottomSheetDemoExample> createState() => _BottomSheetDemoExampleState();
}

class _BottomSheetDemoExampleState extends State<BottomSheetDemoExample> {
  final AstryxBottomSheetController _sheet = AstryxBottomSheetController();

  @override
  void dispose() {
    _sheet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Like every overlay here the sheet is a widget in the tree, not a
    // `showModalBottomSheet` call: it renders nothing until its controller
    // opens it, so it sits next to whatever opens it.
    return AstryxHStack(
      children: <Widget>[
        AstryxButton(label: 'Filters', onPressed: _sheet.show),
        AstryxBottomSheet(
          controller: _sheet,
          label: 'Filters',
          height: AstryxBottomSheetHeight.hug,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxHeading('Filters', type: AstryxHeadingType.display3),
              AstryxCheckbox(
                label: 'Only my issues',
                value: true,
                onChanged: (_) {},
              ),
              AstryxCheckbox(
                label: 'Include closed',
                value: false,
                onChanged: (_) {},
              ),
              AstryxButton(label: 'Apply', onPressed: _sheet.hide),
            ],
          ),
        ),
      ],
    );
  }
}
// #end

// #example bottom_sheet_heights -> BottomSheetHeightsExample
class BottomSheetHeightsExample extends StatefulWidget {
  const BottomSheetHeightsExample({super.key});

  @override
  State<BottomSheetHeightsExample> createState() =>
      _BottomSheetHeightsExampleState();
}

class _BottomSheetHeightsExampleState extends State<BottomSheetHeightsExample> {
  final Map<AstryxBottomSheetHeight, AstryxBottomSheetController> _sheets = {
    for (final height in AstryxBottomSheetHeight.values)
      height: AstryxBottomSheetController(),
  };

  @override
  void dispose() {
    for (final controller in _sheets.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `hug` sizes to its content, `capped` takes 62% of the viewport whatever
    // is in it, and `tall` takes 92% — a working surface with the page a
    // sliver above it.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final MapEntry(key: height, value: controller) in _sheets.entries)
          AstryxHStack(
            children: <Widget>[
              AstryxButton(
                label: height.name,
                variant: AstryxButtonVariant.secondary,
                onPressed: controller.show,
              ),
              AstryxBottomSheet(
                controller: controller,
                label: '${height.name} sheet',
                height: height,
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing3,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    AstryxHeading(
                      height.name,
                      type: AstryxHeadingType.display3,
                    ),
                    const AstryxText(
                      'Two lines of content, so the three budgets can be told '
                      'apart by what they do with the space rather than by '
                      'how much of it they fill.',
                    ),
                    AstryxButton(label: 'Close', onPressed: controller.hide),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example bottom_sheet_snap -> BottomSheetSnapExample
class BottomSheetSnapExample extends StatefulWidget {
  const BottomSheetSnapExample({super.key});

  @override
  State<BottomSheetSnapExample> createState() => _BottomSheetSnapExampleState();
}

class _BottomSheetSnapExampleState extends State<BottomSheetSnapExample> {
  final AstryxBottomSheetController _sheet = AstryxBottomSheetController();

  @override
  void dispose() {
    _sheet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Two detents: a third of the screen and most of it. Drag the handle to
    // move between them. Nothing lives behind a detent that the sheet does not
    // also reach by scrolling — a stop is a convenience, never the only way to
    // something.
    return AstryxHStack(
      children: <Widget>[
        AstryxButton(label: 'Nearby stops', onPressed: _sheet.show),
        AstryxBottomSheet(
          controller: _sheet,
          label: 'Nearby stops',
          snapPoints: const <double>[0.33, 0.85],
          initialSnapPoint: 0,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxHeading(
                'Nearby stops',
                type: AstryxHeadingType.display3,
              ),
              for (var i = 1; i <= 8; i++)
                AstryxItem(
                  label: 'Platform $i',
                  description: '${i * 2} minutes away',
                ),
            ],
          ),
        ),
      ],
    );
  }
}
// #end

// #example bottom_sheet_switcher -> BottomSheetSwitcherExample
class BottomSheetSwitcherExample extends StatefulWidget {
  const BottomSheetSwitcherExample({super.key});

  @override
  State<BottomSheetSwitcherExample> createState() =>
      _BottomSheetSwitcherExampleState();
}

class _BottomSheetSwitcherExampleState
    extends State<BottomSheetSwitcherExample> {
  String? _step;

  void _go(String? id) => setState(() => _step = id);

  @override
  Widget build(BuildContext context) {
    // Three sheets, one scrim. Opening and closing three separate sheets in
    // turn would dim the page, undim it and dim it again — three
    // interruptions where the user performed one task.
    return AstryxHStack(
      children: <Widget>[
        AstryxButton(label: 'Check out', onPressed: () => _go('method')),
        AstryxBottomSheetSwitcher(
          activeSheetId: _step,
          onActiveSheetChanged: _go,
          sheets: <AstryxBottomSheetPage>[
            AstryxBottomSheetPage(
              id: 'method',
              label: 'Payment method',
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxHeading(
                    'Payment method',
                    type: AstryxHeadingType.display3,
                  ),
                  AstryxItem(
                    label: 'Card ending 4242',
                    onPressed: () => _go('confirm'),
                  ),
                  AstryxItem(
                    label: 'Pay on delivery',
                    onPressed: () => _go('confirm'),
                  ),
                ],
              ),
            ),
            AstryxBottomSheetPage(
              id: 'confirm',
              label: 'Confirm payment',
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxHeading(
                    'Confirm payment',
                    type: AstryxHeadingType.display3,
                  ),
                  const AstryxText('£42.00 to Acme Supplies.'),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    justify: AstryxStackJustify.end,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      AstryxButton(
                        label: 'Back',
                        variant: AstryxButtonVariant.secondary,
                        onPressed: () => _go('method'),
                      ),
                      AstryxButton(
                        label: 'Pay',
                        onPressed: () => _go('receipt'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AstryxBottomSheetPage(
              id: 'receipt',
              label: 'Payment sent',
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxBanner(
                    status: AstryxBannerStatus.success,
                    title: 'Payment sent',
                    description: 'A receipt is on its way to your inbox.',
                  ),
                  AstryxButton(label: 'Done', onPressed: () => _go(null)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// #end
