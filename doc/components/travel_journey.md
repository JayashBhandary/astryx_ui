---
title: Departure board
description: 'A travel screen: what leaves next, what is late, and where the passenger''s own trip is up to.'
component: true
group: Templates
source: example/lib/examples/template_travel_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One service on the board.
typedef Service = ({
  String line,
  AstryxPalette palette,
  String destination,
  String platform,
  String calling,
  Duration due,
  int delay,
  bool cancelled,
});

/// One leg of the passenger's own journey.
typedef Leg = ({
  String place,
  String detail,
  String time,
  AstryxStepStatus? status,
});

class TravelJourneyTemplate extends StatefulWidget {
  const TravelJourneyTemplate({super.key});

  @override
  State<TravelJourneyTemplate> createState() => _TravelJourneyTemplateState();
}

class _TravelJourneyTemplateState extends State<TravelJourneyTemplate> {
  /// One instant every time on this screen is measured from, so two rows the
  /// same number of minutes away never disagree by a second.
  late final DateTime _now = DateTime.now();

  static const List<Service> _departures = <Service>[
    (
      line: 'Coast',
      palette: AstryxPalette.teal,
      destination: 'Brighton',
      platform: '4',
      calling: 'Gatwick Airport · Haywards Heath',
      due: Duration(minutes: 6),
      delay: 0,
      cancelled: false,
    ),
    (
      line: 'Northern',
      palette: AstryxPalette.purple,
      destination: 'Leeds',
      platform: '1',
      calling: 'Peterborough · Doncaster · Wakefield',
      due: Duration(minutes: 14),
      delay: 9,
      cancelled: false,
    ),
    (
      line: 'Airport',
      palette: AstryxPalette.blue,
      destination: 'Terminal 5',
      platform: '9',
      calling: 'Non-stop',
      due: Duration(minutes: 21),
      delay: 0,
      cancelled: false,
    ),
    (
      line: 'Valley',
      palette: AstryxPalette.orange,
      destination: 'Sheffield',
      platform: '—',
      calling: 'Was calling at Chesterfield',
      due: Duration(minutes: 27),
      delay: 0,
      cancelled: true,
    ),
    (
      line: 'Coast',
      palette: AstryxPalette.teal,
      destination: 'Eastbourne',
      platform: '4',
      calling: 'Lewes · Polegate',
      due: Duration(minutes: 38),
      delay: 3,
      cancelled: false,
    ),
  ];

  static const List<Service> _arrivals = <Service>[
    (
      line: 'Northern',
      palette: AstryxPalette.purple,
      destination: 'from Edinburgh',
      platform: '2',
      calling: 'Terminating here',
      due: Duration(minutes: 3),
      delay: 12,
      cancelled: false,
    ),
    (
      line: 'Airport',
      palette: AstryxPalette.blue,
      destination: 'from Terminal 5',
      platform: '9',
      calling: 'Terminating here',
      due: Duration(minutes: 11),
      delay: 0,
      cancelled: false,
    ),
  ];

  static const List<Leg> _journey = <Leg>[
    (
      place: 'Kings Cross',
      detail: 'Northern line · platform 1',
      time: '14:02',
      status: AstryxStepStatus.success,
    ),
    (
      place: 'Doncaster',
      detail: 'Change here · 11 minutes to connect',
      time: '15:44',
      status: AstryxStepStatus.warning,
    ),
    (
      place: 'Leeds',
      detail: 'Arrive · coach C, seat 41A',
      time: '16:20',
      status: null,
    ),
  ];

  String _board = 'departures';
  int _selected = 1;

  List<Service> get _shown => _board == 'departures' ? _departures : _arrivals;

  Service get _open => _shown[_selected.clamp(0, _shown.length - 1)];

