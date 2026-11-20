/// The playground's theme: what the theme editor edits, as one value.
///
/// Pure Dart apart from the theme engine. Every field that is null means
/// "inherit from the base theme" — the editor only adds to `defineTheme` what
/// the reader has actually touched, so picking a base theme and changing one
/// thing gives that base with one thing changed, not a different theme.
// The export writes Dart source line by line; adjacent literals there are
// deliberate fragments of one generated line.
// ignore_for_file: missing_whitespace_between_adjacent_strings, lines_longer_than_80_chars, prefer_constructors_over_static_methods
library;

import 'dart:convert';

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs_ui/docs_controller.dart';

/// The colour tokens the editor exposes, in display order.
const List<(String, String)> playgroundColorTokens = <(String, String)>[
  ('--color-neutral', 'Neutral'),
  ('--color-background-card', 'Card'),
  ('--color-background-surface', 'Surface'),
  ('--color-background-body', 'Body'),
  ('--color-background-muted', 'Muted'),
  ('--color-text-primary', 'Text primary'),
];

/// Spacing tokens and their default pixel values, scaled by the spacing
/// multiplier.
const Map<String, double> playgroundSpacingDefaults = <String, double>{
  '--spacing-0-5': 2,
  '--spacing-1': 4,
  '--spacing-1-5': 6,
  '--spacing-2': 8,
  '--spacing-3': 12,
  '--spacing-4': 16,
  '--spacing-5': 20,
  '--spacing-6': 24,
  '--spacing-7': 28,
  '--spacing-8': 32,
  '--spacing-9': 36,
  '--spacing-10': 40,
  '--spacing-11': 44,
  '--spacing-12': 48,
};

/// Element-size tokens and their defaults, scaled by the element multiplier.
const Map<String, double> playgroundElementDefaults = <String, double>{
  '--size-element-sm': 28,
  '--size-element-md': 32,
  '--size-element-lg': 36,
};

/// A named type-scale ratio.
const List<(double, String)> playgroundTypeRatios = <(double, String)>[
  (1.125, '1.125 — Major Second'),
  (1.2, '1.200 — Minor Third'),
  (1.25, '1.250 — Major Third'),
  (1.333, '1.333 — Perfect Fourth'),
  (1.5, '1.500 — Perfect Fifth'),
];

/// The S / M / L / XL steps the editor offers for each scale.
enum PlaygroundStep {
  s('S'),
  m('M'),
  l('L'),
  xl('XL');

  const PlaygroundStep(this.label);

  final String label;
}

/// Base font size per step, in pixels.
const Map<PlaygroundStep, double> playgroundTypeSizes =
    <PlaygroundStep, double>{
      PlaygroundStep.s: 13,
      PlaygroundStep.m: 14,
      PlaygroundStep.l: 16,
      PlaygroundStep.xl: 18,
    };

/// Radius multiplier per step, over a base of 4.
const Map<PlaygroundStep, double> playgroundRadii = <PlaygroundStep, double>{
  PlaygroundStep.s: 0.5,
  PlaygroundStep.m: 1,
  PlaygroundStep.l: 1.5,
  PlaygroundStep.xl: 2.5,
};

/// Spacing multiplier per step.
const Map<PlaygroundStep, double> playgroundSpacings = <PlaygroundStep, double>{
  PlaygroundStep.s: 0.75,
  PlaygroundStep.m: 1,
  PlaygroundStep.l: 1.25,
  PlaygroundStep.xl: 1.5,
};

/// Element-size multipliers offered.
const List<double> playgroundElementScales = <double>[0.875, 1, 1.25, 1.5];

/// Motion presets: (label, fast, medium, slow).
const List<(String, double, double, double)> playgroundMotions =
    <(String, double, double, double)>[
      ('Snappy', 100, 250, 600),
      ('Default', 125, 300, 700),
      ('Relaxed', 150, 350, 800),
      ('Cinematic', 200, 480, 1100),
    ];

/// The four whole-theme density presets: (label, spacing, element size).
const List<(String, double, double)> playgroundDensities =
    <(String, double, double)>[
      ('Compact', 0.75, 0.875),
      ('Default', 1, 1),
      ('Comfortable', 1.25, 1.25),
      ('Gigantic', 1.5, 1.5),
    ];

/// One colour token override: a value per mode. Either half may be null.
class PlaygroundColor {
  const PlaygroundColor({this.light, this.dark});

  final String? light;
  final String? dark;

  PlaygroundColor withMode({required bool dark, required String? value}) => dark
      ? PlaygroundColor(light: light, dark: value)
      : PlaygroundColor(light: value, dark: this.dark);

  bool get isEmpty => light == null && dark == null;

