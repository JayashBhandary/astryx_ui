import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The content primitives: inline code, the code block, the blockquote and the
/// key cap.
///
/// Each is mostly type and token, so what is tested is the part that is not:
/// what reaches the clipboard, what a screen reader is told, and what the line
/// numbers are kept out of.
void main() {
  group('AstryxCode', () {
    testWidgets('renders its data, and announces what it is told to', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxCode('#0064E0', semanticsLabel: 'hex 0064E0'),
      );

      expect(find.text('#0064E0'), findsOneWidget);
      expect(find.bySemanticsLabel('hex 0064E0'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('goes inside a sentence as a span', (tester) async {
      await pumpAstryxWidget(
        tester,
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'Pass '),
              AstryxCode.span('padding'),
              const TextSpan(text: ' a token.'),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('padding'), findsOneWidget);
    });
  });

  group('AstryxCodeBlock', () {
    const source = 'void main() {\n  runApp(const App());\n}';

    testWidgets('copies the whole block, not what is on screen', (
      tester,
    ) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied =
                (call.arguments as Map<Object?, Object?>)['text'] as String?;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await pumpAstryxWidget(
        tester,
        // Narrow enough that the second line is scrolled out of sight.
        const SizedBox(width: 180, child: AstryxCodeBlock(source)),
      );

      await tester.tap(find.byType(AstryxIconButton));
      await tester.pump();

      expect(copied, source);
    });

    testWidgets('the button says what happened, then stops saying it', (
      tester,
    ) async {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async => null,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await pumpAstryxWidget(tester, const AstryxCodeBlock(source));

      final before = tester.widget<AstryxIconButton>(
        find.byType(AstryxIconButton),
      );
      expect(before.label, 'Copy code');

      await tester.tap(find.byType(AstryxIconButton));
      await tester.pump();
      expect(
        tester.widget<AstryxIconButton>(find.byType(AstryxIconButton)).label,
        'Copied',
      );

      // And it goes back, so the next copy is still an offer rather than a
      // report of the last one.
      await tester.pump(const Duration(seconds: 3));
      expect(
        tester.widget<AstryxIconButton>(find.byType(AstryxIconButton)).label,
        'Copy code',
      );
    });

    testWidgets('the line numbers are decoration', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxCodeBlock(source, showLineNumbers: true),
      );

      expect(find.text('3'), findsOneWidget);
      // "1 2 3" is not the program, so a screen reader is not read it.
      expect(find.bySemanticsLabel('3'), findsNothing);
      handle.dispose();
    });

    testWidgets('scrolls sideways rather than wrapping, unless told to', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const SizedBox(width: 160, child: AstryxCodeBlock(source)),
      );
      expect(find.byType(Scrollable), findsWidgets);

      await pumpAstryxWidget(
        tester,
        const SizedBox(
          width: 160,
          child: AstryxCodeBlock(source, wrap: true, showCopy: false),
        ),
      );
      expect(find.byType(Scrollable), findsNothing);
    });
  });

  group('AstryxBlockquote', () {
    testWidgets('shows the quotation and its source', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxBlockquote(
          'The deploy took eleven minutes.',
          attribution: 'Postmortem, 3 March',
        ),
      );

      expect(find.text('The deploy took eleven minutes.'), findsOneWidget);
      // The em dash is the widget's, not the caller's.
      expect(find.text('— Postmortem, 3 March'), findsOneWidget);
    });

    testWidgets('a child replaces the quoted text', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxBlockquote(
          '',
          child: AstryxCodeBlock('exit 1', showCopy: false),
        ),
      );

      expect(find.text('exit 1'), findsOneWidget);
    });
  });

  group('AstryxKbd', () {
    testWidgets('a chord is one node, read as words', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxKbd.chord(<String>['Ctrl', 'K']),
      );

      expect(find.text('Ctrl'), findsOneWidget);
      expect(find.text('K'), findsOneWidget);
      // One node for the shortcut, not one per cap.
      expect(find.bySemanticsLabel('Ctrl K'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('semanticsLabel replaces unreadable glyphs', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxKbd.chord(
          <String>['⌘', 'K'],
          semanticsLabel: 'Command K',
        ),
      );

      expect(find.bySemanticsLabel('Command K'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('a single key needs no list', (tester) async {
      await pumpAstryxWidget(tester, AstryxKbd('K', size: AstryxKbdSize.sm));

      expect(find.text('K'), findsOneWidget);
    });
  });
}
