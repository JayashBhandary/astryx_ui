import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The rest of the chat group: tokens, citations, tool calls, markdown, and the
/// composer's two controls.
void main() {
  group('AstryxTokenChip', () {
    testWidgets('names its remove button after the token', (tester) async {
      var removed = 0;

      await pumpAstryxWidget(
        tester,
        AstryxTokenChip('deploy-log.txt', onRemove: () => removed++),
        surfaceSize: const Size(400, 120),
      );

      // Not "Remove": a row of five identical names is a row a screen-reader
      // user cannot choose from.
      await tester.tap(find.bySemanticsLabel('Remove deploy-log.txt'));
      await tester.pumpAndSettle();

      expect(removed, 1);
    });

    testWidgets('is a button only when it has something to do', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxTokenChip('ada'),
        surfaceSize: const Size(400, 120),
      );

      expect(find.bySemanticsLabel('ada'), findsWidgets);
      // Nothing to press, so nothing to press *with*: no gesture detector, and
      // no button in the semantics tree.
      expect(
        find.descendant(
          of: find.byType(AstryxTokenChip),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
      handle.dispose();
    });
  });

  group('AstryxTokenizer', () {
    testWidgets('Enter commits the draft as a token', (tester) async {
      var values = <String>[];

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTokenizer(
            label: 'Recipients',
            values: values,
            onChanged: (next) => setState(() => values = next),
          ),
        ),
        surfaceSize: const Size(500, 200),
      );

      await tester.enterText(find.byType(EditableText), 'ada@example.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(values, <String>['ada@example.com']);
      expect(find.text('ada@example.com'), findsOneWidget);
    });

    testWidgets('a delimiter splits a paste into several', (tester) async {
      var values = <String>[];

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTokenizer(
            label: 'Recipients',
            values: values,
            onChanged: (next) => setState(() => values = next),
          ),
        ),
        surfaceSize: const Size(500, 200),
      );

      await tester.enterText(find.byType(EditableText), 'a@x.com,b@x.com,');
      await tester.pumpAndSettle();

      expect(values, <String>['a@x.com', 'b@x.com']);
    });

    testWidgets('a duplicate is dropped rather than added twice', (
      tester,
    ) async {
      var values = <String>['ada'];
      var calls = 0;

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTokenizer(
            label: 'Tags',
            values: values,
            onChanged: (next) => setState(() {
              values = next;
              calls++;
            }),
          ),
        ),
        surfaceSize: const Size(500, 200),
      );

      await tester.enterText(find.byType(EditableText), 'ada');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(calls, 0);
      expect(values, <String>['ada']);
    });

    testWidgets('validate refuses a candidate and keeps the text', (
      tester,
    ) async {
      var values = <String>[];

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTokenizer(
            label: 'Recipients',
            values: values,
            validate: (candidate) => candidate.contains('@'),
            onChanged: (next) => setState(() => values = next),
          ),
        ),
        surfaceSize: const Size(500, 200),
      );

      await tester.enterText(find.byType(EditableText), 'not-an-address');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(values, isEmpty);
      // The text stays, so the user can see what was refused and fix it.
      expect(find.text('not-an-address'), findsOneWidget);
    });

    testWidgets('backspace on an empty draft takes the last token back', (
      tester,
    ) async {
      var values = <String>['ada', 'grace'];

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxTokenizer(
            label: 'Tags',
            values: values,
            autofocus: true,
            onChanged: (next) => setState(() => values = next),
          ),
        ),
        surfaceSize: const Size(500, 200),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      expect(values, <String>['ada']);
    });
  });

  group('AstryxChatTokenizedText', () {
    testWidgets('draws chips and announces the whole sentence', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxChatTokenizedText(
          'Ask @ada about deploy-log.txt',
          tokens: <String, AstryxTextToken>{
            '@ada': AstryxTextToken(),
            'deploy-log.txt': AstryxTextToken(),
          },
        ),
        surfaceSize: const Size(600, 200),
      );

      expect(find.byType(AstryxTokenChip), findsNWidgets(2));
      // The sentence, not the chips: a control announced mid-sentence is a
      // sentence nobody can follow.
      expect(
        find.bySemanticsLabel('Ask @ada about deploy-log.txt'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('matches the longest run first', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxChatTokenizedText(
          'Ask @adam',
          tokens: <String, AstryxTextToken>{
            '@ada': AstryxTextToken(),
            '@adam': AstryxTextToken(),
          },
        ),
        surfaceSize: const Size(600, 200),
      );

      // One chip, and it is the long one: a shorter prefix must not chop the
      // longer mention in half.
      expect(find.byType(AstryxTokenChip), findsOneWidget);
      expect(find.text('@adam'), findsOneWidget);
    });
  });

  group('AstryxTokenTextController', () {
    test('reports the tokens present in the text, in order', () {
      final controller = AstryxTokenTextController(
        tokens: const <String, AstryxTextToken>{
          '@ada': AstryxTextToken(),
          '@grace': AstryxTextToken(),
        },
        text: 'Ask @grace, then @ada',
      );
      addTearDown(controller.dispose);

      expect(controller.present, <String>['@grace', '@ada']);
    });

    testWidgets('styles the token runs without adding widget spans', (
      tester,
    ) async {
      final controller = AstryxTokenTextController(
        tokens: const <String, AstryxTextToken>{'@ada': AstryxTextToken()},
        text: 'Ask @ada now',
      );
      addTearDown(controller.dispose);

      late TextSpan span;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            span = controller.buildTextSpan(
              context: context,
              withComposing: false,
            );
            return const SizedBox.shrink();
          },
        ),
        surfaceSize: const Size(400, 120),
      );

      final children = span.children ?? const <InlineSpan>[];
      // Every character still counts as itself: a `WidgetSpan` here would break
      // the caret, selection and backspace.
      expect(children.whereType<WidgetSpan>(), isEmpty);
      expect(children.length, 3);
      expect((children[1] as TextSpan).text, '@ada');
      expect((children[1] as TextSpan).style?.color, isNotNull);
      // The plain text is unchanged, so nothing about editing is surprising.
      expect(controller.text, 'Ask @ada now');
    });
  });

  group('AstryxCitation', () {
    testWidgets('names its source, not just its number', (tester) async {
      final handle = tester.ensureSemantics();
      var opened = 0;

      await pumpAstryxWidget(
        tester,
        AstryxCitation(
          1,
          source: 'scheduler/health.md',
          onPressed: () => opened++,
        ),
        surfaceSize: const Size(300, 120),
      );

      expect(
        find.bySemanticsLabel('Source 1: scheduler/health.md'),
        findsOneWidget,
      );

      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      expect(opened, 1);
      handle.dispose();
    });

    testWidgets('activates from the keyboard', (tester) async {
      var opened = 0;

      await pumpAstryxWidget(
        tester,
        Focus(
          autofocus: true,
          child: AstryxCitation(2, onPressed: () => opened++),
        ),
        surfaceSize: const Size(300, 120),
      );
      await tester.pumpAndSettle();

      // The marker's own node takes focus, so Enter reaches it.
      final node = tester
          .widget<Focus>(
            find.descendant(
              of: find.byType(AstryxCitation),
              matching: find.byType(Focus),
            ),
          )
          .focusNode;
      node?.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(opened, 1);
    });

    testWidgets('a citation with nothing to open is not a button', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxCitation(3),
        surfaceSize: const Size(300, 120),
      );

      expect(find.bySemanticsLabel('Source 3'), findsOneWidget);
      handle.dispose();
    });
  });

  group('AstryxChatSendButton', () {
    testWidgets('is inert with nothing to send, and sends with something', (
      tester,
    ) async {
      var sent = 0;

      await pumpAstryxWidget(
        tester,
        AstryxChatSendButton(onSend: () => sent++),
        surfaceSize: const Size(200, 120),
      );

      await tester.tap(find.bySemanticsLabel('Send'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(sent, 0);

      await pumpAstryxWidget(
        tester,
        AstryxChatSendButton(canSend: true, onSend: () => sent++),
        surfaceSize: const Size(200, 120),
      );
      await tester.tap(find.bySemanticsLabel('Send'));
      await tester.pumpAndSettle();
      expect(sent, 1);
    });

    testWidgets('becomes a stop control while generating', (tester) async {
      var stopped = 0;

      await pumpAstryxWidget(
        tester,
        AstryxChatSendButton(generating: true, onStop: () => stopped++),
        surfaceSize: const Size(200, 120),
      );

      expect(find.bySemanticsLabel('Send'), findsNothing);
      await tester.tap(find.bySemanticsLabel('Stop generating'));
      await tester.pumpAndSettle();

      expect(stopped, 1);
    });
  });

  group('AstryxChatDictationButton', () {
    testWidgets('the name follows the state', (tester) async {
      var started = 0;
      var stopped = 0;

      await pumpAstryxWidget(
        tester,
        AstryxChatDictationButton(onStart: () => started++),
        surfaceSize: const Size(200, 120),
      );
      await tester.tap(find.bySemanticsLabel('Dictate'));
      await tester.pumpAndSettle();
      expect(started, 1);

      await pumpAstryxWidget(
        tester,
        AstryxChatDictationButton(listening: true, onStop: () => stopped++),
        surfaceSize: const Size(200, 120),
      );
      await tester.tap(find.bySemanticsLabel('Stop dictating'));
      await tester.pumpAndSettle();
      expect(stopped, 1);
    });

    testWidgets('unavailable says why', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxChatDictationButton(
          enabled: false,
          unavailableReason: 'No microphone permission',
        ),
        surfaceSize: const Size(200, 120),
      );

      final button = tester.widget<AstryxIconButton>(
        find.byType(AstryxIconButton),
      );
      // A control dim for no stated reason is one a user assumes is broken.
      expect(button.tooltip, 'No microphone permission');
      expect(button.enabled, isFalse);
    });
  });

  group('AstryxChatSystemMessage', () {
    testWidgets('is announced as a system message', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxChatSystemMessage('The model changed'),
        surfaceSize: const Size(500, 160),
      );

      expect(find.bySemanticsLabel('System message'), findsOneWidget);
      expect(find.text('The model changed'), findsOneWidget);
      handle.dispose();
    });
  });

  group('AstryxChatToolCalls', () {
    const calls = <AstryxToolCall>[
      AstryxToolCall(
        name: 'search_logs',
        summary: 'Searched 412 lines',
        arguments: '{"query": "bind"}',
        result: '{"matches": 3}',
      ),
      AstryxToolCall(
        name: 'read_file',
        status: AstryxToolCallStatus.failed,
      ),
    ];

    testWidgets('summarises in the row and hides the payload', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxChatToolCalls(calls: calls),
        surfaceSize: const Size(600, 400),
      );

      expect(find.text('search_logs'), findsOneWidget);
      expect(find.text('Searched 412 lines'), findsOneWidget);
      // What a reader wants is "did it work", so the JSON starts closed.
      expect(find.textContaining('"query"'), findsNothing);

      await tester.tap(find.text('search_logs'));
      await tester.pumpAndSettle();

      expect(find.textContaining('"query"'), findsOneWidget);
    });

    testWidgets('every status is paired with its word', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxChatToolCalls(calls: calls),
        surfaceSize: const Size(600, 400),
      );

      // Colour is never the only signal: the status word is on the row.
      expect(find.text('Finished'), findsWidgets);
      expect(find.text('Failed'), findsWidgets);
    });

    testWidgets('nothing at all renders nothing', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxChatToolCalls(calls: <AstryxToolCall>[]),
        surfaceSize: const Size(400, 120),
      );

      expect(find.byType(AstryxCollapsible), findsNothing);
    });
  });

  group('AstryxMarkdown', () {
    testWidgets('renders the blocks it claims to', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxMarkdown('''
# The deploy failed

The health check timed out. See `scheduler/health`.

- Bound the port in 41 seconds
- Check gives up at 30

1. Raise the timeout
2. Fix the bind

> Worth reading the migration notes.

---

```dart
final ok = await check();
```
'''),
        surfaceSize: const Size(700, 900),
      );

      expect(find.byType(AstryxHeading), findsOneWidget);
      expect(find.textContaining('The health check timed out'), findsOneWidget);
      expect(find.text('•'), findsNWidgets(2));
      expect(find.text('1.'), findsOneWidget);
      expect(find.byType(AstryxBlockquote), findsOneWidget);
      expect(find.byType(AstryxDivider), findsOneWidget);
      expect(find.byType(AstryxCodeBlock), findsOneWidget);
      expect(find.textContaining('final ok = await check();'), findsOneWidget);
    });

    testWidgets('a heading level becomes the heading level', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxMarkdown('### Third level'),
        surfaceSize: const Size(500, 200),
      );

      // The level carries the size *and* the outline position, so there is
      // nothing for the renderer to choose.
      expect(
        tester.widget<AstryxHeading>(find.byType(AstryxHeading)).level,
        3,
      );
    });

    testWidgets('a link with nowhere to go is drawn as text', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxMarkdown('See [the notes](https://example.com).'),
        surfaceSize: const Size(500, 200),
      );

      // Looking like a control and not being one is the worse failure.
      expect(find.byType(AstryxLink), findsNothing);
      expect(find.textContaining('the notes'), findsOneWidget);
    });

    testWidgets('a link is followed when there is somewhere to go', (
      tester,
    ) async {
      final followed = <String>[];

      await pumpAstryxWidget(
        tester,
        AstryxMarkdown(
          'See [the notes](https://example.com).',
          onLinkPressed: followed.add,
        ),
        surfaceSize: const Size(500, 200),
      );

      await tester.tap(find.byType(AstryxLink));
      await tester.pumpAndSettle();

      expect(followed, <String>['https://example.com']);
    });

    testWidgets('a fenced block keeps its indentation', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxMarkdown('```\nif (x) {\n  y();\n}\n```'),
        surfaceSize: const Size(500, 300),
      );

      final block = tester.widget<AstryxCodeBlock>(
        find.byType(AstryxCodeBlock),
      );
      expect(block.code, 'if (x) {\n  y();\n}');
    });

    testWidgets('an unsupported table is text, not a broken table', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxMarkdown('| a | b |\n| --- | --- |\n| 1 | 2 |'),
        surfaceSize: const Size(500, 300),
      );

      // Absent rather than half-drawn — and it does not throw, which is the
      // part that matters for arbitrary model output.
      expect(tester.takeException(), isNull);
      expect(find.byType(AstryxTable), findsNothing);
    });
  });
}
