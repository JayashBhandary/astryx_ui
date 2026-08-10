import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example banner_demo -> BannerDemoExample
class BannerDemoExample extends StatelessWidget {
  const BannerDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxBanner(
      status: AstryxBannerStatus.warning,
      title: 'Your trial ends in three days',
      description: 'Add a payment method to keep your projects running.',
    );
  }
}
// #end

// #example banner_statuses -> BannerStatusesExample
class BannerStatusesExample extends StatelessWidget {
  const BannerStatusesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final status in AstryxBannerStatus.values)
          AstryxBanner(
            status: status,
            title: 'status: ${status.name}',
            description: 'Each status brings its own fill, icon and urgency.',
          ),
      ],
    );
  }
}
// #end

// #example banner_actions -> BannerActionsExample
class BannerActionsExample extends StatefulWidget {
  const BannerActionsExample({super.key});

  @override
  State<BannerActionsExample> createState() => _BannerActionsExampleState();
}

class _BannerActionsExampleState extends State<BannerActionsExample> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return AstryxButton(
        label: 'Bring the banner back',
        size: AstryxButtonSize.sm,
        onPressed: () => setState(() => _visible = true),
      );
    }

    return AstryxBanner(
      title: 'A new version is available',
      description: 'Reload to pick up the latest deploy.',
      actions: <Widget>[
        AstryxButton(
          label: 'Reload',
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
      ],
      onDismiss: () => setState(() => _visible = false),
    );
  }
}
// #end

// #example banner_content -> BannerContentExample
class BannerContentExample extends StatelessWidget {
  const BannerContentExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Detail belongs in `content`, on the card background — the coloured area's
    // contrast is tuned for one line, not a paragraph or a list.
    return const AstryxBanner(
      status: AstryxBannerStatus.error,
      title: 'Could not save three fields',
      content: AstryxVStack(
        gap: AstryxSpacingToken.spacing1,
        children: <Widget>[
          AstryxText('Email — that address is already in use.'),
          AstryxText('Postcode — not valid for the chosen country.'),
          AstryxText('Phone — include the country code.'),
        ],
      ),
    );
  }
}
// #end

// #example banner_icon -> BannerIconExample
class BannerIconExample extends StatelessWidget {
  const BannerIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxBanner(
          title: 'A different icon, same status',
          icon: AstryxIcon(AstryxIconName.microphone),
        ),
        AstryxBanner(
          title: 'No icon at all',
          showIcon: false,
        ),
      ],
    );
  }
}
// #end
