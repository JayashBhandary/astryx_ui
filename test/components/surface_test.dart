import 'dart:math' as math;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Phase 10 — surfaces.
///
/// `AstryxCard`, `AstryxBadge` and `AstryxBanner`. Appearance lives in
/// `test/goldens/surface_golden_test.dart`.
void main() {
  group('P10-1 — AstryxCard', () {
    testWidgets('an inert card is not a button', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxCard(child: AstryxText('Body')),
      );

      // No `Semantics(button:)` anywhere in the card — the whole point of the
      // callback being optional.
      expect(
        find.descendant(
          of: find.byType(AstryxCard),
          matching: find.byWidgetPredicate(
            (w) => w is Semantics && (w.properties.button ?? false),
          ),
        ),
        findsNothing,
      );
    });

    testWidgets('onPressed makes it a button, and it fires', (tester) async {
      final handle = tester.ensureSemantics();
      var pressed = 0;

      await pumpAstryxWidget(
        tester,
        AstryxCard(
          semanticsLabel: 'Open project',
          onPressed: () => pressed++,
          child: const AstryxText('Body'),
        ),
      );

      final node = tester.getSemantics(find.byType(AstryxCard));
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.label, 'Open project');

      await tester.tap(find.byType(AstryxCard));
      await tester.pump();
      expect(pressed, 1);
      handle.dispose();
    });

    testWidgets('Enter and Space activate it', (tester) async {
      var pressed = 0;
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxCard(
          focusNode: node,
          autofocus: true,
          onPressed: () => pressed++,
          child: const AstryxText('Body'),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(pressed, 2);
    });

    testWidgets('header, body and footer all render, in order', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxCard(
          header: AstryxText('Header'),
          footer: AstryxText('Footer'),
          child: AstryxText('Body'),
        ),
        surfaceSize: const Size(400, 400),
      );

      final header = tester.getTopLeft(find.text('Header')).dy;
      final body = tester.getTopLeft(find.text('Body')).dy;
      final footer = tester.getTopLeft(find.text('Footer')).dy;
      expect(header, lessThan(body));
      expect(body, lessThan(footer));
    });

    testWidgets('a transparent card paints no fill', (tester) async {
      for (final entry in <AstryxCardVariant, bool>{
        AstryxCardVariant.transparent: true,
        AstryxCardVariant.standard: false,
        AstryxCardVariant.muted: false,
        const AstryxCardVariant.palette(AstryxPalette.purple): false,
      }.entries) {
        expect(
          entry.key.backgroundToken == null,
          entry.value,
          reason: '$entry',
        );
      }
    });

    testWidgets('meets the touch tap-target guideline when pressable', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxCard(
          semanticsLabel: 'Open',
          onPressed: () {},
          child: const AstryxText('x'),
        ),
        density: AstryxDensity.touch,
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });
  });

  group('P10-2 — AstryxBadge', () {
    testWidgets('renders its label and announces it', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, const AstryxBadge('Active'));

      expect(find.text('Active'), findsOneWidget);
      expect(tester.getSemantics(find.byType(AstryxBadge)).label, 'Active');
      handle.dispose();
    });

    testWidgets('semanticsLabel replaces a meaningless visible string', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxBadge('3', semanticsLabel: '3 unread'),
      );

      expect(find.text('3'), findsOneWidget);
      expect(tester.getSemantics(find.byType(AstryxBadge)).label, '3 unread');
      handle.dispose();
    });

    testWidgets('every sentiment variant pairs a fill with an on-colour', (
      tester,
    ) async {
      const variants = <AstryxBadgeVariant>[
        AstryxBadgeVariant.neutral,
        AstryxBadgeVariant.info,
        AstryxBadgeVariant.success,
        AstryxBadgeVariant.warning,
        AstryxBadgeVariant.error,
      ];
      for (final variant in variants) {
        expect(variant.backgroundToken, isNotNull);
        expect(variant.foregroundToken, isNotNull);
      }
    });

    testWidgets('every categorical family resolves all four of its tokens', (
      tester,
    ) async {
      await pumpAstryxWidget(tester, const SizedBox.shrink());
      final theme = AstryxTheme.of(
        tester.element(find.byType(SizedBox).first),
      );

      for (final palette in AstryxPalette.values) {
        // Nine families × four tokens. A missing one would silently fall back
        // to a default colour, which is exactly the drift the palette exists
        // to prevent.
        expect(
          theme.color(palette.background),
          isNotNull,
          reason: palette.name,
        );
        expect(theme.color(palette.border), isNotNull, reason: palette.name);
        expect(theme.color(palette.text), isNotNull, reason: palette.name);
        expect(theme.color(palette.icon), isNotNull, reason: palette.name);
      }
    });

    testWidgets('categorical text contrasts with its own background', (
      tester,
    ) async {
      // The guarantee upstream makes and the plan says not to adjust: every
      // one of the nine passes AA on its own tinted fill, in both modes.
      //
      // The tints are **translucent** — `--color-background-blue` is
      // `#0171E333`, 20% alpha — so the effective background is the tint
      // composited over the surface beneath it. Comparing against the raw
      // token instead reports 1.0–4.5:1 and looks like twenty contrast
      // failures that are not there (ADR-040).
      for (final brightness in Brightness.values) {
        await pumpAstryxWidget(
          tester,
          const SizedBox.shrink(),
          brightness: brightness,
        );
        final theme = AstryxTheme.of(
          tester.element(find.byType(SizedBox).first),
        );

        final surface = theme.color(AstryxColorToken.backgroundCard);
        for (final palette in AstryxPalette.values) {
          final ratio = _contrast(
            theme.color(palette.text),
            Color.alphaBlend(theme.color(palette.background), surface),
          );
          expect(
            ratio,
            greaterThanOrEqualTo(4.5),
            reason:
                '${palette.name} on ${brightness.name}: '
                '${ratio.toStringAsFixed(2)}:1',
          );
        }
      }
    });
  });

  group('P10-3 — AstryxBanner', () {
    testWidgets('shows its title, description and status icon', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxBanner(
          status: AstryxBannerStatus.error,
          title: 'Could not save',
          description: 'The server rejected three fields.',
        ),
        surfaceSize: const Size(500, 300),
      );

      expect(find.text('Could not save'), findsOneWidget);
      expect(find.text('The server rejected three fields.'), findsOneWidget);
      expect(find.byType(AstryxIcon), findsOneWidget);
    });

    testWidgets('is a live region when it announces', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxBanner(title: 'Heads up'),
        surfaceSize: const Size(500, 300),
      );

      expect(
        tester
            .getSemantics(find.byType(AstryxBanner))
            .flagsCollection
            .isLiveRegion,
        isTrue,
      );
      handle.dispose();
    });

    testWidgets('announce: false leaves the live region off', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxBanner(title: 'Always here', announce: false),
        surfaceSize: const Size(500, 300),
      );

      expect(
        tester
            .getSemantics(find.byType(AstryxBanner))
            .flagsCollection
            .isLiveRegion,
        isFalse,
      );
      handle.dispose();
    });

    testWidgets('only an error interrupts', (tester) async {
      expect(
        AstryxBannerStatus.error.assertiveness,
        Assertiveness.assertive,
      );
      for (final status in <AstryxBannerStatus>[
        AstryxBannerStatus.info,
        AstryxBannerStatus.warning,
        AstryxBannerStatus.success,
      ]) {
        expect(status.assertiveness, Assertiveness.polite, reason: status.name);
      }
    });

    testWidgets('the dismiss button appears only with a callback', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxBanner(title: 'Heads up'),
        surfaceSize: const Size(500, 300),
      );
      expect(find.byType(AstryxIconButton), findsNothing);

      var dismissed = 0;
      await pumpAstryxWidget(
        tester,
        AstryxBanner(title: 'Heads up', onDismiss: () => dismissed++),
        surfaceSize: const Size(500, 300),
      );

      await tester.tap(find.byType(AstryxIconButton));
      await tester.pump();
      expect(dismissed, 1);
    });

    testWidgets('extra content renders below the header', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxBanner(
          title: 'Three fields failed',
          content: AstryxText('Email, postcode, phone'),
        ),
        surfaceSize: const Size(500, 300),
      );

      expect(
        tester.getTopLeft(find.text('Three fields failed')).dy,
        lessThan(tester.getTopLeft(find.text('Email, postcode, phone')).dy),
      );
    });
  });

  _deferredFromPhase9();
}

