---
title: Product gallery
description: A filterable grid of products.
component: true
group: Templates
source: example/lib/examples/template_commerce_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One product on the wall.
typedef Product = ({
  String name,
  String category,
  int price,
  double rating,
  bool inStock,
});

class ProductGalleryTemplate extends StatefulWidget {
  const ProductGalleryTemplate({super.key});

  @override
  State<ProductGalleryTemplate> createState() => _ProductGalleryTemplateState();
}

class _ProductGalleryTemplateState extends State<ProductGalleryTemplate> {
  static const List<Product> _catalogue = <Product>[
    (
      name: 'Trail Runner GTX',
      category: 'Footwear',
      price: 12500,
      rating: 4.6,
      inStock: true,
    ),
    (
      name: 'Fell Shoe 3',
      category: 'Footwear',
      price: 9800,
      rating: 4.2,
      inStock: true,
    ),
    (
      name: 'Approach Mid',
      category: 'Footwear',
      price: 15900,
      rating: 4.8,
      inStock: false,
    ),
    (
      name: 'Windshell 40',
      category: 'Outerwear',
      price: 8400,
      rating: 4.1,
      inStock: true,
    ),
    (
      name: 'Hardshell Pro',
      category: 'Outerwear',
      price: 24000,
      rating: 4.9,
      inStock: true,
    ),
    (
      name: 'Merino Base',
      category: 'Layers',
      price: 5200,
      rating: 4.4,
      inStock: true,
    ),
    (
      name: 'Grid Fleece',
      category: 'Layers',
      price: 6900,
      rating: 4.0,
      inStock: false,
    ),
    (
      name: 'Summit Pack 32',
      category: 'Packs',
      price: 11000,
      rating: 4.5,
      inStock: true,
    ),
  ];

  final TextEditingController _query = TextEditingController();

  Set<String> _categories = <String>{};
  bool _inStockOnly = false;
  (num, num) _priceRange = (0, 250);
  String _sort = 'popular';

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// The wall does not filter itself.
  ///
  /// Filtering here, in the caller, is what lets the empty state tell "nothing
  /// matched" from "nothing to sell" — and those two need different words and
  /// a different way out.
  List<Product> get _results {
    final text = _query.text.trim().toLowerCase();
    final matches = _catalogue.where((product) {
      final inCategory =
          _categories.isEmpty || _categories.contains(product.category);
      final inPrice =
          product.price >= _priceRange.$1 * 100 &&
          product.price <= _priceRange.$2 * 100;
      final matchesText =
          text.isEmpty || product.name.toLowerCase().contains(text);
      return inCategory &&
          inPrice &&
          matchesText &&
          (!_inStockOnly || product.inStock);
    }).toList();

    return matches..sort(switch (_sort) {
      'price_low' => (a, b) => a.price.compareTo(b.price),
      'price_high' => (a, b) => b.price.compareTo(a.price),
      _ => (a, b) => b.rating.compareTo(a.rating),
    });
  }

  void _clear() => setState(() {
    _categories = <String>{};
    _inStockOnly = false;
    _priceRange = (0, 250);
    _query.clear();
  });

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        panelSide: AstryxLayoutPanelSide.start,
        panelWidth: 230,
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                const AstryxHeading('Shop', level: 1),
                AstryxText(
                  '${results.length} of ${_catalogue.length} products',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                SizedBox(
                  width: 220,
                  child: AstryxTextInput(
                    controller: _query,
                    label: 'Search products',
                    labelHidden: true,
                    placeholder: 'Search products',
                    showClear: true,
                    size: AstryxInputSize.sm,
                    leading: const AstryxIcon(
                      AstryxIconName.search,
                      size: AstryxIconSize.sm,
                    ),
                  ),
                ),
                // A selector, because it picks a value and shows the current
                // one. A menu would perform an action and report nothing.
                SizedBox(
                  width: 180,
                  child: AstryxSelector<String>(
                    label: 'Sort by',
                    labelHidden: true,
                    value: _sort,
                    size: AstryxInputSize.sm,
                    onChanged: (value) =>
                        setState(() => _sort = value ?? _sort),
                    options: const <AstryxSelectorOption<String>>[
                      AstryxSelectorOption(
                        value: 'popular',
                        label: 'Best rated',
                      ),
                      AstryxSelectorOption(
                        value: 'price_low',
                        label: 'Price: low to high',
                      ),
                      AstryxSelectorOption(
                        value: 'price_high',
                        label: 'Price: high to low',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        panel: AstryxVStack(
          gap: AstryxSpacingToken.spacing5,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Flexible(child: AstryxHeading('Filters')),
                AstryxButton(
                  label: 'Clear',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  onPressed: _clear,
                ),
              ],
            ),
            AstryxCheckboxList<String>(
              label: 'Category',
              values: _categories,
              onChanged: (values) => setState(() => _categories = values),
              options: const <AstryxCheckboxOption<String>>[
                AstryxCheckboxOption(value: 'Footwear', label: 'Footwear'),
                AstryxCheckboxOption(value: 'Outerwear', label: 'Outerwear'),
                AstryxCheckboxOption(value: 'Layers', label: 'Layers'),
                AstryxCheckboxOption(value: 'Packs', label: 'Packs'),
              ],
            ),
            AstryxSlider.range(
              label: 'Price',
              values: _priceRange,
              max: 250,
              step: 10,
              formatValue: (value) => '£${value.round()}',
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            // A checkbox, not a switch — but there is no Save button here, so
            // the rule needs saying out loud: this filter *is* applied
            // immediately, and it is a checkbox because it is one of a set of
            // filters rather than a setting of its own.
            AstryxCheckbox(
              label: 'In stock only',
              value: _inStockOnly,
              onChanged: (value) => setState(() => _inStockOnly = value),
            ),
          ],
        ),
        child: results.isEmpty
            ? AstryxEmptyState(
                title: 'Nothing matches those filters',
                description:
                    'Every product is still here — the filters are what is '
                    'hiding them.',
                icon: const AstryxIcon(
                  AstryxIconName.funnel,
                  size: AstryxIconSize.lg,
                ),
                actions: <Widget>[
                  AstryxButton(
                    label: 'Clear filters',
                    variant: AstryxButtonVariant.primary,
                    onPressed: _clear,
                  ),
                ],
              )
            : AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                wrap: true,
                runGap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.start,
                children: <Widget>[
                  for (final product in results) _ProductTile(product: product),
                ],
              ),
      ),
    );
  }
}

