/// The interface every Astryx design token enum implements.
///
/// Hand-written, unlike the twelve enums themselves — see ADR-009. It exists so
/// that code above Layer 0 can accept *any* token without a twelve-way overload
/// or a `dynamic` parameter.
library;

/// A design token, identified by its upstream CSS custom property name.
///
/// The twelve token enums — `AstryxColorToken`, `AstryxSpacingToken` and the
/// rest — all implement this. [cssName] is the join key against the token
/// defaults, a resolved token set, and the upstream parity fixtures.
///
/// They are generated and this is not, so naming them with doc links here
/// would point Layer 0's only hand-written file at its generated siblings.
///
/// {@tool snippet}
/// ```dart
/// void logToken(AstryxToken token) {
///   debugPrint(token.cssName); // '--color-accent'
/// }
/// ```
/// {@end-tool}
abstract interface class AstryxToken {
  /// The upstream CSS custom property name, such as `--color-accent`.
  String get cssName;
}
