/// A travel app's live screen: what leaves next, and where your own trip is up
/// to.
///
/// The screen a passenger opens on a platform with one hand full. That decides
/// how it is built. A departure board is read in a glance and never
/// interrogated, so nothing that matters is behind a press: the platform, the
/// delay and the line are all rendered on the row. A line is a category, not a
/// severity, so it takes a categorical palette and carries its name in words.
/// The clock is the whole point, so every time on the screen ages by itself.
///
/// Rendered in `transitTheme`, the one theme in this repository that was solved
/// for contrast rather than picked by eye. Every pair a passenger reads here —
/// a route chip, a delay badge, a leg of the journey — clears WCAG 2.1 AA in
/// both modes.
///
/// Not exported. A composition worth copying, built from nothing but what
/// `astryx_ui` ships.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_travel_journey -> TravelJourneyTemplate
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

// #end
