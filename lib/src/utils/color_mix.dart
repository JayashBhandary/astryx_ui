/// CSS `color-mix(in srgb, …)` for colours that are already resolved.
library;

import 'dart:ui';

/// Mixes [tint] into [base] by [tintPercent], as `color-mix(in srgb, …)` does.
///
/// The engine has its own `evaluateColorMix`, but that one works on CSS *text*
/// during theme resolution. The hover and active tints upstream applies —
/// `color-mix(in srgb, var(--color-accent), var(--color-tint-hover) 15%)` — are
/// computed per interaction from two colours that are already `Color`s, so
/// round-tripping them through strings would be absurd. Same algorithm, same
/// premultiplied interpolation, different input type.
///
/// [tintPercent] is 0–100. Values outside that range are clamped, as CSS does.
Color astryxMixColors(Color base, Color tint, double tintPercent) {
  final p2 = tintPercent.clamp(0.0, 100.0);
  final p1 = 100 - p2;
  final w1 = p1 / 100;
  final w2 = p2 / 100;

  // Premultiplied sRGB interpolation, then un-premultiply — the CSS Color 5
  // rule, which differs visibly from naive channel lerping when either colour
  // is translucent, and the tint tokens are.
  final a = w1 * base.a + w2 * tint.a;
  double premix(double k1, double k2) => w1 * k1 * base.a + w2 * k2 * tint.a;

  if (a == 0) return const Color(0x00000000);

  return Color.from(
    alpha: a,
    red: premix(base.r, tint.r) / a,
    green: premix(base.g, tint.g) / a,
    blue: premix(base.b, tint.b) / a,
  );
}