/// One product: a picture, a name, a price, and whether it can be bought.
class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: AstryxCard(
        padding: AstryxSpacingToken.spacing3,
        // One sentence, once. The three lines below are what a sighted reader
        // assembles for themselves; a screen reader is handed the assembled
        // version instead of hearing four separate nodes.
        semanticsLabel:
            '${product.name}, ${money(product.price)}, rated '
            '${product.rating} out of 5'
            '${product.inStock ? '' : ', out of stock'}',
        onPressed: () {},
        footer: AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxText(product.name, type: AstryxTextType.label, maxLines: 1),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: AstryxText(
                    money(product.price),
                    tabularNumbers: true,
                    maxLines: 1,
                  ),
                ),
                AstryxText(
                  '★ ${product.rating}',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  tabularNumbers: true,
                ),
              ],
            ),
            if (!product.inStock)
              const AstryxBadge(
                'Out of stock',
                variant: AstryxBadgeVariant.warning,
                icon: AstryxIcon(AstryxIconName.warning),
              ),
          ],
        ),
        child: AstryxAspectRatio(
          ratio: 1,
          semanticsLabel: product.name,
          child: const Center(
            child: AstryxIcon(AstryxIconName.viewColumns),
          ),
        ),
      ),
    );
  }
}
```

Drag the price range down to nothing to see the empty state, which offers the way out rather than describing the problem.


## The wall does not filter itself

Search, the category boxes, the price range and the stock tick all narrow the list in the caller, and the result is what gets rendered. That is the same rule the [table](table_template.md) template is built on, and for the same reason: a wall that filtered itself could not tell "nothing matched" from "nothing to sell", and those need different words and a different way out.

The empty state here says the products are still there and the filters are what is hiding them — then offers one button that clears them. An empty state that only describes the problem leaves the reader to work out which of four controls to undo.

## Which control for which filter

| Filter | Control | Because |
| --- | --- | --- |
| Category | [AstryxCheckboxList](checkbox_list.md) | Several at once, all worth seeing. One label and one validation state over the group. |
| Price | `AstryxSlider.range` | Two values that constrain each other. `formatValue` gives both the label and the announcement — a thumb that announces "84" is a thumb about nothing. |
| In stock | [AstryxCheckbox](checkbox.md) | One of a set of filters rather than a setting of its own — which is why it is not a [switch](switch.md), even though it applies immediately. |
| Sort | [AstryxSelector](selector.md) | Picks a value and shows the current one. A [menu](dropdown_menu.md) performs actions and reports nothing. |

> **Accessibility**
>
> A tile carries one `semanticsLabel` — name, price, rating, and "out of stock" when it applies — instead of four separate nodes. Somebody moving through a wall of eight products hears eight sentences rather than thirty-two fragments they have to reassemble.

> **Careful**
>
> **The wall is a wrapping row, not an [AstryxGrid](grid.md).** Each tile is pressable, and a pressable widget sits inside the touch-target wrapper, which cannot answer the intrinsic measurement a grid row needs in touch density. Uniform tiles look identical either way.

## Related

- [Product detail](product_detail.md) — where a tile leads.
- [Library](library.md) — the same filter-beside-results shape, for things you already own.
- [AstryxEmptyState](empty_state.md) — the title, the line and the way out.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Product gallery`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Product+gallery&component=Product+gallery) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Product+gallery&area=Product+gallery) — both templates arrive with the component filled in.
