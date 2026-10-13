/// Re-styling the components of one subtree.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/components/component_themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Applies [data] over the component themes in effect, for [child] only.
///
/// The subtree counterpart of `AstryxApp.componentThemes`, and what Material's
/// `Theme(data: Theme.of(context).copyWith(…))` is for. It **merges** rather
/// than replaces: a bundle that sets only a button radius keeps the button
/// colours an outer scope set, and every other slot as it was. Nest them
/// freely.
///
/// The token set, colour mode, density and icon registry all carry through
/// untouched — only component themes change.
///
/// {@tool snippet}
/// ```dart
/// AstryxComponentTheme(
///   data: const AstryxComponentThemes(
///     button: AstryxButtonTheme(borderRadius: BorderRadius.zero),
///   ),
///   child: const Toolbar(),
/// )
/// ```
/// {@end-tool}
///
/// Requires an `AstryxTheme` above it — install one with `AstryxApp` or
/// `AstryxThemeProvider`.
class AstryxComponentTheme extends StatelessWidget {
  /// Applies [data] over the enclosing component themes.
  const AstryxComponentTheme({
    required this.data,
    required this.child,
    super.key,
  });

  /// The component themes to merge over the enclosing ones.
  final AstryxComponentThemes data;

  /// The subtree the themes apply to.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final parent = AstryxTheme.of(context);
    // The raw scope rather than `densityOf`/`iconsOf`: those resolve a
    // fallback when the scope left the value null, and copying the fallback
    // down would freeze it instead of letting it keep following the platform.
    final scope = context.getInheritedWidgetOfExactType<AstryxTheme>();

    return AstryxTheme(
      data: parent.mergeComponents(data),
      density: scope?.density,
      icons: scope?.icons,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AstryxComponentThemes>('data', data));
  }
}
