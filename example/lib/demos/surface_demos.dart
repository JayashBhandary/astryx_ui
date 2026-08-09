import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/demos/layout_demos.dart';
import 'package:flutter/widgets.dart';

/// `AstryxCard`.
abstract final class CardDemo {
  static Widget build(BuildContext context) => const _CardDemo();
}

class _CardDemo extends StatefulWidget {
  const _CardDemo();

  @override
  State<_CardDemo> createState() => _CardDemoState();
}

class _CardDemoState extends State<_CardDemo> {
  int _presses = 0;

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Slots — header, body, footer',
        child: SizedBox(
          width: 340,
          child: AstryxCard(
            header: const AstryxHeading(
              'Usage',
              type: AstryxHeadingType.display3,
            ),
            footer: AstryxButton(label: 'See details', onPressed: () {}),
            child: const AstryxText('4,201 requests this month.'),
          ),
        ),
      ),
      DemoSection(
        title: 'Pressable — one widget, not a second ClickableCard',
        child: SizedBox(
          width: 340,
          child: AstryxCard(
            semanticsLabel: 'Open the requests report',
            onPressed: () => setState(() => _presses++),
            child: AstryxText('Pressed $_presses times.'),
          ),
        ),
      ),
      const DemoSection(
        title: 'Variants',
        child: AstryxGrid(
          columns: 3,
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxCard(child: AstryxText('Standard')),
            AstryxCard(
              variant: AstryxCardVariant.muted,
              child: AstryxText('Muted'),
            ),
            AstryxCard(
              variant: AstryxCardVariant.transparent,
              showBorder: false,
              child: AstryxText('Transparent'),
            ),
            AstryxCard(
              variant: AstryxCardVariant.palette(AstryxPalette.blue),
              child: AstryxText('Blue'),
            ),
            AstryxCard(
              variant: AstryxCardVariant.palette(AstryxPalette.green),
              child: AstryxText('Green'),
            ),
            AstryxCard(
              variant: AstryxCardVariant.palette(AstryxPalette.purple),
              child: AstryxText('Purple'),
            ),
          ],
        ),
      ),
      const DemoSection(
        title: 'Elevation',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxCard(child: AstryxText('none')),
            AstryxCard(
              elevation: AstryxElevation.low,
              child: AstryxText('low'),
            ),
            AstryxCard(
              elevation: AstryxElevation.med,
              child: AstryxText('med'),
            ),
            AstryxCard(
              elevation: AstryxElevation.high,
              child: AstryxText('high'),
            ),
          ],
        ),
      ),
    ],
  );
}

/// `AstryxBadge` and `AstryxBanner`.
abstract final class BadgeBannerDemo {
  static Widget build(BuildContext context) => const _BadgeBannerDemo();
}

class _BadgeBannerDemo extends StatefulWidget {
  const _BadgeBannerDemo();

  @override
  State<_BadgeBannerDemo> createState() => _BadgeBannerDemoState();
}

class _BadgeBannerDemoState extends State<_BadgeBannerDemo> {
  bool _showDismissible = true;
  AstryxBannerStatus _status = AstryxBannerStatus.info;

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      const DemoSection(
        title: 'Badge — sentiment',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxBadge('Neutral'),
            AstryxBadge('Info', variant: AstryxBadgeVariant.info),
            AstryxBadge('Active', variant: AstryxBadgeVariant.success),
            AstryxBadge('Degraded', variant: AstryxBadgeVariant.warning),
            AstryxBadge('Down', variant: AstryxBadgeVariant.error),
            AstryxBadge(
              'Done',
              icon: AstryxIcon(AstryxIconName.check),
              variant: AstryxBadgeVariant.success,
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Badge — the nine categorical families',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          wrap: true,
          children: <Widget>[
            for (final palette in AstryxPalette.values)
              AstryxBadge(
                palette.name,
                variant: AstryxBadgeVariant.palette(palette),
              ),
          ],
        ),
      ),
      DemoSection(
        title: 'Banner — the status is announced, not just coloured',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxBanner(
              status: _status,
              title: 'This banner re-announces when its status changes',
              description: 'Currently ${_status.name}.',
              actions: <Widget>[
                AstryxButton(
                  label: 'Cycle',
                  size: AstryxButtonSize.sm,
                  onPressed: () => setState(() {
                    final next =
                        (AstryxBannerStatus.values.indexOf(_status) + 1) %
                        AstryxBannerStatus.values.length;
                    _status = AstryxBannerStatus.values[next];
                  }),
                ),
              ],
            ),
            if (_showDismissible)
              AstryxBanner(
                status: AstryxBannerStatus.warning,
                title: 'Your trial ends in three days',
                onDismiss: () => setState(() => _showDismissible = false),
              ),
            const AstryxBanner(
              status: AstryxBannerStatus.error,
              title: 'Could not save',
              content: AstryxText('Email, postcode and phone were rejected.'),
            ),
          ],
        ),
      ),
    ],
  );
}
