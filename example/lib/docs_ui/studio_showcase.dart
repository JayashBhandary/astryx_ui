/// "Studio": a small storefront, a checkout, an assistant and an inventory on
/// one screen — what the Themes page renders in whichever theme is picked.
///
/// Upstream's themes page judges a theme by a real-looking product rather than
/// by swatches, and this is the same idea built from `astryx_ui`. Product
/// photos are drawn as an icon on a muted panel so the screen ships no images.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A product in the Studio shop.
typedef StudioProduct = ({
  String name,
  String detail,
  String blurb,
  IconData icon,
  String tag,
  AstryxBadgeVariant tagVariant,
  int available,
  String aisle,
});

/// The catalogue the storefront and the inventory share.
const List<StudioProduct> studioProducts = <StudioProduct>[
  (
    name: 'Minimalist Watch',
    detail: 'Stainless steel, sapphire crystal',
    blurb: 'Clean design meets everyday durability.',
    icon: LucideIcons.watch,
    tag: 'New',
    tagVariant: AstryxBadgeVariant.info,
    available: 42,
    aisle: 'Aisle 3',
  ),
  (
    name: 'Wireless Headphones',
    detail: 'ANC, 30hr battery',
    blurb: 'Immersive sound, all-day comfort.',
    icon: LucideIcons.headphones,
    tag: 'Popular',
    tagVariant: AstryxBadgeVariant.success,
    available: 128,
    aisle: 'Aisle 1',
  ),
  (
    name: 'Canvas Backpack',
    detail: 'Water-resistant, 25L',
    blurb: 'Water-resistant canvas with a quiet, modern profile.',
    icon: LucideIcons.backpack,
    tag: 'Limited',
    tagVariant: AstryxBadgeVariant.warning,
    available: 63,
    aisle: 'Aisle 2',
  ),
  (
    name: 'Leather Wallet',
    detail: 'Full-grain, RFID blocking',
    blurb: 'Slim, and better with age.',
    icon: LucideIcons.wallet,
    tag: 'Leather',
    tagVariant: AstryxBadgeVariant.warning,
    available: 15,
    aisle: 'Aisle 4',
  ),
  (
    name: 'Travel Tumbler',
    detail: 'Vacuum insulated, 16oz',
    blurb: 'Hot for six hours, cold for twelve.',
    icon: LucideIcons.cupSoda,
    tag: 'Drinkware',
    tagVariant: AstryxBadgeVariant.success,
    available: 87,
    aisle: 'Aisle 5',
  ),
  (
    name: 'Linen Throw',
    detail: 'Heavyweight, oat',
    blurb: 'Washed linen, softer every wash.',
    icon: LucideIcons.sofa,
    tag: 'Home',
    tagVariant: AstryxBadgeVariant.error,
    available: 24,
    aisle: 'Aisle 6',
  ),
];

