import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The two pieces of interaction machinery the hooks group needed: hotkeys, and
/// the scroll lock behind a modal.
void main() {
  setUp(AstryxOverlayStack.reset);

  group('AstryxHotkey', () {
    const search = AstryxHotkey.mod(LogicalKeyboardKey.keyK);

    test('mod is Command on Apple platforms and Control elsewhere', () {
      expect(search.metaFor(TargetPlatform.macOS), isTrue);
      expect(search.controlFor(TargetPlatform.macOS), isFalse);

      expect(search.controlFor(TargetPlatform.windows), isTrue);
      expect(search.metaFor(TargetPlatform.windows), isFalse);
    });

    test('draws the platform’s own glyphs and speaks the words', () {
      expect(search.capsFor(TargetPlatform.macOS), <String>['⌘', 'K']);
      expect(search.capsFor(TargetPlatform.linux), <String>['Ctrl', 'K']);

      // Symbols are unreadable aloud, so the spoken form names the modifier.
      expect(search.describeFor(TargetPlatform.macOS), 'Command K');
      expect(search.describeFor(TargetPlatform.linux), 'Control K');
    });

    test('an explicit modifier does not follow the platform', () {
      const hardwired = AstryxHotkey(LogicalKeyboardKey.keyK, control: true);

      expect(hardwired.controlFor(TargetPlatform.macOS), isTrue);
      expect(hardwired.metaFor(TargetPlatform.macOS), isFalse);
    });

    test('resolves to a SingleActivator per platform', () {
      final mac = search.activatorFor(TargetPlatform.macOS);
      final win = search.activatorFor(TargetPlatform.windows);

      expect((mac as SingleActivator).meta, isTrue);
      expect((win as SingleActivator).control, isTrue);
    });

    test('equality is by key and modifiers, not by identity', () {
      expect(
        const AstryxHotkey.mod(LogicalKeyboardKey.keyK),
        const AstryxHotkey.mod(LogicalKeyboardKey.keyK),
      );
      expect(
        const AstryxHotkey.mod(LogicalKeyboardKey.keyK),
        isNot(const AstryxHotkey(LogicalKeyboardKey.keyK, control: true)),
      );
    });
  });

  group('AstryxHotkeys', () {
    testWidgets('fires the callback for the platform’s own modifier', (
      tester,
    ) async {
      var fired = 0;

      await pumpAstryxWidget(
        tester,
        AstryxHotkeys(
          platform: TargetPlatform.macOS,
          // A key event walks *up* from whatever holds focus, so an app-wide
          // scope has to hold it. That is Flutter's model, not this widget's.
          autofocus: true,
          bindings: <AstryxHotkey, VoidCallback>{
            const AstryxHotkey.mod(LogicalKeyboardKey.keyK): () => fired++,
          },
          child: const AstryxText('A page'),
        ),
        surfaceSize: const Size(300, 120),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pumpAndSettle();

      expect(fired, 1);
    });

    testWidgets('the same definition needs Control on Windows', (tester) async {
      var fired = 0;

      await pumpAstryxWidget(
        tester,
        AstryxHotkeys(
          platform: TargetPlatform.windows,
          autofocus: true,
          bindings: <AstryxHotkey, VoidCallback>{
            const AstryxHotkey.mod(LogicalKeyboardKey.keyK): () => fired++,
          },
          child: const AstryxText('A page'),
        ),
        surfaceSize: const Size(300, 120),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pumpAndSettle();
      expect(fired, 0, reason: 'Command is not the modifier on Windows');

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(fired, 1);
    });

    testWidgets('enabled: false binds nothing', (tester) async {
      var fired = 0;

      await pumpAstryxWidget(
        tester,
        AstryxHotkeys(
          enabled: false,
          platform: TargetPlatform.macOS,
          autofocus: true,
          bindings: <AstryxHotkey, VoidCallback>{
            const AstryxHotkey.mod(LogicalKeyboardKey.keyK): () => fired++,
          },
          child: const AstryxText('A page'),
        ),
        surfaceSize: const Size(300, 120),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pumpAndSettle();

      expect(fired, 0);
    });
  });

  group('AstryxKbd.hotkey', () {
    testWidgets('draws the caps the platform resolved to', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxKbd.hotkey(AstryxHotkey.mod(LogicalKeyboardKey.keyK)),
        surfaceSize: const Size(200, 100),
      );

      expect(find.text('⌘'), findsOneWidget);
      expect(find.text('K'), findsOneWidget);
      // Drawn as symbols, announced as words.
      expect(find.bySemanticsLabel('Command K'), findsOneWidget);
    });

    testWidgets('and the words on a platform that uses them', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxKbd.hotkey(AstryxHotkey.mod(LogicalKeyboardKey.keyK)),
        surfaceSize: const Size(200, 100),
        platform: TargetPlatform.linux,
      );

      expect(find.text('Ctrl'), findsOneWidget);
    });
  });

  group('AstryxScrollLock', () {
    /// A page-sized scroller, so a drag has somewhere to go.
    Widget buildPage() => ListView(
      children: <Widget>[
        for (var i = 0; i < 40; i++)
          SizedBox(height: 40, child: AstryxText('$i')),
      ],
    );

    testWidgets('locked stops the subtree scrolling', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxScrollLock(locked: true, child: buildPage()),
        surfaceSize: const Size(300, 300),
      );

      expect(find.text('0'), findsOneWidget);

      // The lock absorbs the pointer, so the drag never reaches the list —
      // which is the mechanism, not an accident of the test.
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -200),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      // The first row is still where it was: the drag went nowhere.
      expect(find.text('0'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('0')).dy,
        0,
        reason: 'a locked scroller does not move under a drag',
      );
    });

    testWidgets('unlocked leaves it alone', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxScrollLock(locked: false, child: buildPage()),
        surfaceSize: const Size(300, 300),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // The 0th row has scrolled off the top.
      expect(find.text('0'), findsNothing);
    });

    testWidgets('whileModalIsOpen follows the modal layers', (
      tester,
    ) async {
      final overlay = AstryxOverlayController();
      addTearDown(overlay.dispose);

      ScrollPhysics? physics;

      await pumpAstryxWidget(
        tester,
        AstryxScrollLock.whileModalIsOpen(
          child: AstryxVStack(
            children: <Widget>[
              AstryxOverlay(
                controller: overlay,
                label: 'Panel',
                child: const AstryxCard(child: AstryxText('Modal')),
              ),
              // The physics *in scope* is what the lock changes, and reading it
              // here is the honest assertion: a drag would be eaten by the
              // scrim, which proves something else entirely.
              Builder(
                builder: (context) {
                  physics = ScrollConfiguration.of(
                    context,
                  ).getScrollPhysics(context);
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        surfaceSize: const Size(400, 400),
      );

      expect(physics, isNot(isA<NeverScrollableScrollPhysics>()));

      overlay.show();
      await tester.pumpAndSettle();
      expect(physics, isA<NeverScrollableScrollPhysics>());

      overlay.hide();
      await tester.pumpAndSettle();
      expect(physics, isNot(isA<NeverScrollableScrollPhysics>()));
    });

    testWidgets('a popover is not a modal, and does not lock', (tester) async {
      ScrollPhysics? physics;

      await pumpAstryxWidget(
        tester,
        AstryxScrollLock.whileModalIsOpen(
          child: AstryxVStack(
            children: <Widget>[
              AstryxPopover(
                label: 'Filters',
                content: const AstryxText('Panel'),
                triggerBuilder: (context, controller) => AstryxButton(
                  label: 'Filters',
                  onPressed: controller.toggle,
                ),
              ),
              Builder(
                builder: (context) {
                  physics = ScrollConfiguration.of(
                    context,
                  ).getScrollPhysics(context);
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        surfaceSize: const Size(400, 400),
      );

      await tester.tap(find.bySemanticsLabel('Filters').first);
      await tester.pumpAndSettle();

      // The popover is open and dismissible, so it is in the stack — but it
      // makes no claim that the page is inert, so the page keeps scrolling.
      expect(AstryxOverlayStack.openLayers.value, 1);
      expect(AstryxOverlayStack.modalLayers.value, 0);
      expect(physics, isNot(isA<NeverScrollableScrollPhysics>()));
    });
  });

  group('AstryxOverlayStack.openLayers', () {
    testWidgets('counts the open dismissible layers', (tester) async {
      final overlay = AstryxOverlayController();
      addTearDown(overlay.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxOverlay(
          controller: overlay,
          label: 'Panel',
          child: const AstryxCard(child: AstryxText('Modal')),
        ),
        surfaceSize: const Size(300, 300),
      );

      expect(AstryxOverlayStack.openLayers.value, 0);

      overlay.show();
      await tester.pumpAndSettle();
      expect(AstryxOverlayStack.openLayers.value, 1);

      overlay.hide();
      await tester.pumpAndSettle();
      expect(AstryxOverlayStack.openLayers.value, 0);
    });
  });
}
