import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example text_area_demo -> TextAreaDemoExample
class TextAreaDemoExample extends StatelessWidget {
  const TextAreaDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 380,
      child: AstryxTextArea(
        label: 'Notes',
        optional: true,
        placeholder: 'What happened?',
        description: 'Markdown is not interpreted.',
      ),
    );
  }
}
// #end

// #example text_area_lines -> TextAreaLinesExample
class TextAreaLinesExample extends StatelessWidget {
  const TextAreaLinesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The field grows from `minLines` and stops at `maxLines`, then scrolls.
    return const SizedBox(
      width: 380,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextArea(
            label: 'Two to four lines',
            minLines: 2,
            maxLines: 4,
            placeholder: 'Type until it stops growing…',
          ),
          AstryxTextArea(
            label: 'Fixed at four',
            minLines: 4,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
// #end

// #example text_area_counted -> TextAreaCountedExample
class TextAreaCountedExample extends StatefulWidget {
  const TextAreaCountedExample({super.key});

  @override
  State<TextAreaCountedExample> createState() => _TextAreaCountedExampleState();
}

class _TextAreaCountedExampleState extends State<TextAreaCountedExample> {
  static const int _limit = 140;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _limit - _controller.text.length;

    return SizedBox(
      width: 380,
      child: AstryxTextArea(
        label: 'Status message',
        controller: _controller,
        maxLength: _limit,
        minLines: 2,
        maxLines: 4,
        description: '$remaining characters left',
        status: remaining <= 20
            ? const AstryxFieldStatus.warning('Nearly at the limit')
            : null,
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
// #end
