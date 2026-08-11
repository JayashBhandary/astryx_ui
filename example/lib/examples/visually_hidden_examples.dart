import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example visually_hidden_live -> VisuallyHiddenLiveExample
class VisuallyHiddenLiveExample extends StatefulWidget {
  const VisuallyHiddenLiveExample({super.key});

  @override
  State<VisuallyHiddenLiveExample> createState() =>
      _VisuallyHiddenLiveExampleState();
}

class _VisuallyHiddenLiveExampleState extends State<VisuallyHiddenLiveExample> {
  static const int _limit = 40;

  final TextEditingController _controller = TextEditingController();
  int _remaining = _limit;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The count is the announcement. There is no widget it could be the name
    // of — the input is already named "Summary" — so the only way to report it
    // is a region of its own.
    final announcement = '$_remaining characters remaining';

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTextInput(
          label: 'Summary',
          controller: _controller,
          maxLength: _limit,
          placeholder: 'What changed, in one line',
          onChanged: (value) =>
              setState(() => _remaining = _limit - value.length),
        ),
        AstryxVisuallyHidden(
          liveRegion: true,
          child: Text(announcement),
        ),
        // The same string, painted, so this page can show what is otherwise
        // only audible. A real form would not draw it twice.
        AstryxText(
          'A screen reader hears: “$announcement”',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example visually_hidden_space -> VisuallyHiddenSpaceExample
class VisuallyHiddenSpaceExample extends StatelessWidget {
  const VisuallyHiddenSpaceExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The hidden child sits between the two badges and measures `Size.zero`,
    // so the row looks exactly as it would without it. A test pins that.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxBadge('Queued', variant: AstryxBadgeVariant.info),
        AstryxVisuallyHidden(
          child: Text('and it has been queued for eleven minutes'),
        ),
        AstryxBadge('Building', variant: AstryxBadgeVariant.warning),
      ],
    );
  }
}

// #end
