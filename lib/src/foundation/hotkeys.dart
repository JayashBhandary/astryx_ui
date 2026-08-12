/// Keyboard shortcuts: one definition, bound and displayed.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A key with its modifiers — a shortcut, before it is bound to anything.
///
/// Upstream's `useHotkeys` takes strings like `'mod+k'`. This is the same idea
/// with the parsing removed: a typo in a string is a shortcut that silently
/// never fires, and there is no reason to accept one when
/// [LogicalKeyboardKey] exists.
///
/// **`mod` is the point.** A shortcut written with [AstryxHotkey.mod] is
/// Command on a Mac and Control everywhere else — which is what every user of
/// both expects, and what makes one definition correct on both. It also means
/// the hotkey can *say* which modifier it resolved to, so a menu row shows
/// `⌘K` or `Ctrl+K` without the caller branching on the platform.
///
/// {@tool snippet}
/// ```dart
/// const search = AstryxHotkey.mod(LogicalKeyboardKey.keyK);
///
/// AstryxHotkeys(
///   bindings: <AstryxHotkey, VoidCallback>{search: _openPalette},
///   child: const MyPage(),
/// )
/// ```
/// {@end-tool}
@immutable
class AstryxHotkey {
  /// Creates a hotkey with explicit modifiers.
  const AstryxHotkey(
    this.key, {
    this.control = false,
    this.shift = false,
    this.alt = false,
    this.meta = false,
  }) : mod = false;

  /// Creates a hotkey on the platform's own command modifier.
  ///
  /// Command on macOS and iOS, Control elsewhere. Use this for anything that
  /// mirrors a platform convention — save, find, close — and the explicit
  /// constructor only where the modifier is genuinely fixed.
  const AstryxHotkey.mod(this.key, {this.shift = false, this.alt = false})
    : mod = true,
      control = false,
      meta = false;

  /// The key itself.
  final LogicalKeyboardKey key;

  /// Whether Control must be held.
  final bool control;

  /// Whether Shift must be held.
  final bool shift;

  /// Whether Alt — Option on a Mac — must be held.
  final bool alt;

  /// Whether Meta — Command on a Mac, the Windows key elsewhere — must be
  /// held.
  final bool meta;

  /// Whether the modifier is the platform's own command key.
  final bool mod;

  /// Whether this hotkey needs Meta on [platform].
  bool metaFor(TargetPlatform platform) => meta || (mod && _isApple(platform));

  /// Whether this hotkey needs Control on [platform].
  bool controlFor(TargetPlatform platform) =>
      control || (mod && !_isApple(platform));

  /// The activator to bind, resolved for [platform].
  ShortcutActivator activatorFor(TargetPlatform platform) => SingleActivator(
    key,
    control: controlFor(platform),
    shift: shift,
    alt: alt,
    meta: metaFor(platform),
  );

  /// The key caps to draw, resolved for [platform].
  ///
  /// `⌘` and `⌥` on Apple platforms, the words elsewhere — the symbols are the
  /// convention on one platform and meaningless on the others.
  List<String> capsFor(TargetPlatform platform) {
    final apple = _isApple(platform);
    return <String>[
      if (controlFor(platform)) apple ? '⌃' : 'Ctrl',
      if (alt) apple ? '⌥' : 'Alt',
      if (shift) apple ? '⇧' : 'Shift',
      if (metaFor(platform)) apple ? '⌘' : 'Win',
      _keyLabel,
    ];
  }

  /// The shortcut as a sentence, for a screen reader.
  ///
  /// A row of symbols read aloud is not a shortcut anybody can follow, so the
  /// modifiers are named in full however they are drawn.
  String describeFor(TargetPlatform platform) => <String>[
    if (controlFor(platform)) 'Control',
    if (alt) _isApple(platform) ? 'Option' : 'Alt',
    if (shift) 'Shift',
    if (metaFor(platform)) _isApple(platform) ? 'Command' : 'Windows',
    _keyLabel,
  ].join(' ');

