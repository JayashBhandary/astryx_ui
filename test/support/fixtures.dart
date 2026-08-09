import 'dart:convert';
import 'dart:io';

import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads a parity fixture produced by `dev/tools/dump-engine-fixtures.mjs`.
///
/// The fixtures are the output of the *real* upstream TypeScript engine, run
/// under Node. Asserting against them is what makes "faithful port" checkable
/// rather than aspirational.
///
/// `flutter test` runs with the package root as its working directory, so the
/// path is relative to `astryx_ui/`.
Map<String, dynamic> loadEngineFixture(String name) {
  final file = File('../dev/fixtures/engine/$name.json');
  if (!file.existsSync()) {
    throw StateError(
      'Fixture ../dev/fixtures/engine/$name.json is missing. Regenerate with:\n'
      '  node dev/tools/mirror-upstream.mjs\n'
      '  node dev/tools/dump-engine-fixtures.mjs $name',
    );
  }
  return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
}

/// Reads a JSON number as a [double].
///
/// JSON has one number type; `JSON.stringify` writes `1`, not `1.0`, so Dart
/// decodes some values as [int].
double asDouble(Object? value) => (value! as num).toDouble();

/// Reads a list of JSON objects.
List<Map<String, dynamic>> asObjects(Object? value) =>
    (value! as List<dynamic>).cast<Map<String, dynamic>>();

/// Core tokens upstream's own resolver cannot return, and which are therefore
/// exempt from the value comparison.
///
/// `--border-width` is declared in `tokens.stylex.ts` and published as a CSS
/// custom property through `borderVars`, but `borderDefaults` is spread into
/// neither `CoreTokenName` nor the `tokenDefaults` map that
/// `resolveThemeTokens` seeds from. In a browser this is invisible: the
/// variable exists in the cascade and components read it. `astryx_ui` has no
/// cascade — the resolver *is* the whole story — so dropping the token would
/// leave border widths unthemeable. It is kept, and excluded here. See ADR-012.
const Set<String> astryxUpstreamUnresolvedTokens = <String>{'--border-width'};

/// Asserts that [actual] matches [expected] on every core Astryx token.
///
/// Upstream's resolved map also carries the domain tokens — syntax highlighting
/// and data visualisation — which are out of scope for 1.0 and are not in the
/// Dart token layer at all. A theme may also set tokens outside the core set,
/// and those land in both resolved maps. So the key assertion is one-sided:
/// every one of the 184 core tokens must be present. Without it, a resolver
/// that returned nothing at all would pass by vacuous agreement.
void expectCoreTokensMatch(
  Map<String, String> actual,
  Map<String, dynamic> expected, {
  required String reason,
}) {
  expect(
    actual.keys.toSet(),
    containsAll(astryxTokenDefaults.keys),
    reason: '$reason: resolved key set is missing core tokens',
  );

  final mismatches = <String>[];
  for (final name in astryxTokenDefaults.keys) {
    if (astryxUpstreamUnresolvedTokens.contains(name)) continue;
    final want = expected[name];
    if (want == null) {
      mismatches.add('$name: absent from the upstream fixture');
    } else if (actual[name] != want) {
      mismatches.add('$name: expected "$want", got "${actual[name]}"');
    }
  }

  expect(
    mismatches,
    isEmpty,
    reason: '$reason: ${mismatches.length} token(s) differ',
  );

  // Guard the exemption itself: if upstream ever starts resolving one of
  // these, the exemption is stale and should be deleted, not left to hide a
  // future mismatch.
  for (final name in astryxUpstreamUnresolvedTokens) {
    expect(
      expected,
      isNot(contains(name)),
      reason:
          '$reason: upstream now resolves $name — drop it from '
          'astryxUpstreamUnresolvedTokens and compare it like the rest',
    );
  }
}
