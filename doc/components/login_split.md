---
title: Split login
description: Sign-in beside a full-height panel.
component: true
group: Templates
source: example/lib/examples/template_login_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class LoginSplitTemplate extends StatelessWidget {
  const LoginSplitTemplate({super.key});

  /// Below this the split cannot hold: 340 for the form leaves the panel less
  /// room than one line of its heading needs.
  static const double _splitMinWidth = 560;

  @override
  Widget build(BuildContext context) {
    final form = AstryxCenter(
      paddingInline: AstryxSpacingToken.spacing6,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxHeading('Sign in', level: 1),
          const AstryxTextInput(
            label: 'Email',
            required: true,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const AstryxTextInput(
            label: 'Password',
            required: true,
            obscureText: true,
          ),
          AstryxButton(
            label: 'Sign in',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
    );

    // Two columns of one height: the form keeps its measure and the panel takes
    // the rest, so the split holds at every width down to `_splitMinWidth`.
    // Below that there is no split — the panel goes above the form, because a
    // 120-wide column of prose is not a panel, it is a stripe.
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth < _splitMinWidth
          ? AstryxVStack(
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                const _SplitPanel(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AstryxTheme.of(
                      context,
                    ).spacing(AstryxSpacingToken.spacing6),
                  ),
                  child: form,
                ),
              ],
            )
          : SizedBox(
              height: 460,
              child: AstryxHStack(
                align: AstryxStackAlign.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const Expanded(child: _SplitPanel()),
                  SizedBox(width: 340, child: form),
                ],
              ),
            ),
    );
  }
}
```


## One height, two columns

The form keeps a fixed measure — 340 — and the panel takes whatever is left through `Expanded`. That way the split holds at any width without a breakpoint: the form never gets too narrow to fill in, and the panel never squeezes the fields to make room for a sentence.

```text
SizedBox(height: 460)
└── AstryxHStack(align: stretch, mainAxisSize: max)
    ├── Expanded → the panel
    └── SizedBox(width: 340) → AstryxCenter → the fields
```

> **Careful**
>
> **Upstream puts a photograph in that panel; this one is a muted surface.** `Thumbnail`, `AspectRatio` and the image components are not ported, so rather than draw a grey rectangle and call it an image, the panel carries the one sentence the picture was carrying. The layout is the same; the content is honest about what the package can do today.

The panel’s fill comes from `AstryxColorToken.backgroundMuted` through `AstryxTheme.of(context)`, not from a `Color` literal — which is why it is still right in all eight themes and both brightnesses.

## Related

- [Login](login.md) — the single-column version, with every state.
- [Design tokens](../guides/tokens.md) — reaching a colour when no widget owns it.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Split login`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Split+login&component=Split+login) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Split+login&area=Split+login) — both templates arrive with the component filled in.
