/// Every per-widget theme, as one value.
library;

import 'package:astryx_ui/src/theme/components/button.dart';
import 'package:astryx_ui/src/theme/components/divider.dart';
import 'package:astryx_ui/src/theme/components/icon.dart';
import 'package:astryx_ui/src/theme/components/text.dart';
import 'package:flutter/foundation.dart';

/// The per-widget themes an app or a subtree applies, bundled.
///
/// This is the component half of what Material's `ThemeData` carries — the
/// `buttonTheme`, `dividerTheme`, `iconTheme` and `textTheme` slots — kept
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
  }) => AstryxComponentThemes(
    button: button ?? this.button,
    text: text ?? this.text,
    heading: heading ?? this.heading,
    divider: divider ?? this.divider,
    icon: icon ?? this.icon,
  );

  /// Returns a copy with every non-null field of [other] applied over this,
  /// slot by slot.
  ///
  /// This is how a nested `AstryxComponentTheme` combines with the one above
  /// it: an inner bundle that sets only a button radius keeps the outer
  /// bundle's button colours, and its dividers, untouched.
  AstryxComponentThemes merge(AstryxComponentThemes? other) {
    if (other == null) return this;
    return AstryxComponentThemes(
      button: button.merge(other.button),
      text: text.merge(other.text),
      heading: heading.merge(other.heading),
      divider: divider.merge(other.divider),
      icon: icon.merge(other.icon),
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
      button:
          AstryxButtonTheme.lerp(a?.button, b?.button, t) ??
          const AstryxButtonTheme(),
      text:
          AstryxTextTheme.lerp(a?.text, b?.text, t) ?? const AstryxTextTheme(),
      heading:
          AstryxTextTheme.lerp(a?.heading, b?.heading, t) ??
          const AstryxTextTheme(),
      divider:
          AstryxDividerTheme.lerp(a?.divider, b?.divider, t) ??
          const AstryxDividerTheme(),
      icon:
          AstryxIconTheme.lerp(a?.icon, b?.icon, t) ?? const AstryxIconTheme(),
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
          other.icon == icon;

  @override
  int get hashCode => Object.hash(button, text, heading, divider, icon);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const empty = AstryxComponentThemes();
    properties
      ..add(
        DiagnosticsProperty<AstryxButtonTheme>(
          'button',
          button,
          defaultValue: empty.button,
        ),
      )
      ..add(
        DiagnosticsProperty<AstryxTextTheme>(
          'text',
          text,
          defaultValue: empty.text,
        ),
      )
      ..add(
        DiagnosticsProperty<AstryxTextTheme>(
          'heading',
          heading,
          defaultValue: empty.heading,
        ),
      )
      ..add(
        DiagnosticsProperty<AstryxDividerTheme>(
          'divider',
          divider,
          defaultValue: empty.divider,
        ),
      )
      ..add(
        DiagnosticsProperty<AstryxIconTheme>(
          'icon',
          icon,
          defaultValue: empty.icon,
        ),
      );
  }
}