  /// The key's own cap — `K`, `Enter`, `/`.
  String get _keyLabel {
    final label = key.keyLabel;
    if (label.isEmpty) return key.debugName ?? '?';
    return label.length == 1 ? label.toUpperCase() : label;
  }

  static bool _isApple(TargetPlatform platform) =>
      platform == TargetPlatform.macOS || platform == TargetPlatform.iOS;

  @override
  bool operator ==(Object other) =>
      other is AstryxHotkey &&
      other.key == key &&
      other.control == control &&
      other.shift == shift &&
      other.alt == alt &&
      other.meta == meta &&
      other.mod == mod;

  @override
  int get hashCode => Object.hash(key, control, shift, alt, meta, mod);

  @override
  String toString() =>
      'AstryxHotkey(${capsFor(TargetPlatform.macOS).join()})';
}

/// Binds hotkeys to callbacks for its subtree.
///
/// The Flutter counterpart of upstream's `useHotkeys`, built on
/// [CallbackShortcuts] — so the bindings sit in the widget tree where a reader
/// can see their scope, rather than in a hook whose lifetime is invisible.
///
/// **Keys arrive only while focus is inside the subtree.** That is Flutter's
/// key-event model, not a limitation of this widget: an event walks *up* from
/// the focused node. For an application-wide shortcut, wrap the application —
/// and note that a shortcut with no modifier will then steal the key from every
/// text field in it, which is why almost every hotkey worth binding has a
/// modifier.
///
/// {@tool snippet}
/// ```dart
/// AstryxHotkeys(
///   bindings: <AstryxHotkey, VoidCallback>{
///     const AstryxHotkey.mod(LogicalKeyboardKey.keyK): _openPalette,
///     const AstryxHotkey(LogicalKeyboardKey.slash): _focusSearch,
///   },
///   child: const MyPage(),
/// )
/// ```
/// {@end-tool}
class AstryxHotkeys extends StatelessWidget {
  /// Creates a hotkey scope.
  const AstryxHotkeys({
    required this.bindings,
    required this.child,
    super.key,
    this.enabled = true,
    this.autofocus = false,
    this.platform,
  });

  /// What each hotkey does.
  final Map<AstryxHotkey, VoidCallback> bindings;

  /// The subtree the bindings apply to.
  final Widget child;

  /// Whether the bindings are live.
  ///
  /// False leaves the subtree alone entirely, which is how a screen suspends
  /// its shortcuts while a modal is open without rebuilding its own tree.
  final bool enabled;

  /// Whether the scope takes focus when it is first built.
  ///
  /// **Set this on an application-wide scope.** A key event is dispatched from
  /// whatever holds focus and walks *upwards*, so until something inside the
  /// subtree is focused there is nothing for it to walk through: a `⌘K` on a
  /// freshly loaded page would do nothing at all, and be reported as broken.
  /// The node is still skipped by Tab, so this buys the shortcut without adding
  /// a tab stop.
  ///
  /// Leave it false for a scope inside a page that already focuses something,
  /// and for one wrapping a control — stealing focus from a field to bind a
  /// shortcut is worse than the shortcut is worth.
  final bool autofocus;

  /// Overrides the platform `mod` resolves against.
  ///
  /// Null takes the theme's platform, then the default target platform. Mainly
  /// for tests, and for a preview of another platform's shortcuts.
  final TargetPlatform? platform;

  @override
  Widget build(BuildContext context) {
    if (!enabled || bindings.isEmpty) return child;

    final target =
        platform ??
        AstryxTheme.maybeOf(context)?.platform ??
        defaultTargetPlatform;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        for (final entry in bindings.entries)
          entry.key.activatorFor(target): entry.value,
      },
      // A node skipped by traversal, which is what Flutter's own `Shortcuts`
      // builds: it puts this widget in the focus chain above whatever *is*
      // focused, so the key event walks through it — without adding a tab stop
      // to bind a keystroke. With `autofocus` it can also *hold* focus, which
      // is the only way an app-wide shortcut works before the user has clicked
      // anything.
      child: Focus(
        canRequestFocus: autofocus,
        autofocus: autofocus,
        skipTraversal: true,
        child: child,
      ),
    );
  }
}
