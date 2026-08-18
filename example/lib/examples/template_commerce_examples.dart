/// The two screens a catalogue is made of: the wall you browse, and the page
/// you land on.
///
/// Neither is exported. Both are compositions worth copying, built from nothing
/// but what `astryx_ui` ships.
///
/// The rule they are both arranged around: nothing on either screen commits the
/// reader to anything. Choosing a size, a quantity or a filter changes what is
/// shown; the one control that spends money is a single primary button, and it
/// says what it is about to do.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// A price in whole pence, so nothing here rounds twice.
String money(int pence) => '£${(pence / 100).toStringAsFixed(2)}';

// #example template_product_detail -> ProductDetailTemplate
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
// #end

// #example template_product_gallery -> ProductGalleryTemplate
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
              // Search and sort are 400 logical pixels of field between them,
              // which is wider than a phone. They take a line each rather than
              // one of them being pushed off the end.
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
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
// #end
