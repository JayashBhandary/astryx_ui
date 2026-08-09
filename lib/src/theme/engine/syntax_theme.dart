/// A syntax highlighting palette a theme can carry.
///
/// A minimal port of upstream's
/// `packages/core/src/theme/syntax/defineSyntaxTheme.ts`, covering only what
/// `defineTheme` consumes: a name and a map of already-resolved token values,
/// which `defineTheme` writes into the token map under the
/// [astryxSyntaxTokenPrefix].
///
/// The rest of upstream's syntax layer — the fourteen-key validation, the
/// bundled presets, the `SyntaxTheme` component — is deferred along with the
/// domain tokens, which no Tier-1 component uses. It is modelled here anyway
/// so that a theme port does not silently drop its palette.
library;

import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// The CSS custom property prefix for syntax tokens.
const String astryxSyntaxTokenPrefix = '--color-syntax-';

/// The fourteen syntax token keys upstream defines.
const List<String> astryxSyntaxTokenKeys = <String>[
  'keyword',
  'string',
  'comment',
  'number',
  'function',
  'type',
  'variable',
  'operator',
  'constant',
  'tag',
  'attribute',
  'property',
  'punctuation',
  'background',
];

/// A named syntax highlighting palette.
@immutable
class AstryxSyntaxTheme {
  /// Creates a syntax theme from already-resolved CSS values.
  const AstryxSyntaxTheme({required this.name, required this.tokens});

  /// Creates a syntax theme from token values, flattening light/dark pairs to
  /// `light-dark()` strings.
  ///
  /// This is upstream's `defineSyntaxTheme`, without its dev-time warning about
  /// missing keys.
  factory AstryxSyntaxTheme.define({
    required String name,
    required Map<String, AstryxTokenValue> tokens,
  }) => AstryxSyntaxTheme(
    name: name,
    tokens: tokens.map((key, value) => MapEntry(key, value.css)),
  );

  /// The palette name.
  final String name;

  /// Resolved token values, keyed by short name — `keyword`, `string` — with
  /// no `--color-syntax-` prefix.
  final Map<String, String> tokens;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxSyntaxTheme &&
          other.name == name &&
          const DeepCollectionEquality().equals(other.tokens, tokens);

  @override
  int get hashCode =>
      Object.hash(name, const DeepCollectionEquality().hash(tokens));

  @override
  String toString() => 'AstryxSyntaxTheme($name)';
}
