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
];

/// [galleryDemos] bucketed by [GalleryDemo.group], preserving list order.
Map<String, List<GalleryDemo>> get galleryDemosByGroup {
  final grouped = <String, List<GalleryDemo>>{};
  for (final demo in galleryDemos) {
    grouped.putIfAbsent(demo.group, () => <GalleryDemo>[]).add(demo);
  }
  return grouped;
}
