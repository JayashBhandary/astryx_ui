---
title: AstryxStreamingText
description: Rendering text as it arrives token by token.
component: true
group: Hooks & controllers
source: lib/src/components/data/streaming_text.dart
upstream: useStreamingText
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HookStreamingTextExample extends StatefulWidget {
  const HookStreamingTextExample({super.key});

  @override
  State<HookStreamingTextExample> createState() =>
      _HookStreamingTextExampleState();
}

class _HookStreamingTextExampleState extends State<HookStreamingTextExample> {
  static const List<String> _chunks = <String>[
    'The deploy finished in 41 seconds. ',
    'Three services restarted, ',
    'and the health check passed on the first attempt.',
  ];

  String _text = '';
  int _next = 0;

  bool get _streaming => _next < _chunks.length;

  void _send() {
    if (!_streaming) {
      setState(() {
        _text = '';
        _next = 0;
      });
      return;
    }
    setState(() {
      _text += _chunks[_next];
      _next++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Press "Send a chunk" a few times. Text arrives in bursts and is revealed
    // at a steady rate, so it reads as typing rather than twitching — and the
    // caret says more is coming.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxCard(
          child: _text.isEmpty
              ? const AstryxText(
                  'Nothing yet',
                  color: AstryxTextColor.secondary,
                )
              : AstryxStreamingText(
                  _text,
                  streaming: _streaming,
                  charactersPerSecond: 40,
                ),
        ),
        AstryxButton(
          label: _streaming ? 'Send a chunk' : 'Start again',
          onPressed: _send,
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxStreamingText(
  _answer,                 // grows as chunks arrive
  streaming: _isStreaming, // false once the response ends
)
```

A model’s output does not arrive smoothly: it comes in bursts of a few tokens with pauses between them, and rendering each burst the instant it lands reads as stuttering. This reveals what has arrived at a constant rate, so the text appears to be typed rather than to twitch.

Hand it the whole text you have so far on every build. It tracks how much of that is already on screen, so there is no buffer to manage and no chunk boundary to remember.

## It never rewinds

More text extends what is shown. Text that is *not* a continuation of what was shown is a rewrite rather than a stream — a retry, a correction — and is swapped in whole, because a caret walking backwards over a sentence is a bug nobody can read past.

> **Accessibility**
>
> **The whole text is the accessible name from the first frame**, not the part that happens to be on screen. A live region firing per token would restart the sentence eighty times a second, which is not a reading experience — it is a denial of one. The partial text is excluded from semantics and the node carries the complete string, so a screen-reader user gets the answer once, in full.

> **Note**
>
> Under reduced motion everything that has arrived is shown at once. The caret is static rather than blinking, for the same reason: a blink is a second animation that would have to be suppressed, and the caret’s job — "there is more coming" — it does standing still.

### AstryxStreamingText

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `text` *(required)* | `String` | — | Everything that has arrived so far. |
| `streaming` | `bool` | `true` | Whether more is expected. Only affects the caret — the reveal is driven by `text` either way. |
| `charactersPerSecond` | `double` | `80` | How fast text is revealed. 80 is a little faster than a fast typist and slow enough to read along with. |
| `showCaret` | `bool` | `true` | Whether to draw a caret while there is more to come. |
| `semanticsLabel` | `String?` | — | What a screen reader announces. Defaults to the whole of `text`. |
| `onCompleted` | `VoidCallback?` | — | Called once the screen matches what has arrived — which is not the same as the response being over. |


## Related

- [AstryxSpinner](spinner.md) — the wait *before* the first token.
- [AstryxSkeleton](skeleton.md) — a wait whose result has a known shape.
- [AstryxText](text.md) — everything about type and colour.

