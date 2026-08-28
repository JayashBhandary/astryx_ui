/// Keeping the browser's own context menu out from under this package's.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Suppresses the browser's right-click menu while a Flutter one is on the
/// page.
///
/// On the web a secondary click is the browser's before it is the
/// application's. Flutter reports it — `onSecondaryTapDown` fires and
/// `AstryxContextMenu` opens — but the browser also raises its own Back /
/// Reload / Inspect menu on top of it. Two menus for one click, and the one
/// the user wanted is behind the one they did not.
///
/// [BrowserContextMenu] is the only lever Flutter offers, and it is **whole
/// document, not per element**: there is no way to suppress the browser's menu
/// over one region and keep it over the rest. So the narrowest honest scope is
/// "while something on this page has a context menu of its own", which is what
/// this counts. The first widget that claims it disables the browser's menu;
/// the last one to let go puts it back.
///
/// Two things it deliberately does not do:
///
///  * **It never enables a menu it did not disable.** An app that called
///    `BrowserContextMenu.disableContextMenu()` at startup — the manual route,
///    which is still the right one for an app that wants it off everywhere —
///    keeps its own setting when the last widget unmounts.
///  * **It does nothing off the web.** [BrowserContextMenu] asserts `kIsWeb`,
///    and there is no browser menu to fight with anywhere else.
@internal
abstract final class AstryxBrowserContextMenu {
  /// How many mounted widgets currently want the browser's menu suppressed.
  static int _claims = 0;

  /// Whether *this* class is the reason the browser's menu is off.
  ///
  /// The claim count alone is not enough: it says nothing about who turned the
  /// menu off, and re-enabling one the application had disabled itself would
  /// be this package overruling the app.
  static bool _ours = false;

  /// The platform calls, overridable so the counting can be tested off-web.
  ///
  /// The real ones assert `kIsWeb`, so a VM test cannot reach them.
  @visibleForTesting
  static Future<void> Function() disable =
      BrowserContextMenu.disableContextMenu;

  /// The counterpart to [disable].
  @visibleForTesting
  static Future<void> Function() enable = BrowserContextMenu.enableContextMenu;

  /// Whether the browser's menu is currently enabled, as far as Flutter knows.
  @visibleForTesting
  static bool Function() isEnabled = () => BrowserContextMenu.enabled;

  /// Whether there is a browser to fight with at all.
  ///
  /// Overridable for the same reason as the three above: a VM test is never
  /// the web, and the counting is the part worth testing.
  @visibleForTesting
  static bool Function() isWeb = () => kIsWeb;

  /// How many widgets hold a claim. For tests.
  @visibleForTesting
  static int get claims => _claims;

  /// Drops every claim and forgets who disabled what. For tests, which must
  /// not leak state between cases.
  @visibleForTesting
  static void reset() {
    _claims = 0;
    _ours = false;
  }

  /// Puts the platform calls back to the real ones. For tests.
  @visibleForTesting
  static void restorePlatformCalls() {
    disable = BrowserContextMenu.disableContextMenu;
    enable = BrowserContextMenu.enableContextMenu;
    isEnabled = () => BrowserContextMenu.enabled;
    isWeb = () => kIsWeb;
  }

  /// Asks for the browser's menu to stay out of the way.
  ///
  /// Balance every call with [release]. Calls are counted, so several context
  /// menus on one page cost one `disableContextMenu` between them.
  static void claim() {
    if (!isWeb()) return;
    _claims++;
    // Only the first claim acts, and only if the menu is on: an app that
    // turned it off itself has already said what it wants.
    if (_claims != 1 || !isEnabled()) return;
    _ours = true;
    // Fire and forget. The result arrives a frame or two later, and there is
    // nothing useful to do with a failure — the worst case is the state this
    // whole class exists to fix, which is what the app had before. Swallowed
    // rather than left to the zone: a channel error here must not take an
    // application down over a menu.
    unawaited(disable().catchError((Object _) {}));
  }

  /// Gives up a claim taken by [claim].
  static void release() {
    if (!isWeb() || _claims == 0) return;
    _claims--;
    if (_claims != 0 || !_ours) return;
    _ours = false;
    unawaited(enable().catchError((Object _) {}));
  }
}