  @override
  Widget build(BuildContext context) {
    // The theme is a value, so a template can pin one without anything above
    // or below it knowing. In an application this provider is `AstryxApp`'s
    // `theme:` and appears once.
    //
    // The brightness is carried across deliberately. A nested provider's
    // `mode` defaults to `system`, so a provider that changed only the theme
    // would also throw away the brightness the site had resolved, and this
    // screen would stay light while every other page went dark.
    final inherited = AstryxTheme.of(context).mode;

    return AstryxThemeProvider(
      theme: transitTheme,
      mode: switch (inherited) {
        AstryxThemeMode.light => AstryxColorMode.light,
        AstryxThemeMode.dark => AstryxColorMode.dark,
      },
      child: Builder(
        builder: (context) {
          final t = AstryxTheme.of(context);

          return DecoratedBox(
            decoration: BoxDecoration(
              color: t.color(AstryxColorToken.backgroundBody),
              borderRadius: t.borderRadius(AstryxRadiusToken.container),
              border: Border.all(color: t.color(AstryxColorToken.border)),
            ),
            child: Padding(
              padding: EdgeInsets.all(t.spacing(AstryxSpacingToken.spacing5)),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing5,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  _header(),
                  if (_open.delay > 0 || _open.cancelled) _disruption(),
                  // Two panels on a concourse screen, one column on a phone.
                  // The breakpoint is read from the constraints rather than
                  // from the window: the same widget is used in a split view.
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 820;
                      final board = _boardPanel();
                      final trip = _trip();

                      if (!wide) {
                        return AstryxVStack(
                          gap: AstryxSpacingToken.spacing5,
                          align: AstryxStackAlign.stretch,
                          children: <Widget>[board, trip],
                        );
                      }

                      return AstryxHStack(
                        gap: AstryxSpacingToken.spacing5,
                        align: AstryxStackAlign.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(flex: 3, child: board),
                          Expanded(flex: 2, child: trip),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------
  // The header
  // ---------------------------------------------------------------------

  Widget _header() {
    // The station name and the board picker sit on one line when there is room
    // for both and stack when there is not. Measured from the constraints, not
    // from the window: this screen is also used inside a split view.
    return LayoutBuilder(
      builder: (context, constraints) {
        final control = AstryxSegmentedControl<String>(
          label: 'Board',
          value: _board,
          onChanged: (value) => setState(() {
            _board = value;
            _selected = 0;
          }),
          segments: const <AstryxSegment<String>>[
            AstryxSegment(value: 'departures', label: 'Departures'),
            AstryxSegment(value: 'arrivals', label: 'Arrivals'),
          ],
        );

        if (constraints.maxWidth < 560) {
          return AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[const _StationName(), control],
          );
        }

        return AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(child: _StationName()),
            control,
          ],
        );
      },
    );
  }

  Widget _disruption() {
    final service = _open;

    return AstryxBanner(
      status: service.cancelled
          ? AstryxBannerStatus.error
          : AstryxBannerStatus.warning,
      title: service.cancelled
          ? 'The ${service.destination} service is cancelled'
          : 'The ${service.destination} service is '
                '${service.delay} minutes late',
      description: service.cancelled
          ? 'Tickets are being accepted on the next Valley line service.'
          : 'Expected on platform ${service.platform}. Your connection at '
                'Doncaster is still reachable.',
    );
  }

  // ---------------------------------------------------------------------
  // The board
  // ---------------------------------------------------------------------

  Widget _boardPanel() {
    final shown = _shown;

    return AstryxSection(
      title: _board == 'departures' ? 'Next services' : 'Arriving',
      description: 'Press a service for its stops and your connection.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          // On a narrow board the time and the delay stop sharing a line. The
          // alternative is a trailing group that pushes the destination off
          // the edge, and a destination you cannot read is a broken board.
          final stacked = constraints.maxWidth < 430;

          return AstryxCard(
            padding: AstryxSpacingToken.spacing2,
            child: AstryxList(
              label: _board == 'departures'
                  ? 'Departures from London Kings Cross'
                  : 'Arrivals at London Kings Cross',
              showDividers: true,
              children: <Widget>[
                for (final (index, service) in shown.indexed)
                  AstryxItem(
                    selected: index == _selected,
                    onPressed: () => setState(() => _selected = index),
                    // A line is a category — "the Coast line" — so it
                    // takes a categorical palette and says its name.
                    // Nothing here depends on telling teal from purple.
                    leading: AstryxBadge(
                      service.line,
                      variant: AstryxBadgeVariant.palette(service.palette),
                    ),
                    label: service.destination,
                    description:
                        'Platform ${service.platform} · '
                        '${service.calling}',
                    maxLines: 2,
                    trailing: _when(service, stacked: stacked),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// The right-hand end of a row: the time it goes, and what happened to it.
  ///
  /// Both facts, always drawn. A board that hid the delay until you pressed
  /// the row would be a worse board than the mechanical one it replaced.
  Widget _when(Service service, {required bool stacked}) {
    final parts = <Widget>[
      AstryxTimestamp(
        _now.add(service.due),
        format: AstryxTimestampFormat.time,
        type: AstryxTextType.label,
      ),
      if (service.cancelled)
        const AstryxBadge('Cancelled', variant: AstryxBadgeVariant.error)
      else if (service.delay > 0)
        AstryxBadge(
          '+${service.delay} min',
          variant: AstryxBadgeVariant.warning,
        )
      else
        const AstryxBadge(
          'On time',
          variant: AstryxBadgeVariant.success,
        ),
    ];

    return stacked
        ? AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.end,
            children: parts,
          )
        : AstryxHStack(gap: AstryxSpacingToken.spacing2, children: parts);
  }

  // ---------------------------------------------------------------------
  // The passenger's own trip
  // ---------------------------------------------------------------------

  Widget _trip() {
    return AstryxSection(
      title: 'Your journey',
      description: 'Ticket QJ-40182 · 14:02 to Leeds',
      child: AstryxCard(
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing5,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            // Vertical, because a journey is a list of places and reads as
            // one. `activeStep` is the leg the passenger is on; the statuses
            // are what each leg turned out to be.
            AstryxStepper(
              label: 'Journey to Leeds',
              orientation: AstryxStepperOrientation.vertical,
              activeStep: 1,
              steps: <AstryxStep>[
                for (final leg in _journey)
                  AstryxStep(
                    label: leg.place,
                    description: leg.detail,
                    status: leg.status,
                    trailing: AstryxText(
                      leg.time,
                      type: AstryxTextType.label,
                      color: AstryxTextColor.secondary,
                    ),
                  ),
              ],
            ),
            const AstryxDivider(),
            const AstryxMetadataList(
              direction: AstryxMetadataListDirection.inline,
              items: <AstryxMetadataItem>[
                AstryxMetadataItem(
                  label: 'Coach and seat',
                  value: AstryxText('C · 41A, window'),
                  semanticsValue: 'Coach C, seat 41A, window',
                ),
                AstryxMetadataItem(
                  label: 'Ticket',
                  value: AstryxText('Off-peak return'),
                  semanticsValue: 'Off-peak return',
                ),
                AstryxMetadataItem(
                  label: 'Connection',
                  // A widget value needs `semanticsValue`, or a screen reader
                  // is read the badge's styling rather than the fact.
                  semanticsValue: 'Eleven minutes at Doncaster, tight',
                  value: AstryxBadge(
                    '11 min at Doncaster',
                    variant: AstryxBadgeVariant.warning,
                  ),
                ),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final primary = AstryxButton(
                  label: 'Show ticket',
                  variant: AstryxButtonVariant.primary,
                  onPressed: () {},
                );
                final secondary = AstryxButton(
                  label: 'Change trip',
                  variant: AstryxButtonVariant.secondary,
                  onPressed: () {},
                );

                if (constraints.maxWidth < 360) {
                  return AstryxVStack(
                    gap: AstryxSpacingToken.spacing2,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[primary, secondary],
                  );
                }

                return AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(child: primary),
                    secondary,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// The station, and whether the board behind it is still moving.
class _StationName extends StatelessWidget {
  const _StationName();

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxHeading('London Kings Cross'),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            // The dot breathes to say the board is live, and says so in words
            // as well: the pulse honours reduced motion and carries nothing a
            // label does not.
            AstryxStatusDot(
              AstryxStatusDotVariant.success,
              label: 'Live',
              pulsing: true,
            ),
            Flexible(
              child: AstryxText(
                'Updated every 30 seconds',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

Press a service to change the banner and the connection beside it. This is the one template that pins its own theme — `transitTheme` — so the theme picker above does not move it.


## It is read standing up, holding something

A departure board is glanced at, not interrogated. Everything a passenger needs in that glance is already on the row: the line, the destination, the platform, the time, and whether the service is late. Pressing a row changes what is said *about* it — the banner and the connection — and reveals nothing that was hidden.

| Because it is a board | It uses | Rather than |
| --- | --- | --- |
| The times must stay true | [AstryxTimestamp](timestamp.md), which re-renders as it ages | A formatted string, which freezes at load. A board that stopped is worse than no board. |
| A line is a category, not a severity | `AstryxBadge.palette` with the line name written in it | A coloured row. The ten palettes are categorical — "the Coast line" — and colour is never the only signal. |
| Lateness is a severity | A `warning` or `error` badge reading `+9 min` or `Cancelled` | A palette. Severity has its own three colours, and they carry an icon and a word. |
| The journey is a list of places | A vertical [AstryxStepper](stepper.md), one step per leg | A progress bar. A passenger needs the names of the places, not a percentage. |

## The one template that pins a theme

Every other screen here renders in whichever theme the picker is set to. This one wraps itself in an `AstryxThemeProvider` holding `transitTheme`, because the theme is half of what the template is showing. A theme is a value rather than a global, so a subtree can hold a different one and nothing above or below it needs to know.

```dart
AstryxThemeProvider(
  theme: transitTheme,
  child: const DepartureBoard(),
)
```

In an application that provider is `AstryxApp`'s `theme:`, and it appears once.

## Why transit and not one of the seven

Every colour pair a passenger reads on this screen was solved for a contrast ratio rather than picked by eye: text clears 4.5:1 on every surface it can land on, including `--color-background-muted`; a control's boundary clears 3:1; and `--color-on-success` is a near-white or a near-black, never the fill it sits on. See [Theming](../guides/theming.md) for what the theme sets and why.

> **Note**
>
> A board on a wall and a board in a pocket are the same widget here: the two-panel layout collapses to one column from a `LayoutBuilder` reading its own constraints, so it also works in a split view rather than only at a window size.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Departure board`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Departure+board&component=Departure+board) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Departure+board&area=Departure+board) — both templates arrive with the component filled in.
