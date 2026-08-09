/// The theme scope installer.
library;

import 'package:astryx_ui/src/components/overlay/toast.dart';
import 'package:astryx_ui/src/foundation/density.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/link_delegate.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/resolved_token_set.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Installs everything the Astryx widgets need: the theme scope, the icon
/// registry and the localisations.
///
/// Works **inside an existing app**, which is the common real-world case —
/// incremental adoption inside a `MaterialApp` or `CupertinoApp`. `AstryxApp`
/// composes this rather than duplicating it, so there is one implementation
/// and two entry points.
///
/// {@tool snippet}
/// ```dart
/// MaterialApp(
///   home: AstryxThemeProvider(
///     theme: neutralTheme,
///     child: const MyPage(),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxApp`, for an app built on Astryx alone.
///  * [AstryxTheme], the scope this installs.
class AstryxThemeProvider extends StatefulWidget {
  /// Creates a theme provider.
  const AstryxThemeProvider({
    required this.child,
    super.key,
    this.theme,
    this.mode = AstryxColorMode.system,
    this.density,
    this.icons,
    this.localizations = const AstryxLocalizations(),
    this.platform,
    this.linkDelegate,
    this.toastController,
    this.toastPosition,
  });

  /// The widget below this in the tree.
  final Widget child;

  /// The theme to resolve.
  ///
  /// When null, the Astryx defaults are used, which is a complete and usable
  /// theme rather than a placeholder.
  final AstryxDefinedTheme? theme;

  /// Which colour mode to resolve.
  ///
  /// [AstryxColorMode.system] follows the platform's own preference through
  /// `MediaQuery.platformBrightnessOf`, so the theme tracks a change without
  /// the app rebuilding anything itself.
  final AstryxColorMode mode;

  /// Overrides the resolved interaction density.
  ///
  /// When null, density is derived from the platform and from the pointer
  /// precision `MediaQuery` reports. See ADR-006.
  final AstryxDensity? density;

  /// The icon registry for this subtree.
  ///
  /// When null, [AstryxIconRegistry.defaults] is used, merged under any
  /// registry the theme itself carries.
  final AstryxIconRegistry? icons;

  /// The strings the widgets use. English by default.
  final AstryxLocalizations localizations;

  /// Overrides the platform used for density and font-stack resolution.
  ///
  /// Mainly for tests and for previewing another platform's rendering.
  final TargetPlatform? platform;

  /// Handles activation of a link inside an Astryx widget.
  ///
  /// When null, [AstryxLinkDelegate.none] applies: nothing happens, with a
  /// debug warning. Navigation is the application's concern.
  final AstryxLinkDelegate? linkDelegate;

  /// The controller the toast host renders from.
  ///
  /// When null the provider owns one, which is what makes
  /// `AstryxToastScope.of(context).show(…)` work with no setup — the `P3-5`
  /// commitment that toasts need no extra wiring.
  final AstryxToastController? toastController;

  /// Where the toast stack sits.
  ///
  /// When null it follows the resolved density: a corner on pointer, the
  /// bottom leading edge on touch.
  final AstryxToastPosition? toastPosition;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<AstryxDefinedTheme>(
          'theme',
          theme,
          defaultValue: null,
        ),
      )
      ..add(EnumProperty<AstryxColorMode>('mode', mode))
      ..add(
        EnumProperty<AstryxDensity>('density', density, defaultValue: null),
      )
      ..add(
        EnumProperty<TargetPlatform>('platform', platform, defaultValue: null),
      );
  }

  @override
  State<AstryxThemeProvider> createState() => _AstryxThemeProviderState();
}

class _AstryxThemeProviderState extends State<AstryxThemeProvider> {
  AstryxToastController? _internalToasts;

  AstryxToastController get _toasts =>
      widget.toastController ?? (_internalToasts ??= AstryxToastController());

  @override
  void dispose() {
    _internalToasts?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    final target = widget.platform ?? defaultTargetPlatform;

    final themeData = AstryxThemeData(
      tokens: widget.theme == null
          ? AstryxResolvedTokenSet.defaults
          : AstryxResolvedTokenSet.resolve(widget.theme),
      mode: widget.mode.resolve(media?.platformBrightness ?? Brightness.light),
      platform: target,
    );

    return AstryxTheme(
      data: themeData,
      density: widget.density ?? AstryxDensity.resolve(target),
      icons: widget.icons ?? AstryxIconRegistry.defaults,
      child: AstryxLocalizationsScope(
        localizations: widget.localizations,
        child: AstryxLinkScope(
          delegate: widget.linkDelegate ?? AstryxLinkDelegate.none,
          // Innermost, so it wraps only the app content and its `Listener`
          // sits below any scaffolding the consumer put above the provider.
          child: AstryxFocusVisibleScope(
            child: AstryxToastScope(
              notifier: _toasts,
              // Inside the scope, so a toast resolves the same theme,
              // density and localisations as the app it belongs to.
              child: Builder(
                builder: (context) => AstryxToastHost(
                  controller: _toasts,
                  position: widget.toastPosition,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
