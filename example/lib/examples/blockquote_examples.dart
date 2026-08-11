import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example blockquote_demo -> BlockquoteDemoExample
class BlockquoteDemoExample extends StatelessWidget {
  const BlockquoteDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxBlockquote(
      'The deploy took eleven minutes and nobody could tell why until we read '
      'the logs in the wrong order and found it by accident.',
      attribution: 'Incident 412, postmortem',
    );
  }
}
// #end

// #example blockquote_child -> BlockquoteChildExample
class BlockquoteChildExample extends StatelessWidget {
  const BlockquoteChildExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A long quotation is not always one paragraph of plain text. `child`
    // takes anything — here the command the report is quoting.
    return const AstryxBlockquote(
      '',
      attribution: 'Runbook, step 4',
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(
            'Drain the node before restarting it, or in-flight requests are '
            'dropped:',
            color: AstryxTextColor.secondary,
          ),
          AstryxCodeBlock(
            'kubectl drain node-7 --ignore-daemonsets',
            language: 'bash',
          ),
        ],
      ),
    );
  }
}
// #end

// #example kbd_demo -> KbdDemoExample
class KbdDemoExample extends StatelessWidget {
  const KbdDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxKbd('K'),
        const AstryxKbd.chord(<String>['Ctrl', 'K']),
        const AstryxKbd.chord(
          <String>['⌘', '⇧', 'P'],
          // A string of symbols is not a shortcut anyone can follow.
          semanticsLabel: 'Command Shift P',
        ),
      ],
    );
  }
}
// #end

// #example kbd_in_context -> KbdInContextExample
class KbdInContextExample extends StatelessWidget {
  const KbdInContextExample({super.key});

  @override
  Widget build(BuildContext context) {
    // What a key cap is usually for: the shortcut beside the thing it does.
    return AstryxList(
      label: 'Shortcuts',
      density: AstryxItemDensity.compact,
      children: <Widget>[
        for (final shortcut in const <List<String>>[
          <String>['Search', 'K'],
          <String>['New deploy', 'D'],
          <String>['Command palette', 'P'],
        ])
          AstryxItem(
            label: shortcut[0],
            trailing: AstryxKbd.chord(
              <String>['Ctrl', shortcut[1]],
              size: AstryxKbdSize.sm,
            ),
          ),
      ],
    );
  }
}
// #end
