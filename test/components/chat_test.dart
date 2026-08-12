import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The chat group: the frame, the turns, the composer.
///
/// Each is tested on the thing that makes a chat UI feel wrong when it is
/// missing — a transcript that jumps, a turn nobody can attribute, a composer
/// that posts on the wrong key.
void main() {
  group('AstryxChatMessage', () {
    testWidgets('a user turn is a bubble; an assistant turn is not', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxChatMessageList(
          children: <Widget>[
            AstryxChatMessage(
              role: AstryxChatRole.user,
              child: AstryxText('What broke?'),
            ),
            AstryxChatMessage(child: AstryxText('The scheduler.')),
          ],
        ),
        surfaceSize: const Size(600, 300),
      );

      // Exactly one bubble: an answer is page content, and wrapping it in a
      // rounded box makes it read as an aside.
      expect(find.byType(DecoratedBox), findsOneWidget);
      expect(find.text('What broke?'), findsOneWidget);
      expect(find.text('The scheduler.'), findsOneWidget);
    });

    testWidgets('a turn is announced with who said it', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxChatMessage(
          author: 'Assistant',
          child: AstryxText('The scheduler.'),
        ),
        surfaceSize: const Size(600, 200),
      );

      // Two: the node that names the turn, and the visible author line.
      expect(find.bySemanticsLabel('Assistant'), findsWidgets);
      handle.dispose();
    });

    testWidgets('an unnamed turn still says which side it came from', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxChatMessage(
          role: AstryxChatRole.user,
          child: AstryxText('What broke?'),
        ),
        surfaceSize: const Size(600, 200),
      );

      // Layout says "you wrote this"; a screen reader cannot see layout.
      expect(find.bySemanticsLabel('You'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('actions are in the tree from the start, not on hover', (
      tester,
    ) async {
      var copied = 0;

      await pumpAstryxWidget(
        tester,
        AstryxChatMessage(
          author: 'Assistant',
          actions: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.copy,
              label: 'Copy',
              onPressed: () => copied++,
            ),
          ],
          child: const AstryxText('The scheduler.'),
        ),
        surfaceSize: const Size(600, 240),
      );

      // No pointer has been anywhere near it: the button is simply there.
      await tester.tap(find.bySemanticsLabel('Copy'));
      await tester.pumpAndSettle();

      expect(copied, 1);
    });

    testWidgets('a system turn is centred and quiet', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxChatMessage(
          role: AstryxChatRole.system,
          child: AstryxText('The model changed'),
        ),
        surfaceSize: const Size(600, 200),
      );

      expect(find.bySemanticsLabel('System message'), findsOneWidget);
      // Not a bubble: it is not a turn anybody took.
      expect(find.byType(DecoratedBox), findsNothing);
      handle.dispose();
    });

    testWidgets('the transcript names itself', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxChatMessageList(
          children: <Widget>[AstryxChatMessage(child: AstryxText('Hello'))],
        ),
        surfaceSize: const Size(600, 200),
      );

      expect(find.bySemanticsLabel('Conversation'), findsOneWidget);
      handle.dispose();
    });
  });

  group('AstryxChatComposer', () {
    late TextEditingController controller;
    late List<String> sent;

    setUp(() {
      controller = TextEditingController();
      sent = <String>[];
    });

    tearDown(() => controller.dispose());

    Widget build({
      bool generating = false,
      VoidCallback? onStop,
      bool submitOnEnter = true,
    }) => AstryxChatComposer(
      controller: controller,
      generating: generating,
      onStop: onStop,
      submitOnEnter: submitOnEnter,
      onSubmit: sent.add,
    );

    testWidgets('Enter sends the trimmed draft', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 200),
      );

      await tester.enterText(find.byType(EditableText), '  ship it  ');
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(sent, <String>['ship it']);
    });

    testWidgets('Shift+Enter does not send', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 200),
      );

      await tester.enterText(find.byType(EditableText), 'first line');
      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();

      expect(sent, isEmpty, reason: 'Shift+Enter is a newline');
    });

    testWidgets('an empty draft cannot be sent, by key or by button', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 200),
      );

      await tester.enterText(find.byType(EditableText), '   ');
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(sent, isEmpty, reason: 'a stray Enter must not post nothing');

      await tester.tap(find.bySemanticsLabel('Send'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(sent, isEmpty);
    });

    testWidgets('submitOnEnter: false leaves Enter to the field', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(submitOnEnter: false),
        surfaceSize: const Size(600, 200),
      );

      await tester.enterText(find.byType(EditableText), 'a paragraph');
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(sent, isEmpty);
    });

    testWidgets('the send control becomes stop while generating', (
      tester,
    ) async {
      var stopped = 0;

      await pumpAstryxWidget(
        tester,
        build(generating: true, onStop: () => stopped++),
        surfaceSize: const Size(600, 200),
      );

      expect(find.bySemanticsLabel('Send'), findsNothing);

      await tester.tap(find.bySemanticsLabel('Stop generating'));
      await tester.pumpAndSettle();

      expect(stopped, 1);
    });

    testWidgets('Enter does not send while generating', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(generating: true, onStop: () {}),
        surfaceSize: const Size(600, 200),
      );

      await tester.enterText(find.byType(EditableText), 'and another thing');
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(sent, isEmpty);
    });

    testWidgets('the field is named without being labelled on screen', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 200),
      );

      expect(find.bySemanticsLabel('Message'), findsOneWidget);
      expect(find.text('Message'), findsNothing);
      handle.dispose();
    });
  });

  group('AstryxChatLayout', () {
    List<Widget> turns(int count) => <Widget>[
      for (var i = 1; i <= count; i++)
        AstryxChatMessage(
          role: i.isOdd ? AstryxChatRole.user : AstryxChatRole.assistant,
          child: AstryxText('Turn $i'),
        ),
    ];

    Widget build({int count = 12, Widget? empty}) => AstryxChatLayout(
      messages: turns(count),
      empty: empty,
      composer: AstryxChatComposer(
        controller: TextEditingController(),
        onSubmit: (_) {},
      ),
    );

    testWidgets('opens on the newest turn', (tester) async {
      await pumpAstryxWidget(
        tester,
        // Long enough that the oldest turn is genuinely off-screen.
        build(count: 40),
        surfaceSize: const Size(700, 500),
      );
      await tester.pumpAndSettle();

      // Reversed, so the newest turn is at offset zero — visible without
      // scrolling, and without a post-frame jump to get there.
      expect(find.text('Turn 40'), findsOneWidget);
      expect(find.text('Turn 1'), findsNothing);
    });

    testWidgets('appending a turn does not move the view', (tester) async {
      var count = 12;

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxVStack(
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              SizedBox(
                height: 380,
                child: AstryxChatLayout(
                  messages: turns(count),
                  composer: AstryxButton(
                    label: 'Add a turn',
                    onPressed: () => setState(() => count++),
                  ),
                ),
              ),
            ],
          ),
        ),
        surfaceSize: const Size(700, 500),
      );
      await tester.pumpAndSettle();

      final scroll = tester.widget<Scrollable>(find.byType(Scrollable).first);
      final before = scroll.controller?.offset;

      await tester.tap(find.bySemanticsLabel('Add a turn'));
      await tester.pumpAndSettle();

      final after = tester
          .widget<Scrollable>(find.byType(Scrollable).first)
          .controller
          ?.offset;

      expect(after, before, reason: 'a growing transcript must not scroll');
      expect(find.text('Turn 13'), findsOneWidget);
    });

    testWidgets('the jump button appears only once scrolled away', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(count: 30),
        surfaceSize: const Size(700, 500),
      );
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Jump to latest'), findsNothing);

      // Dragging *down* in a reversed list walks back through the history.
      await tester.drag(find.byType(ListView), const Offset(0, 600));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Jump to latest'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Jump to latest'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Jump to latest'), findsNothing);
      expect(find.text('Turn 30'), findsOneWidget);
    });

    testWidgets('an empty conversation shows its empty state instead', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(count: 0, empty: const AstryxText('Ask me anything')),
        surfaceSize: const Size(700, 500),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ask me anything'), findsOneWidget);
      // No scroller, so a centred welcome is centred rather than sitting at the
      // bottom of a reversed list.
      expect(find.byType(ListView), findsNothing);
      expect(find.bySemanticsLabel('Jump to latest'), findsNothing);
    });

    testWidgets('the transcript reads oldest-first for a screen reader', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(count: 3),
        surfaceSize: const Size(700, 500),
      );
      await tester.pumpAndSettle();

      // The reversal is an implementation detail. What matters is the order on
      // screen — which is what semantics traversal follows — so that is what
      // this measures: oldest at the top, newest at the bottom.
      final first = tester.getTopLeft(find.text('Turn 1')).dy;
      final second = tester.getTopLeft(find.text('Turn 2')).dy;
      final third = tester.getTopLeft(find.text('Turn 3')).dy;

      expect(first, lessThan(second));
      expect(second, lessThan(third));
    });
  });
}
