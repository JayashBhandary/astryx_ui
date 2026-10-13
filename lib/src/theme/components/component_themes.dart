/// Every per-widget theme, as one value.
library;

import 'package:astryx_ui/src/theme/components/badge.dart';
import 'package:astryx_ui/src/theme/components/banner.dart';
import 'package:astryx_ui/src/theme/components/bottom_sheet.dart';
import 'package:astryx_ui/src/theme/components/button.dart';
import 'package:astryx_ui/src/theme/components/card.dart';
import 'package:astryx_ui/src/theme/components/checkbox.dart';
import 'package:astryx_ui/src/theme/components/dialog.dart';
import 'package:astryx_ui/src/theme/components/divider.dart';
import 'package:astryx_ui/src/theme/components/icon.dart';
import 'package:astryx_ui/src/theme/components/input.dart';
import 'package:astryx_ui/src/theme/components/menu.dart';
import 'package:astryx_ui/src/theme/components/radio.dart';
import 'package:astryx_ui/src/theme/components/switch.dart';
import 'package:astryx_ui/src/theme/components/table.dart';
import 'package:astryx_ui/src/theme/components/tabs.dart';
import 'package:astryx_ui/src/theme/components/text.dart';
import 'package:astryx_ui/src/theme/components/toast.dart';
import 'package:astryx_ui/src/theme/components/tooltip.dart';
import 'package:flutter/foundation.dart';

