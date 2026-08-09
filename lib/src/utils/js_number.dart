/// Numeric helpers that reproduce JavaScript semantics exactly.
///
/// The theme engine is a port of TypeScript whose *output values* are compared
/// against upstream's. Where Dart and JavaScript disagree on arithmetic or on
/// how a number stringifies, the JavaScript behaviour is the specification.
library;

/// Rounds [value] the way JavaScript's `Math.round` does.
///
/// Both languages round halves away from zero for positive numbers, but they
/// differ on negative halves: `Math.round(-0.5)` is `-0`, whereas Dart's
/// `(-0.5).round()` is `-1`. JavaScript rounds halves toward positive infinity.
///
/// No shipped Astryx theme feeds a negative value into a rounding site, but a
/// consumer-defined theme can — a negative `multiplier` in a radius scale is
/// enough — and a silent one-pixel divergence there is exactly the kind of
/// drift the parity tests exist to prevent.
double jsRound(double value) {
  if (!value.isFinite) return value;
  // Not `(value + 0.5).floor()`: for the double just below 0.5 that addition
  // rounds up to exactly 1.0, and the result would be 1 where JavaScript
  // gives 0.
  final whole = value.floorToDouble();
  return value - whole >= 0.5 ? whole + 1 : whole;
}