  Map<String, String> toJson() => <String, String>{
    'l': ?light,
    'd': ?dark,
  };

  static PlaygroundColor fromJson(Map<String, dynamic> json) =>
      PlaygroundColor(light: json['l'] as String?, dark: json['d'] as String?);
}

/// The theme being edited.
class PlaygroundTheme {
  const PlaygroundTheme({
    this.name = 'my_theme',
    this.base = DocsTheme.neutral,
    this.accent,
    this.neutralStyle,
    this.contrast,
    this.colors = const <String, PlaygroundColor>{},
    this.headingFont,
    this.bodyFont,
    this.typeBase,
    this.typeRatio,
    this.radiusMultiplier,
    this.spacingScale,
    this.elementScale,
    this.motion,
  });

  /// The name the export uses.
  final String name;

  /// The theme this one extends.
  final DocsTheme base;

  /// The seed accent, `#rrggbb`. Null keeps the base theme's palette.
  final String? accent;
  final AstryxNeutralStyle? neutralStyle;
  final AstryxContrastLevel? contrast;

  /// Explicit colour token overrides, by token name.
  final Map<String, PlaygroundColor> colors;

  final String? headingFont;
  final String? bodyFont;

  /// Base font size in pixels.
  final double? typeBase;

  /// Type-scale ratio.
  final double? typeRatio;

  /// Radius multiplier over a base of 4.
  final double? radiusMultiplier;

  /// Multiplier on every spacing token.
  final double? spacingScale;

  /// Multiplier on the element sizes.
  final double? elementScale;

  /// Index into [playgroundMotions].
  final int? motion;

  /// Whether anything differs from the base theme.
  bool get isEdited =>
      accent != null ||
      neutralStyle != null ||
      contrast != null ||
      colors.values.any((c) => !c.isEmpty) ||
      headingFont != null ||
      bodyFont != null ||
      typeBase != null ||
      typeRatio != null ||
      radiusMultiplier != null ||
      spacingScale != null ||
      elementScale != null ||
      motion != null;

  PlaygroundTheme copyWith({
    String? name,
    DocsTheme? base,
    String? Function()? accent,
    AstryxNeutralStyle? Function()? neutralStyle,
    AstryxContrastLevel? Function()? contrast,
    Map<String, PlaygroundColor>? colors,
    String? Function()? headingFont,
    String? Function()? bodyFont,
    double? Function()? typeBase,
    double? Function()? typeRatio,
    double? Function()? radiusMultiplier,
    double? Function()? spacingScale,
    double? Function()? elementScale,
    int? Function()? motion,
  }) => PlaygroundTheme(
    name: name ?? this.name,
    base: base ?? this.base,
    accent: accent != null ? accent() : this.accent,
    neutralStyle: neutralStyle != null ? neutralStyle() : this.neutralStyle,
    contrast: contrast != null ? contrast() : this.contrast,
    colors: colors ?? this.colors,
    headingFont: headingFont != null ? headingFont() : this.headingFont,
    bodyFont: bodyFont != null ? bodyFont() : this.bodyFont,
    typeBase: typeBase != null ? typeBase() : this.typeBase,
    typeRatio: typeRatio != null ? typeRatio() : this.typeRatio,
    radiusMultiplier: radiusMultiplier != null
        ? radiusMultiplier()
        : this.radiusMultiplier,
    spacingScale: spacingScale != null ? spacingScale() : this.spacingScale,
    elementScale: elementScale != null ? elementScale() : this.elementScale,
    motion: motion != null ? motion() : this.motion,
  );

  /// Sets one half of a colour override.
  PlaygroundTheme withColor(String token, {required bool dark, String? value}) {
    final next = Map<String, PlaygroundColor>.of(colors);
    final updated = (next[token] ?? const PlaygroundColor()).withMode(
      dark: dark,
      value: value,
    );
    if (updated.isEmpty) {
      next.remove(token);
    } else {
      next[token] = updated;
    }
    return copyWith(colors: next);
  }

  /// The explicit token overrides this theme adds.
  Map<String, AstryxTokenValue> get tokenOverrides {
    final tokens = <String, AstryxTokenValue>{};
    final baseTokens = base.theme.tokens;
    for (final entry in colors.entries) {
      final c = entry.value;
      if (c.isEmpty) continue;
      final (baseLight, baseDark) = splitLightDark(baseTokens[entry.key]);
      final light = c.light ?? baseLight;
      final dark = c.dark ?? baseDark;
      tokens[entry.key] = light == dark
          ? AstryxTokenValue(light)
          : AstryxTokenValue.lightDark(light, dark);
    }
    if (spacingScale != null) {
      for (final e in playgroundSpacingDefaults.entries) {
        tokens[e.key] = AstryxTokenValue(_px(e.value * spacingScale!));
      }
    }
    if (elementScale != null) {
      for (final e in playgroundElementDefaults.entries) {
        tokens[e.key] = AstryxTokenValue(_px(e.value * elementScale!));
      }
    }
    return tokens;
  }