/// The two Phase-9 deferrals closed out here.
void _deferredFromPhase9() {
  group('deferred from Phase 9', () {
    testWidgets('AstryxIconButton renders its tooltip', (tester) async {
      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxIconButton(
            icon: AstryxIconName.check,
            label: 'Archive',
            tooltip: 'Archive this conversation',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Archive this conversation'), findsNothing);

      await tester.longPress(find.byType(AstryxIconButton));
      await tester.pumpAndSettle();
      expect(find.text('Archive this conversation'), findsOneWidget);
    });

    testWidgets('the tooltip does not announce the name twice', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxIconButton(
            icon: AstryxIconName.check,
            label: 'Archive',
            tooltip: 'Archive this conversation',
            onPressed: () {},
          ),
        ),
      );

      // Exactly one node carries the name, and it carries no tooltip beside
      // it — `excludeFromSemantics`, so nothing is announced twice.
      final node = tester.getSemantics(find.bySemanticsLabel('Archive'));
      expect(node.label, 'Archive');
      expect(node.tooltip, isEmpty);
      handle.dispose();
    });

    testWidgets('a truncation tooltip appears only when text is cut off', (
      tester,
    ) async {
      const long = 'A project name far too long to fit in this narrow column';

      await pumpAstryxWidget(
        tester,
        const Center(
          child: SizedBox(
            width: 120,
            child: AstryxText(long, maxLines: 1, truncateTooltip: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(AstryxText));
      await tester.pumpAndSettle();
      expect(find.text(long), findsNWidgets(2), reason: 'the text and its tip');
    });

    testWidgets('short text gets no truncation tooltip', (tester) async {
      await pumpAstryxWidget(
        tester,
        const Center(
          child: SizedBox(
            width: 300,
            child: AstryxText('Short', maxLines: 1, truncateTooltip: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(AstryxText));
      await tester.pumpAndSettle();
      // One occurrence: the text itself. A tooltip repeating legible text is
      // the failure this measurement exists to avoid.
      expect(find.text('Short'), findsOneWidget);
    });
  });
}

/// WCAG 2.1 relative-luminance contrast ratio.
double _contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
}
