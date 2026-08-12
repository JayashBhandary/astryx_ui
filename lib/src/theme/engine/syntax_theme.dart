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
import 'package:astryx_ui/src/theme/tokens/token.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// The CSS custom property prefix for syntax tokens.
const String astryxSyntaxTokenPrefix = '--color-syntax-';

/// The fourteen syntax token keys upstream defines.
///
/// The same fourteen as [AstryxSyntaxToken], as bare strings — which is the
/// shape [AstryxSyntaxTheme.tokens] is keyed by. A test pins the two together.
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

/// One role in a syntax palette, as a token.
///
/// The typed counterpart of [astryxSyntaxTokenKeys]: a theme's palette is
/// written into the token map under [astryxSyntaxTokenPrefix], and these are
/// the names it lands under — so `AstryxThemeData.syntaxColor` can hand back a
/// `Color` rather than leaving a caller to build the string themselves.
///
/// **Nothing in this package paints with these.** `AstryxCodeBlock` does not
/// highlight, by decision rather than omission: shipping a tokeniser for every
/// language a caller might paste is not a design system's job. The palette is
/// here so that a caller who *does* wire a highlighter colours it from the
/// theme instead of hard-coding fourteen colours beside it.
enum AstryxSyntaxToken implements AstryxToken {
  /// `if`, `return`, `class`.
  keyword('keyword'),

  /// A string literal.
  string('string'),

  /// A comment.
  comment('comment'),

  /// A numeric literal.
  number('number'),

  /// A function or method name.
  function('function'),

  /// A type name.
  type('type'),

  /// A variable or parameter name.
  variable('variable'),

  /// An operator — `+`, `=>`, `??`.
  operator('operator'),

  /// A constant, including a language literal such as `null`.
  constant('constant'),

  /// A markup tag name.
  tag('tag'),

  /// A markup attribute name.
  attribute('attribute'),

  /// An object property or field name.
  property('property'),

  /// Brackets, commas, semicolons.
  punctuation('punctuation'),

  /// The fill behind highlighted code.
  background('background');

  const AstryxSyntaxToken(this.key);

  /// The short name this role is keyed by in [AstryxSyntaxTheme.tokens].
  final String key;

  @override
  String get cssName => '$astryxSyntaxTokenPrefix$key';
}

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