  /// The `defineTheme` input.
  AstryxDefineThemeInput toInput() {
    final hasColor = accent != null || neutralStyle != null || contrast != null;
    final hasType =
        typeBase != null ||
        typeRatio != null ||
        headingFont != null ||
        bodyFont != null;
    final motionPreset = motion == null ? null : playgroundMotions[motion!];
    final tokens = tokenOverrides;

    return AstryxDefineThemeInput(
      name: name,
      extendsTheme: base.theme,
      color: hasColor
          ? AstryxColorScaleConfig(
              accent: accent,
              neutralStyle: neutralStyle ?? AstryxNeutralStyle.cool,
              contrast: contrast ?? AstryxContrastLevel.standard,
            )
          : null,
      typography: hasType
          ? AstryxTypographyConfig(
              scale: typeBase != null || typeRatio != null
                  ? AstryxTypeScaleSpec(
                      base: typeBase ?? 14,
                      ratio: typeRatio ?? 1.2,
                    )
                  : null,
              heading: headingFont == null
                  ? null
                  : AstryxTypographyRole(family: headingFont),
              body: bodyFont == null
                  ? null
                  : AstryxTypographyRole(family: bodyFont),
            )
          : null,
      radius: radiusMultiplier == null
          ? null
          : AstryxRadiusScaleConfig(base: 4, multiplier: radiusMultiplier!),
      motion: motionPreset == null
          ? null
          : AstryxMotionScaleConfig(
              fast: motionPreset.$2,
              medium: motionPreset.$3,
              slow: motionPreset.$4,
              ratio: 0.75,
            ),
      tokens: tokens.isEmpty ? null : tokens,
    );
  }

  /// The resolved theme.
  AstryxDefinedTheme build() => defineTheme(toInput());

  /// The Dart a reader pastes into their app to get this theme.
  String toDartSource() {
    final id = _identifier(name);
    final b = StringBuffer()
      ..writeln("import 'package:astryx_ui/astryx_ui.dart';")
      ..writeln()
      ..writeln('/// Exported from the astryx_ui playground.')
      ..writeln('final AstryxDefinedTheme $id = defineTheme(')
      ..writeln('  AstryxDefineThemeInput(')
      ..writeln("    name: '${_escape(name)}',")
      ..writeln('    extendsTheme: ${_baseIdentifier(base)},');

    if (accent != null || neutralStyle != null || contrast != null) {
      b
        ..writeln('    color: const AstryxColorScaleConfig(')
        ..writeln(accent == null ? '' : "      accent: '$accent',")
        ..writeln(
          neutralStyle == null
              ? ''
              : '      neutralStyle: AstryxNeutralStyle.${neutralStyle!.name},',
        )
        ..writeln(
          contrast == null
              ? ''
              : '      contrast: AstryxContrastLevel.${contrast!.name},',
        )
        ..writeln('    ),');
    }
    if (typeBase != null ||
        typeRatio != null ||
        headingFont != null ||
        bodyFont != null) {
      b.writeln('    typography: const AstryxTypographyConfig(');
      if (typeBase != null || typeRatio != null) {
        b.writeln(
          '      scale: AstryxTypeScaleSpec('
          'base: ${_num(typeBase ?? 14)}, ratio: ${_num(typeRatio ?? 1.2)}),',
        );
      }
      if (headingFont != null) {
        b.writeln(
          "      heading: AstryxTypographyRole(family: '${_escape(headingFont!)}'),",
        );
      }
      if (bodyFont != null) {
        b.writeln(
          "      body: AstryxTypographyRole(family: '${_escape(bodyFont!)}'),",
        );
      }
      b.writeln('    ),');
    }
    if (radiusMultiplier != null) {
      b.writeln(
        '    radius: const AstryxRadiusScaleConfig('
        'base: 4, multiplier: ${_num(radiusMultiplier!)}),',
      );
    }
    if (motion != null) {
      final m = playgroundMotions[motion!];
      b.writeln(
        '    motion: const AstryxMotionScaleConfig('
        'fast: ${_num(m.$2)}, medium: ${_num(m.$3)}, '
        'slow: ${_num(m.$4)}, ratio: 0.75),',
      );
    }
    final tokens = tokenOverrides;
    if (tokens.isNotEmpty) {
      b.writeln('    tokens: const <String, AstryxTokenValue>{');
      for (final e in tokens.entries) {
        final (light, dark) = splitLightDark(e.value.css);
        b.writeln(
          light == dark
              ? "      '${e.key}': AstryxTokenValue('$light'),"
              : "      '${e.key}': AstryxTokenValue.lightDark("
                    "'$light', '$dark'),",
        );
      }
      b.writeln('    },');
    }
    b
      ..writeln('  ),')
      ..writeln(');');
    // Drop the blank lines left by omitted optional fields.
    final lines = b.toString().split('\n').where((l) => l.isNotEmpty);
    return '${lines.join('\n')}\n';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'n': name,
    'b': base.name,
    if (accent != null) 'a': accent,
    if (neutralStyle != null) 'ns': neutralStyle!.name,
    if (contrast != null) 'c': contrast!.name,
    if (colors.isNotEmpty)
      'co': <String, dynamic>{
        for (final e in colors.entries) e.key: e.value.toJson(),
      },
    if (headingFont != null) 'hf': headingFont,
    if (bodyFont != null) 'bf': bodyFont,
    if (typeBase != null) 'tb': typeBase,
    if (typeRatio != null) 'tr': typeRatio,
    if (radiusMultiplier != null) 'r': radiusMultiplier,
    if (spacingScale != null) 's': spacingScale,
    if (elementScale != null) 'e': elementScale,
    if (motion != null) 'm': motion,
  };

