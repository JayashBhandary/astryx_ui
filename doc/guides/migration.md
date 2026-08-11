---
title: Migration
description: 'Coming from Material or Cupertino: what maps, what does not, and what to stop doing.'
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

There is no migration mode and no compatibility layer, because none is needed. `astryx_ui` is built on `flutter/widgets`, so a Material application adopts it the way it would adopt any other widget set: one subtree at a time, with both in the tree meanwhile — or permanently, if the chrome stays Material and the content does not.

## Where it goes

`AstryxThemeProvider` installs the theme, the icon registry, the localisations, the focus-visible scope and the toast host for the subtree below it. It is an ordinary widget, so a single route can adopt the design system while everything around it stays as it was.

```dart
// The app is still a MaterialApp. One screen is not.
MaterialApp(
  home: const HomeScreen(),
  routes: <String, WidgetBuilder>{
    '/settings': (context) => const AstryxThemeProvider(
      child: SettingsScreen(),
    ),
  },
)
```

> **Note**
>
> Two providers in one application are fine, and so is one inside another: a theme is a value, not a global. That is the same property that lets [Themes](themes.md) render eight of them on one page.

## What maps

The third column is the part worth reading. Most of these are not renames — the widget exists because the Material one made a choice this design system does not make.

| Material | Here | What actually differs |
| --- | --- | --- |
| `MaterialApp` | [`AstryxApp`](installation.md) | A `WidgetsApp`. Nothing Material-shaped arrives with it — no `Scaffold`, no `AppBar`, no `ThemeData`. |
| `Theme.of(context)`, `ColorScheme` | `AstryxTheme.of(context)` | Tokens rather than a colour scheme: `theme.color(…)`, `theme.spacing(…)`, `theme.textStyle(…)`. See [Design tokens](tokens.md). |
| `ElevatedButton`, `FilledButton` | [`AstryxButton`](../components/button.md) | One button with a `variant`. `primary` is the filled one; there is also `destructive`, which Material leaves you to build. |
| `OutlinedButton`, `TextButton` | [`AstryxButton`](../components/button.md) | `secondary` and `ghost`. Emphasis is a variant, not a class. |
| `IconButton` | [`AstryxIconButton`](../components/icon_button.md) | `label` is **required** even though nothing is painted. An unnamed icon button is a compile error here, not a review comment. |
| `TextField`, `TextFormField` | [`AstryxTextInput`](../components/text_input.md), [`AstryxTextArea`](../components/text_area.md) | No `InputDecoration`. The label, the description and the error are parameters on the input — or on [`AstryxField`](../components/field.md), which labels anything. |
| `Checkbox`, `CheckboxListTile` | [`AstryxCheckbox`](../components/checkbox.md) | The label belongs to the control, so there is no tile variant. Tristate is `AstryxCheckboxValue`, not a nullable `bool`. |
| `Switch`, `SwitchListTile` | [`AstryxSwitch`](../components/switch.md) | Same: one widget, `label` required. |
| `Radio`, `RadioListTile` | [`AstryxRadioList`](../components/radio_list.md) | The **group** is the widget. Roving focus, arrow keys and the single tab stop come from it owning the set. |
| `DropdownButton`, `DropdownMenu` | [`AstryxSelector`](../components/selector.md) | Choosing a *value* is a selector. Material’s dropdown does both jobs; here they are two widgets. |
| `PopupMenuButton` | [`AstryxDropdownMenu`](../components/dropdown_menu.md) | Choosing a *command* is a menu. Sections, dividers and destructive items are part of it. |
| `Card`, `InkWell` | [`AstryxCard`](../components/card.md) | A pressable card is a non-null `onPressed`, not a wrapper. There is no ink ripple: the states are hover, focus-visible and pressed. |
| `Chip` | [`AstryxBadge`](../components/badge.md) | A badge is a label, not a control. Nothing about it is tappable, and that is the point. |
| `MaterialBanner` | [`AstryxBanner`](../components/banner.md) | Status is a variant, and every one carries an icon as well as a fill. |
| `Divider`, `VerticalDivider` | [`AstryxDivider`](../components/divider.md) | One widget with an `axis`, and an optional label in the rule. |
| `CircularProgressIndicator` | [`AstryxSpinner`](../components/spinner.md) | Settles into a complete ring under reduced motion rather than vanishing. |
| `LinearProgressIndicator` | [`AstryxProgressBar`](../components/progress_bar.md) | Takes a `label`; determinate and indeterminate are the same widget. |
| Shimmer packages | [`AstryxSkeleton`](../components/skeleton.md) | In the package, themed by `--color-skeleton`, and still legible when animations are off. |
| `Tooltip` | [`AstryxTooltip`](../components/tooltip.md) | Same idea, stricter rule: a tooltip may not be the only route to information. A third of your users have no hover. |
| `SnackBar`, `ScaffoldMessenger` | [`AstryxToast`](../components/toast.md) | `AstryxToastScope.of(context).show(…)`. No `Scaffold` in the way, because there is no `Scaffold`. |
| `AlertDialog`, `showDialog` | [`AstryxDialog`](../components/dialog.md) | A **widget in the tree** driven by a controller, not a route pushed onto a navigator. |
| `TabBar`, `TabBarView` | [`AstryxTabList`](../components/tab_list.md) | The list only. You own the body it selects, which is usually a switch over your own state. |
| `DataTable` | [`AstryxTable`](../components/table.md) | Columns are `AstryxTableColumn` objects with their own widths, alignment and sort. Row actions stay visible rather than appearing on hover. |
| `Text`, `TextStyle` | [`AstryxText`](../components/text.md), [`AstryxHeading`](../components/heading.md) | Ask for a `type` or a `level`, never a size. See [Typography](typography.md). |
| `Icon`, `Icons.*` | [`AstryxIcon`](../components/icon.md) | Icons are asked for by meaning — `AstryxIconName.success` — and the registry decides the glyph. |
| `Column` + `SizedBox` gaps | [`AstryxVStack`](../components/stack.md), `AstryxHStack` | `gap` is a spacing token, so a reordered list keeps its rhythm and no gap is a magic number. |
| `GridView`, `Wrap` | [`AstryxGrid`](../components/grid.md) | A `minWidth` and no breakpoints: the grid works out its own column count. See [Layout](layout_guide.md). |
| `Semantics(label:)` for hidden text | `labelHidden`, `AstryxVisuallyHidden` | Hiding a label from sight while keeping it as the accessible name is a parameter on the control. |

