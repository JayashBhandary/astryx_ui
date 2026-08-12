---
title: Product detail
description: Gallery, price, options, and the add-to-cart action.
component: true
group: Templates
source: example/lib/examples/template_commerce_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ProductDetailTemplate extends StatefulWidget {
  const ProductDetailTemplate({super.key});

  @override
  State<ProductDetailTemplate> createState() => _ProductDetailTemplateState();
}

class _ProductDetailTemplateState extends State<ProductDetailTemplate> {
  static const List<String> _shots = <String>[
    'Three-quarter view',
    'Sole detail',
    'Heel counter',
    'In the box',
  ];

  /// Sizes, and the ones nobody can buy today.
  ///
  /// Out of stock is `enabled: false` on the option rather than a missing
  /// option: a size that vanishes leaves the reader wondering whether it ever
  /// existed, and it is the answer to "do you make my size at all".
  static const List<AstryxRadioOption<String>> _sizes =
      <AstryxRadioOption<String>>[
        AstryxRadioOption(value: '8', label: 'UK 8'),
        AstryxRadioOption(value: '9', label: 'UK 9'),
        AstryxRadioOption(
          value: '10',
          label: 'UK 10',
          description: 'Back in stock on 3 September',
          enabled: false,
        ),
        AstryxRadioOption(value: '11', label: 'UK 11'),
      ];

  static const int _price = 12500;

  int _shot = 0;
  String? _size;
  num? _quantity = 1;
  bool _submitted = false;

  final AstryxOverlayController _viewer = AstryxOverlayController();

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  /// Nothing is red until the reader has tried to add to the basket.
  AstryxFieldStatus? get _sizeStatus {
    if (!_submitted || _size != null) return null;
    return const AstryxFieldStatus.error('Choose a size');
  }