/// The whole Studio screen.
///
/// Paints its own page background, so it reads as the theme's page wherever
/// it is placed.
class StudioShowcase extends StatelessWidget {
  const StudioShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return ColoredBox(
      color: theme.color(AstryxColorToken.backgroundBody),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 860;
          final pad = theme.spacing(
            wide ? AstryxSpacingToken.spacing6 : AstryxSpacingToken.spacing3,
          );

          // Top-aligned, not stretched to equal heights: stretching needs an
          // intrinsic-height pass, which the table and inputs do not support.
          Widget pair(Widget a, Widget b, {int flexA = 1, int flexB = 1}) =>
              wide
              ? AstryxHStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(flex: flexA, child: a),
                    Expanded(flex: flexB, child: b),
                  ],
                )
              : AstryxVStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[a, b],
                );

          return AstryxVStack(
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              _StudioNav(compact: !wide),
              Padding(
                padding: EdgeInsets.all(pad),
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing6,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    const _Hero(),
                    _ProductRow(columns: wide ? 3 : 1),
                    pair(const _Checkout(), const _Assistant()),
                    pair(const _Inventory(), const _Revenue(), flexA: 2),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StudioNav extends StatefulWidget {
  const _StudioNav({required this.compact});

  final bool compact;

  @override
  State<_StudioNav> createState() => _StudioNavState();
}

class _StudioNavState extends State<_StudioNav> {
  String _selected = 'shop';

  @override
  Widget build(BuildContext context) {
    return AstryxTopNav(
      label: 'Studio',
      selectedId: _selected,
      onSelected: (id) => setState(() => _selected = id),
      leading: const AstryxHeading('Studio', level: 4),
      entries: widget.compact
          ? const <AstryxNavEntry>[]
          : const <AstryxNavEntry>[
              AstryxNavItem(id: 'shop', label: 'Shop'),
              AstryxNavItem(id: 'new', label: 'New In'),
              AstryxNavItem(id: 'stories', label: 'Stories'),
              AstryxNavItem(id: 'help', label: 'Help'),
            ],
      actions: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.search,
          label: 'Search',
          variant: AstryxButtonVariant.ghost,
          onPressed: () {},
        ),
        AstryxIconButton.custom(
          label: 'Bag',
          variant: AstryxButtonVariant.ghost,
          onPressed: () {},
          child: const Icon(LucideIcons.shoppingBag, size: 18),
        ),
        AstryxButton(
          label: 'Sign in',
          variant: AstryxButtonVariant.primary,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing(AstryxSpacingToken.spacing4),
      ),
      child: const AstryxCenter(
        axis: AstryxCenterAxis.horizontal,
        maxWidth: 560,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHeading(
              'Little joys, everywhere you go',
              level: 1,
              type: AstryxHeadingType.display2,
              justify: AstryxTextJustify.center,
            ),
            AstryxText(
              'We believe the smallest details are the ones that matter most. '
              'Turn an ordinary day into something worth remembering.',
              color: AstryxTextColor.secondary,
              justify: AstryxTextJustify.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// The "photo" backdrop: the page colour nudged toward the text colour.
///
/// Mixed rather than read from a token, because the muted background is
/// transparent in some themes and a product shot on nothing reads as a
/// missing image.
Color studioPanelColor(AstryxThemeData theme) => Color.lerp(
  theme.color(AstryxColorToken.backgroundBody),
  theme.color(AstryxColorToken.textPrimary),
  0.07,
)!;

/// A product "photo": the product's icon, large, on a muted panel.
class StudioProductArt extends StatelessWidget {
  const StudioProductArt({
    required this.icon,
    super.key,
    this.size = 64,
    this.height,
  });

  final IconData icon;
  final double size;

  /// Null keeps a 4:3 panel.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final panel = DecoratedBox(
      decoration: BoxDecoration(
        color: studioPanelColor(theme),
      ),
      child: Center(
        child: Icon(
          icon,
          size: size,
          color: theme.color(AstryxColorToken.iconSecondary),
        ),
      ),
    );
    return height == null
        ? AspectRatio(aspectRatio: 4 / 3, child: panel)
        : SizedBox(height: height, child: panel);
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) {
    final products = studioProducts.take(3).toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = AstryxTheme.of(context);
        final gap = theme.spacing(AstryxSpacingToken.spacing4);
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final product in products)
              SizedBox(width: width, child: _ProductCard(product)),
          ],
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  const _ProductCard(this.product);

  final StudioProduct product;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  num? _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final product = widget.product;

    return AstryxCard(
      padding: AstryxSpacingToken.spacing0,
      child: ClipRRect(
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        child: AstryxVStack(
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            StudioProductArt(icon: product.icon, size: 72),
            Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing4),
              ),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.center,
                children: <Widget>[
                  AstryxBadge(product.tag, variant: product.tagVariant),
                  AstryxHeading(product.name, level: 3),
                  AstryxText(
                    product.blurb,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    justify: AstryxTextJustify.center,
                  ),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    justify: AstryxStackJustify.center,
                    wrap: true,
                    runGap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      AstryxNumberInput(
                        label: 'Quantity',
                        labelHidden: true,
                        value: _quantity,
                        min: 1,
                        max: 9,
                        integerOnly: true,
                        width: 140,
                        size: AstryxInputSize.sm,
                        onChanged: (value) => setState(() => _quantity = value),
                      ),
                      AstryxButton(
                        label: 'Add to cart',
                        size: AstryxButtonSize.sm,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Shipping { economy, standard, express }

enum _Payment { card, apple, google }

class _Checkout extends StatefulWidget {
  const _Checkout();

  @override
  State<_Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<_Checkout> {
  _Shipping _shipping = _Shipping.economy;
  _Payment _payment = _Payment.card;
  String? _country = 'us';
  bool _save = true;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    Widget payment(_Payment value, String label, IconData icon) => Expanded(
      child: AstryxSelectableCard(
        label: label,
        selected: _payment == value,
        control: AstryxSelectableCardControl.radio,
        onSelectedChanged: (_) => setState(() => _payment = value),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          children: <Widget>[
            Icon(
              icon,
              size: 18,
              color: theme.color(AstryxColorToken.iconPrimary),
            ),
            AstryxText(label, type: AstryxTextType.supporting),
          ],
        ),
      ),
    );

    return AstryxCard(
      header: const AstryxHeading('Checkout', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxRadioList<_Shipping>(
            label: 'Shipping method',
            description: 'Delivery time may vary based on location.',
            value: _shipping,
            onChanged: (value) => setState(() => _shipping = value),
            options: const <AstryxRadioOption<_Shipping>>[
              AstryxRadioOption(
                value: _Shipping.economy,
                label: r'Economy · $12.00',
                description: 'Delivered in 5–7 business days',
              ),
              AstryxRadioOption(
                value: _Shipping.standard,
                label: r'Standard · $16.00',
                description: 'Delivered in 3–5 business days',
              ),
              AstryxRadioOption(
                value: _Shipping.express,
                label: r'Express · $24.00',
                description: 'Delivered in 1–2 business days',
              ),
            ],
          ),
          const AstryxText('Payment method', type: AstryxTextType.label),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              payment(_Payment.card, 'Card', LucideIcons.creditCard),
              payment(_Payment.apple, 'Apple Pay', LucideIcons.smartphone),
              payment(_Payment.google, 'Google Pay', LucideIcons.wallet2),
            ],
          ),
          const AstryxTextInput(
            label: 'Card number',
            placeholder: '1234 1234 1234 1234',
          ),
          const AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: AstryxTextInput(label: 'Expiry', placeholder: 'MM / YY'),
              ),
              Expanded(
                child: AstryxTextInput(label: 'CVC', placeholder: '123'),
              ),
            ],
          ),
          AstryxSelector<String>(
            label: 'Country',
            value: _country,
            onChanged: (value) => setState(() => _country = value),
            options: const <AstryxSelectorEntry<String>>[
              AstryxSelectorOption(value: 'us', label: 'United States'),
              AstryxSelectorOption(value: 'gb', label: 'United Kingdom'),
              AstryxSelectorOption(value: 'in', label: 'India'),
            ],
          ),
          AstryxCheckbox(
            label: 'Save my information for 1-click checkout',
            description: 'Pay faster on Studio next time.',
            value: _save,
            onChanged: (value) => setState(() => _save = value),
          ),
          AstryxButton(
            label: 'Pay now',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _Assistant extends StatefulWidget {
  const _Assistant();

  @override
  State<_Assistant> createState() => _AssistantState();
}

class _AssistantState extends State<_Assistant> {
  final TextEditingController _draft = TextEditingController();

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String sub, Widget end) => AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      justify: AstryxStackJustify.between,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing0,
            children: <Widget>[
              AstryxText(label, type: AstryxTextType.label),
              AstryxText(
                sub,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
        ),
        end,
      ],
    );

    return AstryxCard(
      header: const AstryxHeading('Studio AI', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxChatMessage(
            role: AstryxChatRole.user,
            child: AstryxText('Where’s my order?'),
          ),
          const AstryxChatMessage(
            child: AstryxText(
              'Your order #1043 — the Minimalist Watch and Linen Throw — '
              'shipped this morning and is on track to arrive by end of day '
              'tomorrow.',
            ),
          ),
          const AstryxChatMessage(
            role: AstryxChatRole.user,
            child: AstryxText('Can you show me the full details?'),
          ),
          AstryxChatMessage(
            child: AstryxCard(
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  row(
                    'Items',
                    'Minimalist Watch · Linen Throw',
                    const AstryxText(r'$248', type: AstryxTextType.label),
                  ),
                  row(
                    'Shipping',
                    'UPS Ground',
                    const AstryxText(r'$12', type: AstryxTextType.label),
                  ),
                  row(
                    'Estimated arrival',
                    'Tomorrow by 8pm',
                    const AstryxBadge(
                      'On time',
                      variant: AstryxBadgeVariant.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              for (final label in const <String>[
                'Reschedule delivery',
                'Update address',
                'Start a return',
              ])
                AstryxButton(
                  label: label,
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
            ],
          ),
          AstryxChatComposer(
            controller: _draft,
            placeholder: 'Ask Studio AI…',
            onSubmit: (_) => _draft.clear(),
          ),
        ],
      ),
    );
  }
}

class _Inventory extends StatefulWidget {
  const _Inventory();

  @override
  State<_Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<_Inventory> {
  Set<Object> _selected = <Object>{'Wireless Headphones', 'Leather Wallet'};

  @override
  Widget build(BuildContext context) {
    final low = studioProducts.where((p) => p.available < 30).length;

    return AstryxCard(
      header: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const AstryxHeading('Inventory', level: 3),
          AstryxButton(
            label: 'Add item',
            size: AstryxButtonSize.sm,
            leading: const Icon(LucideIcons.plus),
            onPressed: () {},
          ),
        ],
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxTextInput(
            label: 'Search inventory',
            labelHidden: true,
            placeholder: 'Type and hit enter…',
            leading: AstryxIcon(AstryxIconName.search),
          ),
          AstryxBanner(
            title: '$low items are running low',
            status: AstryxBannerStatus.warning,
            announce: false,
          ),
          AstryxTable<StudioProduct>(
            label: 'Inventory',
            rows: studioProducts,
            keyOf: (row) => row.name,
            selectionMode: AstryxTableSelectionMode.multiple,
            selected: _selected,
            onSelectionChanged: (value) => setState(() => _selected = value),
            columns: <AstryxTableColumn<StudioProduct>>[
              AstryxTableColumn<StudioProduct>(
                id: 'item',
                header: 'Item',
                width: const AstryxTableColumnWidth.flex(2.4),
                cellBuilder: (context, row) => AstryxHStack(
                  gap: AstryxSpacingToken.spacing3,
                  children: <Widget>[
                    SizedBox(
                      width: 36,
                      child: ClipRRect(
                        borderRadius: AstryxTheme.of(
                          context,
                        ).borderRadius(AstryxRadiusToken.inner),
                        child: StudioProductArt(
                          icon: row.icon,
                          size: 18,
                          height: 36,
                        ),
                      ),
                    ),
                    Flexible(
                      child: AstryxVStack(
                        gap: AstryxSpacingToken.spacing0,
                        children: <Widget>[
                          AstryxText(row.name, type: AstryxTextType.label),
                          AstryxText(
                            row.detail,
                            type: AstryxTextType.supporting,
                            color: AstryxTextColor.secondary,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AstryxTableColumn<StudioProduct>(
                id: 'available',
                header: 'Available',
                cellBuilder: (context, row) =>
                    AstryxText('${row.available}', tabularNumbers: true),
              ),
              AstryxTableColumn<StudioProduct>(
                id: 'location',
                header: 'Location',
                cellBuilder: (context, row) => AstryxText(row.aisle),
              ),
              AstryxTableColumn<StudioProduct>(
                id: 'tags',
                header: 'Tags',
                alignment: AstryxTableAlignment.end,
                cellBuilder: (context, row) =>
                    AstryxBadge(row.tag, variant: row.tagVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Revenue extends StatelessWidget {
  const _Revenue();

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    Widget stat(String value, String label) => AstryxVStack(
      gap: AstryxSpacingToken.spacing0,
      children: <Widget>[
        AstryxHeading(value, level: 3),
        AstryxText(
          label,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );

    Widget order(String id, String when, String amount, IconData icon) =>
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox.square(
              dimension: 32,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: studioPanelColor(theme),
                  borderRadius: theme.borderRadius(AstryxRadiusToken.element),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: theme.color(AstryxColorToken.iconSecondary),
                ),
              ),
            ),
            Expanded(
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing0,
                children: <Widget>[
                  AstryxText(id, type: AstryxTextType.label),
                  AstryxText(
                    when,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
            ),
            AstryxText(
              amount,
              type: AstryxTextType.label,
              tabularNumbers: true,
            ),
          ],
        );

    return AstryxCard(
      header: const AstryxHeading('Revenue', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing8,
            wrap: true,
            runGap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              stat('18K', 'Monthly revenue'),
              stat('+12%', 'Order growth'),
            ],
          ),
          const AstryxDivider(),
          AstryxHStack(
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const AstryxHeading('Activity', level: 4),
              AstryxButton(
                label: 'See all',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
          order(
            'Order #1043',
            'Placed · 1:59 pm',
            r'+$248',
            LucideIcons.shoppingBag,
          ),
          order(
            'Order #1041',
            'Refunded · 12:40 pm',
            r'−$89',
            LucideIcons.receipt,
          ),
          order(
            'Order #1040',
            'Placed · 10:30 am',
            r'+$156',
            LucideIcons.shoppingBag,
          ),
          order(
            'Order #1038',
            'Placed · 9:11 am',
            r'+$412',
            LucideIcons.shoppingBag,
          ),
        ],
      ),
    );
  }
}
