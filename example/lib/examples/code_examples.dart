import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example code_demo -> CodeDemoExample
class CodeDemoExample extends StatelessWidget {
  const CodeDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxCode('AstryxSpacingToken.spacing4'),
        AstryxCode('--color-accent'),
        AstryxCode('flutter pub get'),
      ],
    );
  }
}
// #end

// #example code_span -> CodeSpanExample
class CodeSpanExample extends StatelessWidget {
  const CodeSpanExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Flutter has no inline element, so a widget cannot sit inside a string.
    // `AstryxCode.span` is the bridge: a `WidgetSpan` that lines up with the
    // sentence around it.
    return Text.rich(
      TextSpan(
        style: AstryxTheme.of(context).textStyle(AstryxTypeRole.body),
        children: <InlineSpan>[
          const TextSpan(text: 'Every gap comes from a token — pass '),
          AstryxCode.span('AstryxSpacingToken.spacing3'),
          const TextSpan(text: ' to '),
          AstryxCode.span('gap'),
          const TextSpan(text: ', never a number.'),
        ],
      ),
    );
  }
}
// #end

// #example code_block_demo -> CodeBlockDemoExample
class CodeBlockDemoExample extends StatelessWidget {
  const CodeBlockDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxCodeBlock('''
AstryxCard(
  header: const AstryxHeading('Usage', level: 4),
  child: const AstryxText('4,201 requests this month.'),
)''', language: 'dart');
  }
}
// #end

// #example code_block_numbers -> CodeBlockNumbersExample
class CodeBlockNumbersExample extends StatelessWidget {
  const CodeBlockNumbersExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The numbers are decoration: not copied with the code, not read aloud.
    // A long line scrolls sideways rather than wrapping, because in code a
    // line break is not a neutral event.
    return const AstryxCodeBlock(
      'void main() {\n'
      '  runApp(AstryxApp(title: '
      "'My internal tool', home: const HomePage()));\n"
      '}',
      language: 'dart',
      showLineNumbers: true,
    );
  }
}
// #end