  void _add(BuildContext context) {
    setState(() => _submitted = true);
    if (_size == null) return;

    AstryxToastScope.of(context).show(
      AstryxToast(
        message: 'Added $_quantity × Trail Runner GTX, UK $_size to the basket',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxBreadcrumbs(
          label: 'You are here',
          items: <AstryxBreadcrumb>[
            AstryxBreadcrumb(label: 'Shop', onPressed: () {}),
            AstryxBreadcrumb(label: 'Footwear', onPressed: () {}),
            AstryxBreadcrumb(label: 'Trail', onPressed: () {}),
            const AstryxBreadcrumb(label: 'Trail Runner GTX'),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final media = _Media(
              shots: _shots,
              index: _shot,
              onSelected: (index) => setState(() => _shot = index),
              viewer: _viewer,
            );
            final details = _details(context);

            // One column below 720, because a picture and a form side by side
            // at 300 apiece is two things neither of which can be used.
            if (!wide) {
              return AstryxVStack(
                gap: AstryxSpacingToken.spacing5,
                align: AstryxStackAlign.stretch,
                children: <Widget>[media, details],
              );
            }

            return AstryxHStack(
              gap: AstryxSpacingToken.spacing6,
              align: AstryxStackAlign.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: media),
                SizedBox(width: 340, child: details),
              ],
            );
          },
        ),
      ],
    );
  }

  /// The half of the screen that is words: what it costs, what to choose, and
  /// the one button that spends money.
  Widget _details(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxHeading('Trail Runner GTX', level: 1),
            // Both rows wrap. A details column is narrow by design, and a
            // price beside a was-price is exactly the pair that stops fitting
            // first — a spreading row here would overflow rather than reflow.
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              wrap: true,
              runGap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                // Figures are `tabularNumbers`, and the was-price is a
                // separate node rather than a strikethrough on the same one:
                // a screen reader reading "£125.00 £150.00" with no
                // explanation has said the wrong thing twice.
                AstryxText(
                  money(_price),
                  type: AstryxTextType.large,
                  weight: AstryxTextWeight.semibold,
                  tabularNumbers: true,
                ),
                AstryxText(
                  '${money(15000)} before the discount',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  tabularNumbers: true,
                ),
              ],
            ),
            const AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              wrap: true,
              runGap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxBadge(
                  'In stock',
                  variant: AstryxBadgeVariant.success,
                  icon: AstryxIcon(AstryxIconName.success),
                ),
                AstryxText(
                  'Free delivery over £50',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ],
        ),
        const AstryxDivider(),
        // Seven options or fewer, and all of them worth seeing at once, so a
        // radio list rather than a selector. A size hidden behind a dropdown
        // is a size the reader has to go looking for.
        AstryxRadioList<String>(
          label: 'Size',
          value: _size,
          status: _sizeStatus,
          required: true,
          orientation: AstryxRadioListOrientation.horizontal,
          onChanged: (value) => setState(() => _size = value),
          options: _sizes,
        ),
        AstryxNumberInput(
          label: 'Quantity',
          value: _quantity,
          min: 1,
          max: 6,
          integerOnly: true,
          width: 140,
          onChanged: (value) => setState(() => _quantity = value),
        ),
        AstryxButton(
          label: 'Add to basket · ${money(_price * (_quantity ?? 1).toInt())}',
          variant: AstryxButtonVariant.primary,
          size: AstryxButtonSize.lg,
          onPressed: () => _add(context),
        ),
        // Everything a reader might want and most will not: collapsed, in one
        // group, so the page below the button stays short enough to end.
        const AstryxCollapsibleGroup(
          children: <AstryxCollapsible>[
            AstryxCollapsible(
              title: 'Details',
              initiallyExpanded: true,
              child: AstryxText(
                'A waterproof trail shoe with a 6 mm drop and a rock plate. '
                'Weighs 284 g in a UK 9.',
              ),
            ),
            AstryxCollapsible(
              title: 'Delivery',
              child: AstryxText(
                'Next working day to the UK if ordered before 3pm. Two to '
                'four days to the EU.',
              ),
            ),
            AstryxCollapsible(
              title: 'Returns',
              child: AstryxText(
                'Sixty days, worn outdoors or not. Return postage is on us.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The half of the screen that is pictures: one large, the rest as a strip.
class _Media extends StatelessWidget {
  const _Media({
    required this.shots,
    required this.index,
    required this.onSelected,
    required this.viewer,
  });

  final List<String> shots;
  final int index;
  final ValueChanged<int> onSelected;
  final AstryxOverlayController viewer;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxCard(
          padding: AstryxSpacingToken.spacing0,
          semanticsLabel: '${shots[index]} — open the full-size viewer',
          onPressed: viewer.show,
          child: AstryxAspectRatio(
            ratio: 4 / 3,
            semanticsLabel: shots[index],
            child: Center(
              child: AstryxText(
                shots[index],
                color: AstryxTextColor.secondary,
              ),
            ),
          ),
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            for (var i = 0; i < shots.length; i++)
              AstryxThumbnail(
                label: shots[i],
                icon: AstryxIconName.viewColumns,
                width: 76,
                selected: i == index,
                onPressed: () => onSelected(i),
              ),
          ],
        ),
        AstryxLightbox(
          controller: viewer,
          initialIndex: index,
          label: 'Trail Runner GTX',
          items: <AstryxLightboxItem>[
            for (final shot in shots)
              AstryxLightboxItem(
                label: shot,
                caption: 'Trail Runner GTX · $shot',
                child: SizedBox(
                  width: 620,
                  child: AstryxAspectRatio(
                    ratio: 4 / 3,
                    background: AstryxColorToken.backgroundCard,
                    child: Center(
                      child: AstryxText(
                        shot,
                        color: AstryxTextColor.secondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
```

Press **Add to basket** without choosing a size to see the validation, then choose one. Narrow the window past 720 and the two columns become one.


## One button spends money

Everything else on the screen changes what is *shown*: a thumbnail, a size, a quantity, a collapsed section. Exactly one control commits the reader to anything, it is the only `primary` button on the page, and its label says what it is about to do — including the figure.

```dart
AstryxButton(
  label: 'Add to basket · ${money(_price * quantity)}',
  variant: AstryxButtonVariant.primary,
  size: AstryxButtonSize.lg,
  onPressed: () => _add(context),
)
```

## Validate on submit, not on arrival

Nothing is red until **Add to basket** has been pressed once. A page that marks the size field invalid before the reader has looked at it is telling them off for arriving — and the same rule the [login](login.md) template follows for exactly the same reason.

## Out of stock is disabled, not missing

The UK 10 option is `enabled: false` with a description saying when it comes back. Removing it instead would leave the reader wondering whether it ever existed — and "do you make my size at all" is a different question from "can I have it today".

Sizes are an [AstryxRadioList](radio_list.md) rather than an [AstryxSelector](selector.md): four options, all worth seeing at once. A size behind a dropdown is a size the reader has to go looking for.

## Figures

Every price is `tabularNumbers: true`, and the was-price is its own node with its own words — "£150.00 before the discount" — rather than a strikethrough on the same one. A screen reader given "£125.00 £150.00" with no explanation has said the wrong thing twice.

```text
AstryxVStack
├── AstryxBreadcrumbs
└── LayoutBuilder
    ├── wide   → AstryxHStack ── Expanded          → media
    │                         └── SizedBox(340)    → the details column
    └── narrow → AstryxVStack ── media, then details

media   = a large AstryxAspectRatio (pressable → AstryxLightbox)
          + a row of AstryxThumbnails
details = price · size · quantity · add · AstryxCollapsibleGroup
```

> **Note**
>
> The details below the button are an [AstryxCollapsibleGroup](collapsible_group.md) rather than three headings and three paragraphs. Everything a reader might want and most will not, collapsed, keeps the page below the primary action short enough to end.

> **Accessibility**
>
> The confirmation is a [toast](toast.md) that names what was added and how many — "Added 2 × Trail Runner GTX, UK 9 to the basket". A basket count that silently increments in a corner is a change half the readers of the page will not notice at all.

## Related

- [Product gallery](product_gallery.md) — where this page is opened from.
- [Payment form](payment_form.md) — the screen after the basket.
- [Side gallery](side_gallery.md) — the same media shape without a price beside it.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

