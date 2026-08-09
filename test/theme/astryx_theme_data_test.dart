import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_color_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_radius_scale.dart';
import 'package:astryx_ui/src/theme/engine/theme_registry.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/resolved_token_set.dart';
import 'package:astryx_ui/src/theme/token_conversions.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';
import '../support/theme_input.dart';

/// Tests for the string → Flutter value layer.
void main() {
  tearDown(resetThemes);

  AstryxThemeData dataFor(
    AstryxThemeMode mode, {
    AstryxDefinedTheme? theme,
    TargetPlatform platform = TargetPlatform.macOS,
  }) => AstryxThemeData.resolve(
    mode: mode,
    theme: theme,
    platform: platform,
  );

  final light = dataFor(AstryxThemeMode.light);
  final dark = dataFor(AstryxThemeMode.dark);

  group('colours', () {
    test('resolves the defaults for each mode', () {
      expect(light.color(AstryxColorToken.accent), const Color(0xFF0064E0));
      expect(dark.color(AstryxColorToken.accent), const Color(0xFF2694FE));
      expect(
        light.color(AstryxColorToken.textPrimary),
        const Color(0xFF0A1317),
      );
    });

    test('carries alpha through', () {
      // --color-neutral is rgba(5, 54, 89, 0.1) in light mode.
      expect(light.color(AstryxColorToken.neutral).a, closeTo(0.1, 0.01));
    });

    test('resolves every colour token in both modes', () {
      for (final token in AstryxColorToken.values) {
        expect(() => light.color(token), returnsNormally, reason: token.name);
        expect(() => dark.color(token), returnsNormally, reason: token.name);
      }
    });

    test('brightness follows the mode', () {
      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
    });
  });

  group('lengths', () {
    test('strips px from spacing, size and radius', () {
      expect(light.spacing(AstryxSpacingToken.spacing0), 0.0);
      expect(light.spacing(AstryxSpacingToken.spacing4), 16.0);
      expect(light.size(AstryxSizeToken.elementMd), 32.0);
      expect(light.radius(AstryxRadiusToken.element), 8.0);
      expect(light.radius(AstryxRadiusToken.full), 9999.0);
      expect(light.borderWidth(), 1.0);
    });

    test('converts rem font sizes against the 16px root', () {
      expect(light.textSize(AstryxTextSizeToken.base), 14.0); // 0.875rem
      expect(light.textSize(AstryxTextSizeToken.twoXl), 24.0); // 1.5rem
    });

    test('exposes a radius as a BorderRadius', () {
      expect(
        light.borderRadius(AstryxRadiusToken.element),
        BorderRadius.circular(8),
      );
    });

    test('resolves every length token', () {
      for (final token in AstryxSpacingToken.values) {
        expect(() => light.spacing(token), returnsNormally, reason: token.name);
      }
      for (final token in AstryxRadiusToken.values) {
        expect(() => light.radius(token), returnsNormally, reason: token.name);
      }
      for (final token in AstryxSizeToken.values) {
        expect(() => light.size(token), returnsNormally, reason: token.name);
      }
      for (final token in AstryxTextSizeToken.values) {
        expect(
          () => light.textSize(token),
          returnsNormally,
          reason: token.name,
        );
      }
    });
  });

  group('durations and easing', () {
    test('converts ms durations', () {
      expect(
        light.duration(AstryxDurationToken.fast),
        const Duration(milliseconds: 175),
      );
      expect(
        light.duration(AstryxDurationToken.slow),
        const Duration(milliseconds: 975),
      );
    });

    test('converts the standard easing to a Cubic', () {
      final curve = light.ease();
      expect(curve, isA<Cubic>());
      final cubic = curve as Cubic;
      expect(
        <double>[cubic.a, cubic.b, cubic.c, cubic.d],
        <double>[
          0.24,
          1,
          0.4,
          1,
        ],
      );
    });

    test('resolves every duration token', () {
      for (final token in AstryxDurationToken.values) {
        expect(
          () => light.duration(token),
          returnsNormally,
          reason: token.name,
        );
      }
    });
  });

  group('font weights', () {
    test('maps the numeric steps', () {
      expect(
        light.fontWeight(AstryxFontWeightToken.normal),
        FontWeight.w400,
      );
      expect(
        light.fontWeight(AstryxFontWeightToken.medium),
        FontWeight.w500,
      );
      expect(
        light.fontWeight(AstryxFontWeightToken.semibold),
        FontWeight.w600,
      );
      expect(light.fontWeight(AstryxFontWeightToken.bold), FontWeight.w700);
    });
  });

  group('shadows', () {
    test('parses a multi-layer shadow token', () {
      final shadows = light.shadow(AstryxShadowToken.low);
      expect(shadows, hasLength(2));
      expect(shadows.every((s) => !s.inset), isTrue);
    });

    test('marks the inset tokens as inset', () {
      for (final token in <AstryxShadowToken>[
        AstryxShadowToken.insetHover,
        AstryxShadowToken.insetSelected,
        AstryxShadowToken.insetSuccess,
        AstryxShadowToken.insetWarning,
        AstryxShadowToken.insetError,
      ]) {
        expect(
          light.shadow(token).every((s) => s.inset),
          isTrue,
          reason: token.name,
        );
      }
    });

    test('boxShadows drops the inset layers', () {
      expect(light.boxShadows(AstryxShadowToken.insetSelected), isEmpty);
      expect(light.boxShadows(AstryxShadowToken.low), hasLength(2));
    });

    test('converts the blur radius out of CSS units', () {
      // --shadow-low's second layer has an 8px CSS blur.
      final layer = light.shadow(AstryxShadowToken.low)[1];
      expect(
        layer.blurRadius,
        closeTo(astryxCssBlurToFlutterRadius(8), 1e-9),
      );
      // Not the rough B / 2 convention the phase plan noted.
      expect(layer.blurRadius, isNot(closeTo(4, 0.5)));
    });

    test('resolves every shadow token in both modes', () {
      for (final token in AstryxShadowToken.values) {
        expect(light.shadow(token), isNotEmpty, reason: token.name);
        expect(dark.shadow(token), isNotEmpty, reason: token.name);
      }
    });
  });

  group('text styles', () {
    test('assembles size, weight and line height per role', () {
      final body = light.textStyle(AstryxTypeRole.body);
      expect(body.fontSize, 14.0);
      expect(body.fontWeight, FontWeight.w400);
      expect(body.height, closeTo(1.4286, 1e-9));
    });

    test('uses even leading distribution, so text is not seated high', () {
      for (final role in AstryxTypeRole.values) {
        expect(
          light.textStyle(role).leadingDistribution,
          TextLeadingDistribution.even,
          reason: role.name,
        );
      }
    });

    test('headings carry the semibold default', () {
      expect(
        light.textStyle(AstryxTypeRole.heading1).fontWeight,
        FontWeight.w600,
      );
      expect(light.textStyle(AstryxTypeRole.heading1).fontSize, 24.0);
    });

    test('the code role uses the code font stack', () {
      final code = light.textStyle(AstryxTypeRole.code);
      final body = light.textStyle(AstryxTypeRole.body);
      expect(code.fontFamily, 'SF Mono');
      expect(body.fontFamily, isNull); // the system stack
    });

    test('headingStyle matches the role', () {
      for (var level = 1; level <= 6; level++) {
        expect(
          light.headingStyle(level),
          light.textStyle(AstryxTypeRole.heading(level)),
        );
      }
    });

    test('every role resolves to a complete style', () {
      for (final role in AstryxTypeRole.values) {
        final style = light.textStyle(role);
        expect(style.fontSize, isNotNull, reason: role.name);
        expect(style.fontWeight, isNotNull, reason: role.name);
        expect(style.height, isNotNull, reason: role.name);
      }
    });

    test('a type-scale weight is not misfiled as a length', () {
      // `--text-heading-1-weight` is `600`, which parses as a length too. If
      // classification were prefix-based it would land in the lengths map and
      // the style would come out weightless.
      expect(
        light.textStyle(AstryxTypeRole.heading1).fontWeight,
        FontWeight.w600,
      );
    });
  });

  group('font stacks', () {
    test('resolves the three typography tokens', () {
      expect(light.fontStack(AstryxTypographyToken.body).family, isNull);
      expect(light.fontStack(AstryxTypographyToken.heading).family, isNull);
      expect(light.fontStack(AstryxTypographyToken.code).family, 'SF Mono');
    });

    test('the platform reaches the stack resolution', () {
      final windows = dataFor(
        AstryxThemeMode.light,
        platform: TargetPlatform.windows,
      );
      expect(
        windows.fontStack(AstryxTypographyToken.code).fallbacks,
        contains('Consolas'),
      );
    });
  });

  group('themed', () {
    test('a scale config reaches the Flutter values', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'sharp',
          radius: AstryxRadiusScaleConfig(base: 4, multiplier: 0),
        ),
      );
      final data = dataFor(AstryxThemeMode.light, theme: theme);
      expect(data.radius(AstryxRadiusToken.element), 0.0);
      // The fixed anchors are untouched.
      expect(data.radius(AstryxRadiusToken.full), 9999.0);
    });

    test('a colour scale reaches the Flutter values', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'brand',
          color: AstryxColorScaleConfig(accent: '#DC2626'),
        ),
      );
      final data = dataFor(AstryxThemeMode.light, theme: theme);
      expect(
        data.color(AstryxColorToken.accent),
        isNot(const Color(0xFF0064E0)),
      );
      // A derived reference token resolves to the same colour as its base.
      expect(
        data.color(AstryxColorToken.textAccent),
        data.color(AstryxColorToken.accent),
      );
    });

    test('an explicit token override wins', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'override',
          tokens: <String, AstryxTokenValue>{
            '--color-accent': AstryxTokenValue.lightDark('#AA0000', '#FF5555'),
            '--spacing-4': AstryxTokenValue('20px'),
          },
        ),
      );
      expect(
        dataFor(
          AstryxThemeMode.light,
          theme: theme,
        ).color(AstryxColorToken.accent),
        const Color(0xFFAA0000),
      );
      expect(
        dataFor(
          AstryxThemeMode.dark,
          theme: theme,
        ).color(AstryxColorToken.accent),
        const Color(0xFFFF5555),
      );
      expect(
        dataFor(
          AstryxThemeMode.light,
          theme: theme,
        ).spacing(AstryxSpacingToken.spacing4),
        20.0,
      );
    });
  });

  group('missing values', () {
    test('a token with no usable value throws a helpful error', () {
      final broken = AstryxResolvedTokenSet(
        light: const <String, String>{'--color-accent': 'not-a-colour'},
        dark: const <String, String>{'--color-accent': 'not-a-colour'},
      );
      final data = AstryxThemeData(
        tokens: broken,
        mode: AstryxThemeMode.light,
        platform: TargetPlatform.macOS,
      );
      expect(
        () => data.color(AstryxColorToken.accent),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('--color-accent'),
          ),
        ),
      );
    });
  });

  group('equality', () {
    test('equal inputs are equal', () {
      expect(dataFor(AstryxThemeMode.light), dataFor(AstryxThemeMode.light));
      expect(
        dataFor(AstryxThemeMode.light).hashCode,
        dataFor(AstryxThemeMode.light).hashCode,
      );
    });

    test('mode and platform are part of identity', () {
      expect(light, isNot(dark));
      expect(
        dataFor(AstryxThemeMode.light, platform: TargetPlatform.windows),
        isNot(light),
      );
    });

    test('copyWith reconverts', () {
      expect(light.copyWith(mode: AstryxThemeMode.dark), dark);
      expect(light.copyWith(), light);
    });
  });

  group('upstream parity', () {
    test('every prebuilt theme converts without a missing value', () {
      // The engine's parity is proven in Phase 2. What this adds is that the
      // conversion layer has a usable Flutter value for every token of every
      // shipped theme, in both modes — the failure this layer can introduce.
      for (final record in asObjects(loadEngineFixture('themes')['themes'])) {
        final theme = defineTheme(
          decodeThemeInput(record['input']! as Map<String, dynamic>),
        );
        for (final mode in AstryxThemeMode.values) {
          final data = dataFor(mode, theme: theme);
          final where = '${record['name']} / ${mode.name}';

          for (final token in AstryxColorToken.values) {
            expect(() => data.color(token), returnsNormally, reason: where);
          }
          for (final token in AstryxSpacingToken.values) {
            expect(() => data.spacing(token), returnsNormally, reason: where);
          }
          for (final token in AstryxRadiusToken.values) {
            expect(() => data.radius(token), returnsNormally, reason: where);
          }
          for (final token in AstryxDurationToken.values) {
            expect(() => data.duration(token), returnsNormally, reason: where);
          }
          for (final token in AstryxShadowToken.values) {
            expect(data.shadow(token), isNotEmpty, reason: '$where $token');
          }
          expect(data.ease, returnsNormally, reason: where);

          for (final role in AstryxTypeRole.values) {
            final style = data.textStyle(role);
            expect(style.fontSize, isNotNull, reason: '$where ${role.name}');
            expect(style.fontWeight, isNotNull, reason: '$where ${role.name}');
            expect(style.height, isNotNull, reason: '$where ${role.name}');
          }
        }
        resetThemes();
      }
    });

    test('the resolved colour matches the token string it came from', () {
      for (final record in asObjects(loadEngineFixture('themes')['themes'])) {
        final theme = defineTheme(
          decodeThemeInput(record['input']! as Map<String, dynamic>),
        );
        final upstream = record['resolvedLight']! as Map<String, dynamic>;
        final data = dataFor(AstryxThemeMode.light, theme: theme);

        for (final token in AstryxColorToken.values) {
          final expected = parseCssColor(
            upstream[token.cssName]! as String,
            AstryxThemeMode.light,
          );
          expect(
            data.color(token),
            expected,
            reason: '${record['name']} ${token.cssName}',
          );
        }
        resetThemes();
      }
    });
  });
}
