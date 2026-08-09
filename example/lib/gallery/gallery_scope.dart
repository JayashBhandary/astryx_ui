import 'package:example/gallery/gallery_controller.dart';
import 'package:flutter/widgets.dart';

/// Exposes the [GalleryController] to the demo tree.
///
/// Demos read the current density and theme from here rather than holding their
/// own state, so every demo responds to the chrome's pickers for free.
class GalleryScope extends InheritedNotifier<GalleryController> {
  const GalleryScope({
    required GalleryController super.notifier,
    required super.child,
    super.key,
  });

  static GalleryController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GalleryScope>();
    assert(scope != null, 'No GalleryScope found in context');
    return scope!.notifier!;
  }
}
