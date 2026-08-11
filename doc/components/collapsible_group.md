---
title: AstryxCollapsibleGroup
description: Several collapsibles as one section, optionally an accordion.
component: true
group: Overlays
source: lib/src/components/overlay/collapsible_group.dart
upstream: CollapsibleGroup
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CollapsibleGroupDemoExample extends StatelessWidget {
  const CollapsibleGroupDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The default: sections divided into one block, each owning its own state.
    // Two can be open at once, which is what makes them comparable.
    return const SizedBox(
      width: 380,
      child: AstryxCollapsibleGroup(
        children: <AstryxCollapsible>[
          AstryxCollapsible(
            title: 'Billing',
            description: 'Plan, invoices and payment method',
            child: AstryxText('Team plan · renews 4 April · Visa ···· 4242'),
          ),
          AstryxCollapsible(
            title: 'Members',
            description: '12 people, 3 pending invitations',
            child: AstryxText('Owners: Ada, Priya. Everyone else can deploy.'),
          ),
          AstryxCollapsible(
            title: 'Audit log',
            description: 'Everything anyone changed',
            child: AstryxText('Retained for 90 days on this plan.'),
          ),
        ],
      ),
    );
  }
}
```


## Usage

```dart
AstryxCollapsibleGroup(
  children: <AstryxCollapsible>[
    AstryxCollapsible(title: 'Billing', child: BillingPanel()),
    AstryxCollapsible(title: 'Members', child: MembersPanel()),
  ],
)
```

By default the group is only presentation: rules between the sections, so they read as a list rather than a pile of unrelated headers. Each section still owns its own state, and two can be open at once.

## Exclusive — the accordion

`exclusive: true` moves ownership to the group: opening one section closes the last, and `onChanged` reports which index is open, or null when they are all shut.

```dart
class CollapsibleGroupExclusiveExample extends StatefulWidget {
  const CollapsibleGroupExclusiveExample({super.key});

  @override
  State<CollapsibleGroupExclusiveExample> createState() =>
      _CollapsibleGroupExclusiveExampleState();
}

class _CollapsibleGroupExclusiveExampleState
    extends State<CollapsibleGroupExclusiveExample> {
  int? _open = 0;

  @override
  Widget build(BuildContext context) {
    // An accordion: the group owns which section is open, so opening one closes
    // the last. `onChanged` reports the index, or null when they are all shut.
    return SizedBox(
      width: 380,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxCollapsibleGroup(
            exclusive: true,
            initialIndex: 0,
            onChanged: (index) => setState(() => _open = index),
            children: const <AstryxCollapsible>[
              AstryxCollapsible(
                title: 'Shipping address',
                child: AstryxText('12 Hanover Square, London'),
              ),
              AstryxCollapsible(
                title: 'Delivery window',
                child: AstryxText('Tuesday, between 09:00 and 13:00'),
              ),
              AstryxCollapsible(
                title: 'Payment',
                child: AstryxText('Visa ···· 4242, expires 11/28'),
              ),
            ],
          ),
          AstryxText(
            'Open section: ${_open ?? 'none'}',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
```


> **Careful**
>
> Exclusive is not the default, and should not be your default either. It saves vertical space by removing the one thing a set of sections is good for — comparing two of them. Use it where the panels are long enough that two open at once is worse than switching.

### AstryxCollapsibleGroup

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `children` *(required)* | `List<AstryxCollapsible>` | — | The sections, in order. |
| `exclusive` | `bool` | `false` | Whether opening one section closes the others. |
| `initialIndex` | `int?` | — | Which section starts open when `exclusive`. Null opens none. |
| `divided` | `bool` | `true` | Whether to draw a rule between sections. |
| `onChanged` | `ValueChanged<int?>?` | — | Called with the index now open. Only fires for an exclusive group. |


## Related

- [AstryxCollapsible](collapsible.md) — one section, and where the header is documented.