  static PlaygroundTheme fromJson(Map<String, dynamic> json) {
    T? byName<T extends Enum>(List<T> values, Object? name) =>
        values.where((v) => v.name == name).firstOrNull;
    double? number(Object? v) => (v as num?)?.toDouble();
    final motion = json['m'] as int?;
    return PlaygroundTheme(
      name: (json['n'] as String?) ?? 'my_theme',
      base: byName(DocsTheme.values, json['b']) ?? DocsTheme.neutral,
      accent: json['a'] as String?,
      neutralStyle: byName(AstryxNeutralStyle.values, json['ns']),
      contrast: byName(AstryxContrastLevel.values, json['c']),
      colors: <String, PlaygroundColor>{
        for (final e
            in ((json['co'] as Map<String, dynamic>?) ??
                    const <String, dynamic>{})
                .entries)
          e.key: PlaygroundColor.fromJson(e.value as Map<String, dynamic>),
      },
      headingFont: json['hf'] as String?,
      bodyFont: json['bf'] as String?,
      typeBase: number(json['tb']),
      typeRatio: number(json['tr']),
      radiusMultiplier: number(json['r']),
      spacingScale: number(json['s']),
      elementScale: number(json['e']),
      motion: motion != null && motion >= 0 && motion < playgroundMotions.length
          ? motion
          : null,
    );
  }

  /// URL-safe encoding for the share link.
  String encode() => base64Url.encode(utf8.encode(jsonEncode(toJson())));

  /// The inverse of [encode]; null for anything it cannot read.
  static PlaygroundTheme? decode(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      final json = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(value))),
      );
      return json is Map<String, dynamic> ? fromJson(json) : null;
    } on Object {
      return null;
    }
  }
}

/// `light-dark(a, b)` → (a, b); a single value → (v, v).
(String, String) splitLightDark(String? css) {
  final value = (css ?? '').trim();
  final match = RegExp(r'^light-dark\((.*)\)$').firstMatch(value);
  if (match == null) return (value, value);
  // Split on the top-level comma only: either half may be `rgba(…, …)`.
  final inner = match.group(1)!;
  var depth = 0;
  for (var i = 0; i < inner.length; i++) {
    final ch = inner[i];
    if (ch == '(') depth++;
    if (ch == ')') depth--;
    if (ch == ',' && depth == 0) {
      return (inner.substring(0, i).trim(), inner.substring(i + 1).trim());
    }
  }
  return (inner.trim(), inner.trim());
}

/// Whether [value] is a hex colour the engine accepts.
bool isHexColor(String value) => RegExp(
  r'^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
).hasMatch(value);

String _px(double value) => '${_num(value.roundToDouble())}px';

String _num(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toString();

String _escape(String value) =>
    value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");

/// A Dart identifier from a free-text theme name: `My theme` → `myTheme`.
String _identifier(String name) {
  final words = name
      .split(RegExp('[^A-Za-z0-9]+'))
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return 'myTheme';
  final id = StringBuffer(words.first.toLowerCase());
  for (final w in words.skip(1)) {
    id.write(w[0].toUpperCase() + w.substring(1).toLowerCase());
  }
  var result = id.toString();
  if (RegExp('^[0-9]').hasMatch(result)) result = 'theme$result';
  return result.endsWith('Theme') ? result : '${result}Theme';
}

String _baseIdentifier(DocsTheme theme) => '${theme.name}Theme';
