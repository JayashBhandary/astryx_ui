/// The navigation seam.
library;

import 'package:flutter/widgets.dart';

/// Handles activation of a link inside an Astryx widget.
///
/// Upstream's `LinkProvider` lets a consumer swap in their router; components
/// call `useLinkComponent()` rather than rendering an `<a>`. This is the same
/// seam: a widget with an `href` calls the delegate and never decides what
/// navigation means.
///
/// Navigation is the application's concern. The design system's job is to leave
/// a hole the right shape.
///
/// {@tool snippet}
/// ```dart
/// AstryxLinkScope(
///   delegate: AstryxLinkDelegate.fromCallback((uri, {target}) {
///     GoRouter.of(context).go(uri.toString());
///   }),
///   child: const MyApp(),
/// )
/// ```
/// {@end-tool}
abstract class AstryxLinkDelegate {
  /// Enables subclasses to be const.
  const AstryxLinkDelegate();

  /// Builds a delegate from a callback.
  const factory AstryxLinkDelegate.fromCallback(AstryxLinkCallback onFollow) =
      _CallbackLinkDelegate;

  /// The default delegate: warns in debug, does nothing in release.
  ///
  /// Doing nothing is the honest default. Guessing — launching a URL, pushing a
  /// route — would be a surprising side effect from a package that knows
  /// nothing about the app's navigation.
  static const AstryxLinkDelegate none = _NoopLinkDelegate();

  /// Follows [uri].
  ///
  /// [target] carries a hint about where to open, for the web. Implementations
  /// on other platforms may ignore it.
  void followLink(Uri uri, {String? target});

  /// The delegate at [context], or [none] if no scope is installed.
  static AstryxLinkDelegate of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxLinkScope>()?.delegate ??
      none;
}

/// The signature [AstryxLinkDelegate.fromCallback] takes.
typedef AstryxLinkCallback = void Function(Uri uri, {String? target});

class _CallbackLinkDelegate extends AstryxLinkDelegate {
  const _CallbackLinkDelegate(this._onFollow);

  final AstryxLinkCallback _onFollow;

  @override
  void followLink(Uri uri, {String? target}) => _onFollow(uri, target: target);
}

class _NoopLinkDelegate extends AstryxLinkDelegate {
  const _NoopLinkDelegate();

  @override
  void followLink(Uri uri, {String? target}) {
    assert(() {
      debugPrint(
        'astryx_ui: a link to "$uri" was activated, but no '
        'AstryxLinkDelegate is installed, so nothing happened.\n'
        'Wrap your app in an AstryxLinkScope to connect your router.',
      );
      return true;
    }(), '');
  }
}

/// Makes an [AstryxLinkDelegate] available to the widgets beneath it.
class AstryxLinkScope extends InheritedWidget {
  /// Creates a link scope.
  const AstryxLinkScope({
    required this.delegate,
    required super.child,
    super.key,
  });

  /// The delegate for this subtree.
  final AstryxLinkDelegate delegate;

  @override
  bool updateShouldNotify(AstryxLinkScope oldWidget) =>
      delegate != oldWidget.delegate;
}
