import 'package:example/demos/action_demos.dart';
import 'package:example/demos/data_demos.dart';
import 'package:example/demos/form_demos.dart';
import 'package:example/demos/layout_demos.dart';
import 'package:example/demos/overlay_demos.dart';
import 'package:example/demos/status_demos.dart';
import 'package:example/demos/surface_demos.dart';
import 'package:example/demos/welcome_demo.dart';
import 'package:flutter/widgets.dart';

/// One page in the gallery.
///
/// Each phase adds its widgets here. Keep [group] aligned with the component
/// groups in `dev/reference/COMPONENT-INVENTORY.md` so the gallery's navigation
/// and the inventory stay recognisably the same list.
@immutable
class GalleryDemo {
  const GalleryDemo({
    required this.id,
    required this.title,
    required this.group,
    required this.builder,
  });

  /// Stable identifier. Also the golden-file prefix for this demo's widget.
  final String id;

  final String title;

  final String group;

  final WidgetBuilder builder;
}

/// Every demo in the gallery, in navigation order.
///
/// Phases 5–10 append to this list. It is intentionally flat —
/// [GalleryDemo.group] does the organising, so adding a widget is a one-line
/// change.
const List<GalleryDemo> galleryDemos = <GalleryDemo>[
  GalleryDemo(
    id: 'welcome',
    title: 'Welcome',
    group: 'About',
    builder: WelcomeDemo.build,
  ),
  GalleryDemo(
    id: 'text',
    title: 'Text',
    group: 'Layout & typography',
    builder: TextDemo.build,
  ),
  GalleryDemo(
    id: 'heading',
    title: 'Heading',
    group: 'Layout & typography',
    builder: HeadingDemo.build,
  ),
  GalleryDemo(
    id: 'stack',
    title: 'HStack & VStack',
    group: 'Layout & typography',
    builder: StackDemo.build,
  ),
  GalleryDemo(
    id: 'grid',
    title: 'Grid',
    group: 'Layout & typography',
    builder: GridDemo.build,
  ),
  GalleryDemo(
    id: 'center_divider',
    title: 'Center & Divider',
    group: 'Layout & typography',
    builder: CenterDividerDemo.build,
  ),
  GalleryDemo(
    id: 'icon',
    title: 'Icon',
    group: 'Layout & typography',
    builder: IconDemo.build,
  ),
  GalleryDemo(
    id: 'button',
    title: 'Button',
    group: 'Actions',
    builder: ButtonDemo.build,
  ),
  GalleryDemo(
    id: 'icon_button',
    title: 'IconButton',
    group: 'Actions',
    builder: IconButtonDemo.build,
  ),
  GalleryDemo(
    id: 'button_group',
    title: 'ButtonGroup',
    group: 'Actions',
    builder: ButtonGroupDemo.build,
  ),
  GalleryDemo(
    id: 'status',
    title: 'Spinner, Skeleton & ProgressBar',
    group: 'Status',
    builder: StatusDemo.build,
  ),
  GalleryDemo(
    id: 'text_input',
    title: 'TextInput & TextArea',
    group: 'Forms',
    builder: TextInputDemo.build,
  ),
  GalleryDemo(
    id: 'toggles',
    title: 'Checkbox, RadioList & Switch',
    group: 'Forms',
    builder: ToggleDemo.build,
  ),
  GalleryDemo(
    id: 'selector',
    title: 'Selector',
    group: 'Forms',
    builder: SelectorDemo.build,
  ),
  GalleryDemo(
    id: 'popover',
    title: 'Popover & Tooltip',
    group: 'Overlays',
    builder: PopoverDemo.build,
  ),
  GalleryDemo(
    id: 'dropdown_menu',
    title: 'DropdownMenu',
    group: 'Overlays',
    builder: DropdownMenuDemo.build,
  ),
  GalleryDemo(
    id: 'dialog_toast',
    title: 'Dialog & Toast',
    group: 'Overlays',
    builder: DialogToastDemo.build,
  ),
  GalleryDemo(
    id: 'card',
    title: 'Card',
    group: 'Surfaces & data',
    builder: CardDemo.build,
  ),
  GalleryDemo(
    id: 'badge_banner',
    title: 'Badge & Banner',
    group: 'Surfaces & data',
    builder: BadgeBannerDemo.build,
  ),
  GalleryDemo(
    id: 'tab_list',
    title: 'TabList',
    group: 'Surfaces & data',
    builder: TabListDemo.build,
  ),
  GalleryDemo(
    id: 'table',
    title: 'Table',
    group: 'Surfaces & data',
    builder: TableDemo.build,
  ),
];

/// [galleryDemos] bucketed by [GalleryDemo.group], preserving list order.
Map<String, List<GalleryDemo>> get galleryDemosByGroup {
  final grouped = <String, List<GalleryDemo>>{};
  for (final demo in galleryDemos) {
    grouped.putIfAbsent(demo.group, () => <GalleryDemo>[]).add(demo);
  }
  return grouped;
}