## From Cupertino

| Cupertino | Here |
| --- | --- |
| `CupertinoButton` | [`AstryxButton`](../components/button.md) |
| `CupertinoTextField` | [`AstryxTextInput`](../components/text_input.md) |
| `CupertinoSwitch` | [`AstryxSwitch`](../components/switch.md) |
| `CupertinoAlertDialog` | [`AstryxDialog`](../components/dialog.md) |
| `CupertinoActivityIndicator` | [`AstryxSpinner`](../components/spinner.md) |
| `CupertinoSegmentedControl` | [`AstryxButtonGroup`](../components/button_group.md) for actions, [`AstryxTabList`](../components/tab_list.md) for views |
| `CupertinoPageScaffold` | Nothing yet — see below. |

The design system does not switch appearance by platform: an internal tool should look the same to the person who uses it on a laptop and on a tablet. What *does* change by platform is density — see [Density](density.md) — and that is a target size, not a style.

## What has no counterpart yet

Roughly 30 components are in scope for 1.0, and the application shell is not among them yet. There is no `Scaffold`, `AppBar`, `Drawer`, `NavigationBar`, `BottomSheet`, date picker, autocomplete or avatar. Those pages exist in the sidebar under **Navigation**, **App shell**, **Date & time**, **Media** and **Command & search**, carrying the *Soon* badge.

Until they land, keep the Material ones. A `Scaffold` whose `body` is an `AstryxThemeProvider` is a perfectly good arrangement, and it is what most adopting applications will look like for a while.

## Two theme systems in one tree

The Material widgets you keep still read `ThemeData`, and nothing in `astryx_ui` touches it. The two are independent, which is what makes the incremental path safe — and also what makes them able to disagree.

- **Brightness.** `AstryxColorMode.system` and `ThemeMode.system` both follow the platform, so the common case agrees for free. If you force one, force the other from the same value.
- **Density.** `VisualDensity` and `AstryxDensity` are unrelated. Setting Material’s does not move the Astryx one, which resolves from the platform and the pointer precision `MediaQuery` reports.
- **Type.** Material’s `Typography` does not reach an `AstryxText`, and the package bundles no typeface. See [Typography](typography.md).
- **Direction.** Both are logical. One `Directionality` covers the whole tree; see [Right-to-left](rtl.md).

## What to stop doing

These are the habits that survive a migration and quietly undo it. Each one is a value a component is holding that the theme should be holding instead.

| Habit | Instead |
| --- | --- |
| `Colors.blue`, `Color(0xFF…)` | A colour token. If none of the seventy-nine fits, the answer is a `tokens` override in `defineTheme`, not a literal. See [Colour](color.md). |
| `EdgeInsets.all(16)` | `theme.spacing(AstryxSpacingToken.spacing4)`, or the component’s own padding parameter, which already takes a token. |
| `TextStyle(fontSize: 13)` | A type role. `theme.textStyle(AstryxTypeRole.supporting)` when you are building something the widget set does not cover. |
| `BorderRadius.circular(8)` | `theme.borderRadius(AstryxRadiusToken.element)` — which is 0 in the `y2k` theme, and that is the point. |
| `Duration(milliseconds: 200)` | `AstryxMotion.of(context)`, which honours reduced motion. See [Motion](motion.md). |
| Row actions revealed on hover | Keep them visible. Nothing important may live behind hover — see [Density](density.md). |
| `left`, `right`, `EdgeInsets.only(left:)` | Start and end. `EdgeInsetsDirectional`, and the components’ own logical parameters. |
| A heading size chosen for looks | `level` for the outline, `type` for the size. Skipping a level to get a size breaks the document; see [Typography](typography.md). |
| `if (Platform.isAndroid)` for touch sizing | Density resolves itself, from the platform *and* the pointer. |

## An order that works

1. Wrap one screen in `AstryxThemeProvider`. Nothing else changes; the Material widgets inside it carry on.
2. Replace the leaf controls — buttons, inputs, toggles. The compile errors are the audit: every icon button without a name, every input without a label.
3. Replace the containers — cards, banners, tables, dialogs. This is where `showDialog` becomes a widget and `SnackBar` becomes a toast.
4. Delete the literals. Colours, paddings, radii, durations, text styles. Anything that cannot be said with a token belongs in the theme definition.
5. Do the shell last, or not at all. It is the part with no counterpart yet, and it is the part users notice least.

> **Note**
>
> The test for step 4: switch the theme and the density with the pickers at the top of this page, then do the same in your app. Whatever stops looking right is a value a widget is still holding.

## Related

- [Installation](installation.md) — the provider, and the two import surfaces.
- [Principles](principles.md) — why the differences above are differences.
- [Design tokens](tokens.md) — what replaces the literals.
- [Accessibility](accessibility.md) — the rules the widgets enforce for you.

