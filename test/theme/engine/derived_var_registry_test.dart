import 'package:astryx_ui/src/theme/engine/derived_var_registry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

/// Parity tests for the derived-variable registry.
void main() {
  group('getDerivedVars', () {
    test('returns the matching entry for card borderRadius', () {
      expect(getDerivedVars('card', 'borderRadius'), <AstryxDerivedVar>[
        const AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_card-radius'],
        ),
      ]);
    });

    test('returns an expansion strategy where one is used', () {
      expect(getDerivedVars('card', 'padding'), <AstryxDerivedVar>[
        const AstryxDerivedVar(
          property: 'padding',
          expand: AstryxDerivedExpansion.container,
        ),
      ]);
    });

    test('returns empty for an unknown component', () {
      expect(getDerivedVars('nope', 'borderRadius'), isEmpty);
    });

    test('returns empty for an unregistered property', () {
      expect(getDerivedVars('card', 'margin'), isEmpty);
    });
  });

  group('upstream parity', () {
    late Map<String, dynamic> fixture;

    setUpAll(() => fixture = loadEngineFixture('derived_var_registry'));

    AstryxDerivedVar decode(Map<String, dynamic> json) => AstryxDerivedVar(
      property: json['property']! as String,
      vars:
          (json['vars'] as List<dynamic>?)?.cast<String>() ?? const <String>[],
      expand: json['expand'] == null
          ? null
          : AstryxDerivedExpansion.values.byName(json['expand']! as String),
    );

    test('the registry matches upstream entry for entry', () {
      final upstream = fixture['registry']! as Map<String, dynamic>;
      expect(astryxDerivedVarRegistry.keys.toSet(), upstream.keys.toSet());

      for (final entry in upstream.entries) {
        expect(
          astryxDerivedVarRegistry[entry.key],
          (entry.value as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(decode)
              .toList(),
          reason: entry.key,
        );
      }
    });

    test('getDerivedVars matches upstream for every recorded lookup', () {
      final lookups = asObjects(fixture['lookups']);
      expect(lookups, isNotEmpty);

      for (final lookup in lookups) {
        final component = lookup['component']! as String;
        final property = lookup['property']! as String;
        expect(
          getDerivedVars(component, property),
          (lookup['entries']! as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(decode)
              .toList(),
          reason: '$component / $property',
        );
      }
    });
  });
}
