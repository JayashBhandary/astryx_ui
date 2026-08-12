import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The media group: avatars, thumbnails, the ratio box, the carousel, the
/// viewer and the overlay theme.
void main() {
  setUp(AstryxOverlayStack.reset);

  group('AstryxAvatar', () {
    testWidgets('falls back to initials, and names itself', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxAvatar(name: 'Ada Lovelace'),
        surfaceSize: const Size(200, 120),
      );

      expect(find.text('AL'), findsOneWidget);
      // An avatar without a name is an unlabelled image, and a row of them is a
      // row of unlabelled images.
      expect(find.bySemanticsLabel('Ada Lovelace'), findsOneWidget);
      handle.dispose();
    });

    test('initials take the first and last word', () {
      expect(const AstryxAvatar(name: 'Ada Lovelace').initials, 'AL');
      expect(const AstryxAvatar(name: 'ada').initials, 'A');
      expect(
        const AstryxAvatar(name: 'Ada Byron King Lovelace').initials,
        'AL',
      );
      expect(const AstryxAvatar(name: '   ').initials, '?');
    });

    testWidgets('an icon stands in where initials would mislead', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxAvatar(
          name: 'Deploy bot',
          icon: AstryxIconName.wrench,
        ),
        surfaceSize: const Size(200, 120),
      );

      expect(find.text('DB'), findsNothing);
      expect(find.byType(AstryxIcon), findsOneWidget);
    });

    testWidgets('a status is announced with the name', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxAvatar(
          name: 'Ada Lovelace',
          status: AstryxStatusDotVariant.success,
          statusLabel: 'Online',
        ),
        surfaceSize: const Size(200, 120),
      );

      // Colour is never the only signal, and a dot is too small to carry a
      // shape as well.
      expect(find.bySemanticsLabel('Ada Lovelace, Online'), findsOneWidget);
      handle.dispose();
    });

    test('a status without a label is a mistake, and asserts', () {
      expect(
        () => AstryxAvatar(
          name: 'Ada',
          status: AstryxStatusDotVariant.success,
        ),
        throwsAssertionError,
      );
    });
  });

  group('AstryxAvatarGroup', () {
    List<AstryxAvatar> people(int count) => <AstryxAvatar>[
      for (var i = 1; i <= count; i++) AstryxAvatar(name: 'Person $i'),
    ];

    testWidgets('shows up to max and counts the rest', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxAvatarGroup(avatars: people(7), max: 3),
        surfaceSize: const Size(400, 120),
      );

      expect(find.byType(AstryxAvatar), findsNWidgets(3));
      // The count is not decoration: it is the only thing saying the row is a
      // sample rather than the whole set.
      expect(find.text('+4'), findsOneWidget);
    });

    testWidgets('no overflow chip when everybody fits', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxAvatarGroup(avatars: people(2)),
        surfaceSize: const Size(400, 120),
      );

      expect(find.textContaining('+'), findsNothing);
    });

    testWidgets('announces the group, the names and the remainder', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        AstryxAvatarGroup(avatars: people(4), max: 2, label: 'Reviewers'),
        surfaceSize: const Size(400, 120),
      );

      expect(
        find.bySemanticsLabel('Reviewers, Person 1, Person 2, 2 more'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('the overflow chip can be pressed', (tester) async {
      var opened = 0;

      await pumpAstryxWidget(
        tester,
        AstryxAvatarGroup(
          avatars: people(6),
          max: 2,
          onOverflowPressed: () => opened++,
        ),
        surfaceSize: const Size(400, 120),
      );

      await tester.tap(find.text('+4'));
      await tester.pumpAndSettle();

      expect(opened, 1);
    });
  });

  group('AstryxAspectRatio', () {
    testWidgets('keeps the ratio it was given', (tester) async {
      await pumpAstryxWidget(
        tester,
        const SizedBox(
          width: 320,
          child: AstryxAspectRatio(ratio: 16 / 9),
        ),
        surfaceSize: const Size(400, 400),
      );

      final size = tester.getSize(find.byType(AstryxAspectRatio));
      expect(size.width, 320);
      expect(size.height, closeTo(180, 0.5));
    });

    testWidgets('an empty box is a placeholder, not a hole', (tester) async {
      await pumpAstryxWidget(
        tester,
        const SizedBox(width: 200, child: AstryxAspectRatio(ratio: 1)),
        surfaceSize: const Size(300, 300),
      );

      // A tinted box of the right shape reads as the picture arriving; a hole
      // reads as a bug.
      expect(find.byType(DecoratedBox), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('AstryxThumbnail', () {
    testWidgets('names itself and shows a glyph with no image', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxThumbnail(label: 'atlas-scheduler.log'),
        surfaceSize: const Size(300, 300),
      );

      expect(find.bySemanticsLabel('atlas-scheduler.log'), findsOneWidget);
      expect(find.byType(AstryxIcon), findsOneWidget);
      handle.dispose();
    });

    testWidgets('a caption is off unless asked for', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxThumbnail(label: 'shot.png'),
        surfaceSize: const Size(300, 300),
      );
      expect(find.text('shot.png'), findsNothing);

      await pumpAstryxWidget(
        tester,
        const AstryxThumbnail(label: 'shot.png', showCaption: true),
        surfaceSize: const Size(300, 300),
      );
      expect(find.text('shot.png'), findsOneWidget);
    });

    testWidgets('selected is announced as well as drawn', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        AstryxThumbnail(
          label: 'shot.png',
          selected: true,
          onPressed: () {},
        ),
        surfaceSize: const Size(300, 300),
      );

      // A ring alone is invisible to a screen reader and to anybody who cannot
      // separate the hues.
      expect(
        tester.getSemantics(find.bySemanticsLabel('shot.png')),
        isSemantics(label: 'shot.png', isButton: true, isSelected: true),
      );
      handle.dispose();
    });
  });

  group('AstryxCarousel', () {
    List<Widget> slides(int count) => <Widget>[
      for (var i = 1; i <= count; i++)
        SizedBox(height: 80, child: AstryxText('Slide $i')),
    ];

    testWidgets('opens on the first item and says where it is', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxCarousel(items: slides(4), height: 120),
      );

      expect(find.text('Slide 1'), findsOneWidget);
      expect(find.text('Item 1 of 4'), findsOneWidget);
    });

    testWidgets('the controls page it, and disable at the ends', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        AstryxCarousel(items: slides(2), height: 120),
      );

      // Disabled rather than hidden: a control that vanishes moves the one
      // beside it.
      // Disabled, so the tap lands on nothing.
      await tester.tap(find.bySemanticsLabel('Previous'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Item 1 of 2'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Item 2 of 2'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Next'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Item 2 of 2'), findsOneWidget);
    });

    testWidgets('the arrow keys move between items', (tester) async {
      final moved = <int>[];
      final strip = FocusNode();
      addTearDown(strip.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxCarousel(
          items: slides(3),
          height: 120,
          focusNode: strip,
          onIndexChanged: moved.add,
        ),
      );

      strip.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(moved, <int>[1]);

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(moved.last, 2);
    });

    testWidgets('the position is the container value', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        AstryxCarousel(items: slides(3), height: 120, label: 'Screenshots'),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Screenshots')).value,
        'Item 1 of 3',
      );
      handle.dispose();
    });
  });

  group('AstryxLightbox', () {
    late AstryxOverlayController controller;

    setUp(() => controller = AstryxOverlayController());
    tearDown(() => controller.dispose());

    Widget build({int initialIndex = 0, int count = 3}) => AstryxLightbox(
      controller: controller,
      initialIndex: initialIndex,
      items: <AstryxLightboxItem>[
        for (var i = 1; i <= count; i++)
          AstryxLightboxItem(
            label: 'Item $i',
            caption: 'Caption $i',
            child: SizedBox(height: 120, child: AstryxText('Media $i')),
          ),
      ],
    );

    testWidgets('renders nothing until it is opened', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );
      expect(find.text('Media 1'), findsNothing);

      controller.show();
      await tester.pumpAndSettle();

      expect(find.text('Media 1'), findsOneWidget);
      expect(find.text('1 of 3'), findsOneWidget);
      expect(find.text('Caption 1'), findsOneWidget);
    });

    testWidgets('pages with the controls and the arrow keys', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );
      controller.show();
      await tester.pumpAndSettle();

      await tester.tap(find.bySemanticsLabel('Next item'));
      await tester.pumpAndSettle();
      expect(find.text('Media 2'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Media 3'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('Media 2'), findsOneWidget);
    });

    testWidgets('opens on the item it was asked for, every time', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(initialIndex: 2),
        surfaceSize: const Size(600, 500),
      );

      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Media 3'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Previous item'));
      await tester.pumpAndSettle();
      controller.hide();
      await tester.pumpAndSettle();

      controller.show();
      await tester.pumpAndSettle();
      // A thumbnail grid opens the thumbnail that was pressed, not the one left
      // showing last time.
      expect(find.text('Media 3'), findsOneWidget);
    });

    testWidgets('a single item has no paging controls', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(count: 1),
        surfaceSize: const Size(600, 500),
      );
      controller.show();
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Next item'), findsNothing);
      expect(find.text('1 of 1'), findsNothing);
      expect(find.bySemanticsLabel('Close the viewer'), findsOneWidget);
    });

    testWidgets('Escape closes it', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );
      controller.show();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(controller.isOpen, isFalse);
    });
  });

  group('AstryxMediaTheme', () {
    testWidgets('forces the on-dark foreground for its subtree', (
      tester,
    ) async {
      late Color resolved;

      await pumpAstryxWidget(
        tester,
        AstryxMediaTheme(
          child: Builder(
            builder: (context) {
              resolved = DefaultTextStyle.of(context).style.color!;
              return const AstryxText(
                'Atlas, 14:02',
                color: AstryxTextColor.inherit,
              );
            },
          ),
        ),
        surfaceSize: const Size(400, 200),
      );

      final expected = AstryxTheme.of(
        tester.element(find.byType(AstryxMediaTheme)),
      ).color(AstryxColorToken.onDark);

      // `onDark`, not `textPrimary` inverted by hand: the token exists so this
      // is one decision the theme owns.
      expect(resolved, expected);
    });

    testWidgets('a scrim is drawn behind the content, and can be turned off', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxMediaTheme(child: AstryxText('Caption')),
        surfaceSize: const Size(400, 200),
      );

      final decorated = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(AstryxMediaTheme),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect((decorated.decoration as BoxDecoration).gradient, isNotNull);

      await pumpAstryxWidget(
        tester,
        const AstryxMediaTheme(
          scrim: AstryxMediaScrim.none,
          child: AstryxText('Caption'),
        ),
        surfaceSize: const Size(400, 200),
      );

      expect(
        find.descendant(
          of: find.byType(AstryxMediaTheme),
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );
    });
  });
}