/// The per-widget themes an app or a subtree applies, bundled.
///
/// This is the component half of what Material's `ThemeData` carries — its
/// `cardTheme`, `dialogTheme`, `inputDecorationTheme` and the rest — kept
/// apart from the token set, which an `AstryxDefinedTheme` already owns. Hand
/// it to `AstryxApp` or `AstryxThemeProvider` for the whole app, or to
/// `AstryxComponentTheme` for one subtree.
///
/// Every slot defaults to an empty theme, and every field of every empty
/// theme is null — "fall through to the token default" — so a bundle that sets
/// one property of one widget changes exactly that.
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(
///   componentThemes: const AstryxComponentThemes(
///     button: AstryxButtonTheme(borderRadius: BorderRadius.zero),
///     divider: AstryxDividerTheme(thickness: 2),
///   ),
///   home: const HomePage(),
/// )
/// ```
/// {@end-tool}
@immutable
class AstryxComponentThemes with Diagnosticable {
  /// Creates a bundle of component themes.
  const AstryxComponentThemes({
    this.button = const AstryxButtonTheme(),
    this.text = const AstryxTextTheme(),
    this.heading = const AstryxTextTheme(),
    this.divider = const AstryxDividerTheme(),
    this.icon = const AstryxIconTheme(),
    this.card = const AstryxCardTheme(),
    this.badge = const AstryxBadgeTheme(),
    this.banner = const AstryxBannerTheme(),
    this.input = const AstryxInputTheme(),
    this.checkbox = const AstryxCheckboxTheme(),
    this.radio = const AstryxRadioTheme(),
    this.switchTheme = const AstryxSwitchTheme(),
    this.dialog = const AstryxDialogTheme(),
    this.bottomSheet = const AstryxBottomSheetTheme(),
    this.menu = const AstryxMenuTheme(),
    this.tooltip = const AstryxTooltipTheme(),
    this.toast = const AstryxToastTheme(),
    this.tabs = const AstryxTabsTheme(),
    this.table = const AstryxTableTheme(),
  });

  /// Visual overrides for `AstryxButton`, `AstryxIconButton` and
  /// `AstryxToggleButton`.
  final AstryxButtonTheme button;

  /// Visual overrides for `AstryxText`.
  final AstryxTextTheme text;

  /// Visual overrides for `AstryxHeading`.
  ///
  /// Separate from [text] so headings can be weighted or tracked without
  /// touching body copy.
  final AstryxTextTheme heading;

  /// Visual overrides for `AstryxDivider`.
  final AstryxDividerTheme divider;

  /// Visual overrides for `AstryxIcon`.
  final AstryxIconTheme icon;

  /// Visual overrides for `AstryxCard` and `AstryxSelectableCard`.
  final AstryxCardTheme card;

  /// Visual overrides for `AstryxBadge`.
  final AstryxBadgeTheme badge;

  /// Visual overrides for `AstryxBanner`.
  final AstryxBannerTheme banner;

  /// Visual overrides for text-entry controls: `AstryxTextInput`, `AstryxNumberInput`, the `AstryxSelector` trigger and the other fields built on `AstryxInputContainer`.
  final AstryxInputTheme input;

  /// Visual overrides for `AstryxCheckbox`.
  final AstryxCheckboxTheme checkbox;

  /// Visual overrides for the radios in `AstryxRadioList`.
  final AstryxRadioTheme radio;

  /// Visual overrides for `AstryxSwitch`.
  final AstryxSwitchTheme switchTheme;

  /// Visual overrides for `AstryxDialog` and `AstryxAlertDialog`.
  final AstryxDialogTheme dialog;

  /// Visual overrides for `AstryxBottomSheet`.
  final AstryxBottomSheetTheme bottomSheet;

  /// Visual overrides for menu surfaces: `AstryxDropdownMenu`, `AstryxContextMenu` and selector popups.
  final AstryxMenuTheme menu;

  /// Visual overrides for `AstryxTooltip`.
  final AstryxTooltipTheme tooltip;

  /// Visual overrides for toasts.
  final AstryxToastTheme toast;

  /// Visual overrides for `AstryxTabList`.
  final AstryxTabsTheme tabs;

  /// Visual overrides for `AstryxTable`.
  final AstryxTableTheme table;

  /// Returns a copy with the given slots replaced.
  ///
  /// Replaces a slot wholesale. To change one property of a slot and keep the
  /// others, use [merge].
  AstryxComponentThemes copyWith({
    AstryxButtonTheme? button,
    AstryxTextTheme? text,
    AstryxTextTheme? heading,
    AstryxDividerTheme? divider,
    AstryxIconTheme? icon,
    AstryxCardTheme? card,
    AstryxBadgeTheme? badge,
    AstryxBannerTheme? banner,
    AstryxInputTheme? input,
    AstryxCheckboxTheme? checkbox,
    AstryxRadioTheme? radio,
    AstryxSwitchTheme? switchTheme,
    AstryxDialogTheme? dialog,
    AstryxBottomSheetTheme? bottomSheet,
    AstryxMenuTheme? menu,
    AstryxTooltipTheme? tooltip,
    AstryxToastTheme? toast,
    AstryxTabsTheme? tabs,
    AstryxTableTheme? table,
  }) => AstryxComponentThemes(
    button: button ?? this.button,
    text: text ?? this.text,
    heading: heading ?? this.heading,
    divider: divider ?? this.divider,
    icon: icon ?? this.icon,
    card: card ?? this.card,
    badge: badge ?? this.badge,
    banner: banner ?? this.banner,
    input: input ?? this.input,
    checkbox: checkbox ?? this.checkbox,
    radio: radio ?? this.radio,
    switchTheme: switchTheme ?? this.switchTheme,
    dialog: dialog ?? this.dialog,
    bottomSheet: bottomSheet ?? this.bottomSheet,
    menu: menu ?? this.menu,
    tooltip: tooltip ?? this.tooltip,
    toast: toast ?? this.toast,
    tabs: tabs ?? this.tabs,
    table: table ?? this.table,
  );

  /// Returns a copy with every non-null field of [other] applied over this,
  /// slot by slot.
  ///
  /// This is how a nested `AstryxComponentTheme` combines with the one above
  /// it: an inner bundle that sets only a button radius keeps the outer
  /// bundle's button colours, and every other slot, untouched.
  AstryxComponentThemes merge(AstryxComponentThemes? other) {
    if (other == null) return this;
    return AstryxComponentThemes(
      button: button.merge(other.button),
      text: text.merge(other.text),
      heading: heading.merge(other.heading),
      divider: divider.merge(other.divider),
      icon: icon.merge(other.icon),
      card: card.merge(other.card),
      badge: badge.merge(other.badge),
      banner: banner.merge(other.banner),
      input: input.merge(other.input),
      checkbox: checkbox.merge(other.checkbox),
      radio: radio.merge(other.radio),
      switchTheme: switchTheme.merge(other.switchTheme),
      dialog: dialog.merge(other.dialog),
      bottomSheet: bottomSheet.merge(other.bottomSheet),
      menu: menu.merge(other.menu),
      tooltip: tooltip.merge(other.tooltip),
      toast: toast.merge(other.toast),
      tabs: tabs.merge(other.tabs),
      table: table.merge(other.table),
    );
  }

  /// Linearly interpolates between two bundles, slot by slot.
  static AstryxComponentThemes? lerp(
    AstryxComponentThemes? a,
    AstryxComponentThemes? b,
    double t,
  ) {
    if (identical(a, b)) return a;
    return AstryxComponentThemes(
      button: AstryxButtonTheme.lerp(a?.button, b?.button, t) ?? const AstryxButtonTheme(),
      text: AstryxTextTheme.lerp(a?.text, b?.text, t) ?? const AstryxTextTheme(),
      heading: AstryxTextTheme.lerp(a?.heading, b?.heading, t) ?? const AstryxTextTheme(),
      divider: AstryxDividerTheme.lerp(a?.divider, b?.divider, t) ?? const AstryxDividerTheme(),
      icon: AstryxIconTheme.lerp(a?.icon, b?.icon, t) ?? const AstryxIconTheme(),
      card: AstryxCardTheme.lerp(a?.card, b?.card, t) ?? const AstryxCardTheme(),
      badge: AstryxBadgeTheme.lerp(a?.badge, b?.badge, t) ?? const AstryxBadgeTheme(),
      banner: AstryxBannerTheme.lerp(a?.banner, b?.banner, t) ?? const AstryxBannerTheme(),
      input: AstryxInputTheme.lerp(a?.input, b?.input, t) ?? const AstryxInputTheme(),
      checkbox: AstryxCheckboxTheme.lerp(a?.checkbox, b?.checkbox, t) ?? const AstryxCheckboxTheme(),
      radio: AstryxRadioTheme.lerp(a?.radio, b?.radio, t) ?? const AstryxRadioTheme(),
      switchTheme: AstryxSwitchTheme.lerp(a?.switchTheme, b?.switchTheme, t) ?? const AstryxSwitchTheme(),
      dialog: AstryxDialogTheme.lerp(a?.dialog, b?.dialog, t) ?? const AstryxDialogTheme(),
      bottomSheet: AstryxBottomSheetTheme.lerp(a?.bottomSheet, b?.bottomSheet, t) ?? const AstryxBottomSheetTheme(),
      menu: AstryxMenuTheme.lerp(a?.menu, b?.menu, t) ?? const AstryxMenuTheme(),
      tooltip: AstryxTooltipTheme.lerp(a?.tooltip, b?.tooltip, t) ?? const AstryxTooltipTheme(),
      toast: AstryxToastTheme.lerp(a?.toast, b?.toast, t) ?? const AstryxToastTheme(),
      tabs: AstryxTabsTheme.lerp(a?.tabs, b?.tabs, t) ?? const AstryxTabsTheme(),
      table: AstryxTableTheme.lerp(a?.table, b?.table, t) ?? const AstryxTableTheme(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxComponentThemes &&
          other.button == button &&
          other.text == text &&
          other.heading == heading &&
          other.divider == divider &&
          other.icon == icon &&
          other.card == card &&
          other.badge == badge &&
          other.banner == banner &&
          other.input == input &&
          other.checkbox == checkbox &&
          other.radio == radio &&
          other.switchTheme == switchTheme &&
          other.dialog == dialog &&
          other.bottomSheet == bottomSheet &&
          other.menu == menu &&
          other.tooltip == tooltip &&
          other.toast == toast &&
          other.tabs == tabs &&
          other.table == table;

  @override
  int get hashCode => Object.hashAll(<Object>[
    button,
    text,
    heading,
    divider,
    icon,
    card,
    badge,
    banner,
    input,
    checkbox,
    radio,
    switchTheme,
    dialog,
    bottomSheet,
    menu,
    tooltip,
    toast,
    tabs,
    table,
  ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const empty = AstryxComponentThemes();
    properties.add(
      DiagnosticsProperty<AstryxButtonTheme>('button', button, defaultValue: empty.button),
    );
    properties.add(
      DiagnosticsProperty<AstryxTextTheme>('text', text, defaultValue: empty.text),
    );
    properties.add(
      DiagnosticsProperty<AstryxTextTheme>('heading', heading, defaultValue: empty.heading),
    );
    properties.add(
      DiagnosticsProperty<AstryxDividerTheme>('divider', divider, defaultValue: empty.divider),
    );
    properties.add(
      DiagnosticsProperty<AstryxIconTheme>('icon', icon, defaultValue: empty.icon),
    );
    properties.add(
      DiagnosticsProperty<AstryxCardTheme>('card', card, defaultValue: empty.card),
    );
    properties.add(
      DiagnosticsProperty<AstryxBadgeTheme>('badge', badge, defaultValue: empty.badge),
    );
    properties.add(
      DiagnosticsProperty<AstryxBannerTheme>('banner', banner, defaultValue: empty.banner),
    );
    properties.add(
      DiagnosticsProperty<AstryxInputTheme>('input', input, defaultValue: empty.input),
    );
    properties.add(
      DiagnosticsProperty<AstryxCheckboxTheme>('checkbox', checkbox, defaultValue: empty.checkbox),
    );
    properties.add(
      DiagnosticsProperty<AstryxRadioTheme>('radio', radio, defaultValue: empty.radio),
    );
    properties.add(
      DiagnosticsProperty<AstryxSwitchTheme>('switchTheme', switchTheme, defaultValue: empty.switchTheme),
    );
    properties.add(
      DiagnosticsProperty<AstryxDialogTheme>('dialog', dialog, defaultValue: empty.dialog),
    );
    properties.add(
      DiagnosticsProperty<AstryxBottomSheetTheme>('bottomSheet', bottomSheet, defaultValue: empty.bottomSheet),
    );
    properties.add(
      DiagnosticsProperty<AstryxMenuTheme>('menu', menu, defaultValue: empty.menu),
    );
    properties.add(
      DiagnosticsProperty<AstryxTooltipTheme>('tooltip', tooltip, defaultValue: empty.tooltip),
    );
    properties.add(
      DiagnosticsProperty<AstryxToastTheme>('toast', toast, defaultValue: empty.toast),
    );
    properties.add(
      DiagnosticsProperty<AstryxTabsTheme>('tabs', tabs, defaultValue: empty.tabs),
    );
    properties.add(
      DiagnosticsProperty<AstryxTableTheme>('table', table, defaultValue: empty.table),
    );
  }
}
