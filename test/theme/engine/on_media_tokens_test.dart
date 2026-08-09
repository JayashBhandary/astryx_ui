import 'package:astryx_ui/src/theme/engine/on_media_tokens.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';
import '../../support/theme_input.dart';

/// Parity tests for the on-media token resolution.
void main() {
  group('resolveOnMedia', () {
    test('returns the defaults when there is no input', () {
      expect(
        resolveOnMedia(AstryxSurface.dark).tokens,
        astryxDefaultOnDarkTokens,
      );
      expect(
        resolveOnMedia(AstryxSurface.light).tokens,
        astryxDefaultOnLightTokens,
      );
    });

    test('sets the colour scheme to match the surface', () {
      expect(
        resolveOnMedia(AstryxSurface.dark).tokens[astryxColorSchemeKey],
        'dark',
      );
      expect(
        resolveOnMedia(AstryxSurface.light).tokens[astryxColorSchemeKey],
        'light',
      );
    });

    test('points primary text and the accent at the on-colour', () {
      final dark = resolveOnMedia(AstryxSurface.dark).tokens;
      expect(dark['--color-text-primary'], 'var(--color-on-dark)');
      expect(dark['--color-icon-primary'], 'var(--color-on-dark)');
      expect(dark['--color-accent'], 'var(--color-on-dark)');

      final light = resolveOnMedia(AstryxSurface.light).tokens;
      expect(light['--color-text-primary'], 'var(--color-on-light)');
      expect(light['--color-icon-primary'], 'var(--color-on-light)');
      expect(light['--color-accent'], 'var(--color-on-light)');
    });

    test('applies theme-supplied tokens over the defaults', () {
      final resolved = resolveOnMedia(
        AstryxSurface.dark,
        const AstryxOnMediaOverrides(
          tokens: <String, AstryxTokenValue>{
            '--color-accent': AstryxTokenValue('#90CAF9'),
          },
        ),
      );
      expect(resolved.tokens['--color-accent'], '#90CAF9');
      // The untouched defaults survive.
      expect(resolved.tokens['--color-text-primary'], 'var(--color-on-dark)');
    });

    test('flattens a light/dark pair to light-dark()', () {
      final resolved = resolveOnMedia(
        AstryxSurface.light,
        const AstryxOnMediaOverrides(
          tokens: <String, AstryxTokenValue>{
            '--color-border': AstryxTokenValue.lightDark('#111111', '#EEEEEE'),
          },
        ),
      );
      expect(resolved.tokens['--color-border'], 'light-dark(#111111, #EEEEEE)');
    });

    test('passes component overrides through untouched', () {
      const components = <String, Map<String, AstryxStyleOverrides>>{
        'button': <String, AstryxStyleOverrides>{
          'variant:ghost': AstryxStyleOverrides(
            properties: <String, String>{'borderWidth': '1px'},
          ),
        },
      };
      final resolved = resolveOnMedia(
        AstryxSurface.dark,
        const AstryxOnMediaOverrides(components: components),
      );
      expect(resolved.components, components);
    });

    test('does not mutate the shared default maps', () {
      resolveOnMedia(
        AstryxSurface.dark,
        const AstryxOnMediaOverrides(
          tokens: <String, AstryxTokenValue>{
            '--color-accent': AstryxTokenValue('#000000'),
          },
        ),
      );
      expect(
        astryxDefaultOnDarkTokens['--color-accent'],
        'var(--color-on-dark)',
      );
    });
  });

  group('upstream parity', () {
    late Map<String, dynamic> fixture;

    setUpAll(() => fixture = loadEngineFixture('on_media_tokens'));

    test('the default token sets match upstream', () {
      final defaults = fixture['defaults']! as Map<String, dynamic>;
      expect(astryxDefaultOnDarkTokens, defaults['dark']);
      expect(astryxDefaultOnLightTokens, defaults['light']);
    });

    test('matches upstream for every recorded input', () {
      final cases = asObjects(fixture['cases']);
      expect(cases, isNotEmpty);

      for (final c in cases) {
        final surface = c['surface'] == 'dark'
            ? AstryxSurface.dark
            : AstryxSurface.light;
        final resolved = resolveOnMedia(
          surface,
          decodeOnMedia(c['input'] as Map<String, dynamic>?),
        );
        final expected = c['resolved']! as Map<String, dynamic>;

        expect(resolved.tokens, expected['tokens'], reason: '$c');
        expect(
          resolved.components,
          decodeComponents(expected['components'] as Map<String, dynamic>?),
          reason: '$c',
        );
      }
    });
  });
}
