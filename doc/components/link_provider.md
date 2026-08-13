---
title: AstryxLinkScope
description: How links navigate — supplied once, so components need not know the router.
component: true
group: Providers
source: lib/src/foundation/link_delegate.dart
upstream: LinkProvider
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream’s `LinkProvider` lets a consumer swap in their router: components call `useLinkComponent()` rather than rendering an `<a>`. This is the same seam. A widget with an `href` hands it to the delegate and never decides what navigation means.

**Navigation is the application’s concern.** The design system’s job is to leave a hole the right shape — one this package cannot fill, because it does not know whether you route with `Navigator`, `go_router`, or a URL launcher.

## Usage

```dart
AstryxApp(
  linkDelegate: AstryxLinkDelegate.fromCallback((uri, {target}) {
    if (uri.hasScheme) {
      launchUrl(uri);            // package:url_launcher
    } else {
      GoRouter.of(context).go(uri.toString());
    }
  }),
  home: const HomePage(),
)
```

Install it once on `AstryxApp` or `AstryxThemeProvider`. Wrap a subtree in `AstryxLinkScope` directly to override it for part of the app — a preview pane where links should do nothing, or an embedded document whose links resolve against another base.

```dart
class ProviderLinkExample extends StatefulWidget {
  const ProviderLinkExample({super.key});

  @override
  State<ProviderLinkExample> createState() => _ProviderLinkExampleState();
}

class _ProviderLinkExampleState extends State<ProviderLinkExample> {
  Uri? _followed;

  @override
  Widget build(BuildContext context) {
    // The delegate stands in for your router. This one records where a link
    // wanted to go; a real one would call `GoRouter.of(context).go(...)` or
    // `launchUrl`. The package never decides what following means.
    return AstryxLinkScope(
      delegate: AstryxLinkDelegate.fromCallback((uri, {target}) {
        setState(() => _followed = uri);
      }),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxLink('Billing settings', href: Uri.parse('/settings/billing')),
          AstryxLink(
            'Status page',
            href: Uri.parse('https://status.example.com'),
            external: true,
          ),
          AstryxText(
            _followed == null
                ? 'Nothing followed yet'
                : 'The delegate was handed $_followed',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
```


## The default

With no delegate installed, `AstryxLinkDelegate.none` applies: it warns in debug and does nothing in release. Doing nothing is the honest answer — guessing, by launching a URL or pushing a route, would be a surprising side effect from a package that knows nothing about your navigation.

> **Careful**
>
> `href` goes through the delegate; `onPressed` does not. A link with an `onPressed` calls it directly, which is the right choice for something that is not really a destination — opening a panel, revealing a row. Give a link one or the other, not both.

### AstryxLinkDelegate

Subclass it for anything with state — analytics, a confirmation before leaving a dirty form — or use the callback factory.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `followLink(uri, {target})` | `void` | — | Follows `uri`. `target` carries a hint about where to open, for the web; other platforms may ignore it. |
| `AstryxLinkDelegate.fromCallback(onFollow)` | `factory` | — | Builds one from a callback, which is what most apps want. |
| `AstryxLinkDelegate.none` | `static const` | — | The default: a debug warning, and nothing else. |
| `of(context)` | `AstryxLinkDelegate` | — | The delegate in scope, or `none` when there is none. |


### AstryxLinkScope

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `delegate` *(required)* | `AstryxLinkDelegate` | — | The delegate for this subtree. |
| `child` *(required)* | `Widget` | — | The subtree. |


## Related

- [AstryxLink](link.md) — the widget that calls the delegate.
- [AstryxBreadcrumbs](breadcrumbs.md) — a trail of them.

---

Something wrong with `AstryxLinkScope`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxLinkScope&component=AstryxLinkScope) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxLinkScope&area=AstryxLinkScope) — both templates arrive with the component filled in.
