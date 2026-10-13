---
title: Routes & navigation
description: Page transitions, dialogs and sheets that return a result, and the back button.
group: Getting started
source: lib/src/app/page_route.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Every route `AstryxApp` builds — `home`, `routes`, `initialRoute` — is an `AstryxPageRoute`, the counterpart of `MaterialPageRoute`. It paints the page on `--color-background-body` and animates with the platform’s transition: a slide with a swipe back from the leading edge on iOS and macOS, a short fade-and-rise everywhere else.

```dart
class PageRouteDemoExample extends StatefulWidget {
  const PageRouteDemoExample({super.key});

  @override
  State<PageRouteDemoExample> createState() => _PageRouteDemoExampleState();
}

class _PageRouteDemoExampleState extends State<PageRouteDemoExample> {
  AstryxPageTransition _transition = AstryxPageTransition.fade;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxRadioList<AstryxPageTransition>(
          label: 'Transition',
          orientation: AstryxRadioListOrientation.horizontal,
          value: _transition,
          onChanged: (value) => setState(() => _transition = value),
          options: <AstryxRadioOption<AstryxPageTransition>>[
            for (final transition in AstryxPageTransition.values)
              AstryxRadioOption(value: transition, label: transition.name),
          ],
        ),
        // A navigator of its own, so the demo pages move inside the frame.
        // In an app, `AstryxApp` builds every route as an AstryxPageRoute.
        SizedBox(
          width: 360,
          height: 200,
          child: ClipRect(
            child: AstryxPageTransitionScope(
              transition: _transition,
              child: Navigator(
                key: ValueKey<AstryxPageTransition>(_transition),
                onGenerateRoute: (settings) => AstryxPageRoute<void>(
                  settings: settings,
                  builder: (_) => const _DemoPage(depth: 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DemoPage extends StatelessWidget {
  const _DemoPage({required this.depth});

  final int depth;

  @override
  Widget build(BuildContext context) {
    return AstryxCenter(
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.center,
        children: <Widget>[
          AstryxHeading('Page $depth'),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              if (depth > 1)
                AstryxButton(
                  label: 'Back',
                  onPressed: () => Navigator.pop(context),
                ),
              AstryxButton(
                label: 'Open page ${depth + 1}',
                variant: AstryxButtonVariant.primary,
                onPressed: () => Navigator.push(
                  context,
                  AstryxPageRoute<void>(
                    builder: (_) => _DemoPage(depth: depth + 1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


## Choosing the transition

```dart
AstryxApp(
  pageTransition: AstryxPageTransition.slide, // or fade, none; null = platform
  home: const HomePage(),
)

// One route only:
Navigator.of(context).push(
  AstryxPageRoute<void>(
    transition: AstryxPageTransition.none,
    builder: (context) => const DetailPage(),
  ),
);
```

With `go_router` or `Navigator.pages`, use `AstryxPage` — the counterpart of `MaterialPage`. Under reduced motion no transition runs.

## Results

| Function | Completes with |
| --- | --- |
| `showAstryxDialog<T>` | The value it is popped with; null for close, barrier, Escape, back. |
| `showAstryxAlertDialog` | `true` for confirm; `false` for cancel, Escape and back. |
| `showAstryxBottomSheet<T>` | The value it is popped with; null for drag, barrier, Escape, back. |

## The back button

A route-based dialog or sheet closes on the system back button like any route. The widget-in-the-tree overlays — `AstryxDialog`, `AstryxBottomSheet`, menus, popovers — do too: while one is open its page will not pop, and back closes the top-most layer instead, exactly as Escape does. A tooltip does not hold back up.

## Related

- [AstryxDialog](../components/dialog.md), [AstryxAlertDialog](../components/alert_dialog.md) and [AstryxBottomSheet](../components/bottom_sheet.md) — the panels these routes show.
- [Motion](motion.md) — the durations the transitions use.

---

Something wrong with this page, or missing from it? [Report a problem](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Docs%3A+Routes+%26+navigation&component=Docs%3A+Routes+%26+navigation) · [Suggest a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Docs%3A+Routes+%26+navigation&area=Docs%3A+Routes+%26+navigation) — both templates arrive with the page filled in.
