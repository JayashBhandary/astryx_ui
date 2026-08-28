import 'package:astryx_ui/astryx_ui.dart';
// Internal, and the point of the test: the counting is what decides whether
// the browser's menu comes back.
import 'package:astryx_ui/src/foundation/browser_context_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The browser-menu guard behind `AstryxContextMenu` on the web.
///
/// The real `BrowserContextMenu` asserts `kIsWeb`, so these tests swap the
/// three platform calls for counters. What is being checked is the bookkeeping
/// — who disabled the menu, and whether it comes back — which is where the
/// bugs are; that `disableContextMenu` works is Flutter's business.
void main() {
  late int disabled;
  late int enabled;
  late bool browserMenuOn;

  setUp(() {
    disabled = 0;
    enabled = 0;
    browserMenuOn = true;

    AstryxBrowserContextMenu.reset();
    AstryxBrowserContextMenu.isWeb = () => true;
    AstryxBrowserContextMenu.isEnabled = () => browserMenuOn;
    AstryxBrowserContextMenu.disable = () async {
      disabled++;
      browserMenuOn = false;
    };
    AstryxBrowserContextMenu.enable = () async {
      enabled++;
      browserMenuOn = true;
    };
  });

  tearDown(() {
    AstryxBrowserContextMenu.reset();
    AstryxBrowserContextMenu.restorePlatformCalls();
  });

  group('the guard', () {
    test('the first claim disables, and later ones do not', () {
      AstryxBrowserContextMenu.claim();
      AstryxBrowserContextMenu.claim();
      AstryxBrowserContextMenu.claim();

      expect(AstryxBrowserContextMenu.claims, 3);
      expect(disabled, 1, reason: 'three menus cost one channel call');
    });

    test('the browser menu comes back only when the last claim goes', () {
      AstryxBrowserContextMenu.claim();
      AstryxBrowserContextMenu.claim();
      AstryxBrowserContextMenu.release();

      expect(enabled, 0, reason: 'one menu is still on the page');

      AstryxBrowserContextMenu.release();
      expect(enabled, 1);
      expect(browserMenuOn, isTrue);
    });

    test('a menu the app disabled itself is never re-enabled', () {
      // What an app that called `disableContextMenu()` at startup looks like.
      browserMenuOn = false;

      AstryxBrowserContextMenu.claim();
      AstryxBrowserContextMenu.release();

      expect(disabled, 0, reason: 'nothing to do — it was already off');
      expect(
        enabled,
        0,
        reason: 'this package must not overrule the application’s own setting',
      );
      expect(browserMenuOn, isFalse);
    });

    test('an unbalanced release does nothing', () {
      AstryxBrowserContextMenu.release();

      expect(AstryxBrowserContextMenu.claims, 0);
      expect(enabled, 0);
    });

    test('claims and releases can interleave across widgets', () {
      AstryxBrowserContextMenu.claim();
      expect(disabled, 1);

      AstryxBrowserContextMenu.release();
      AstryxBrowserContextMenu.claim();

      expect(enabled, 1);
      expect(
        disabled,
        2,
        reason: 'the menu was on again, so it goes off again',
      );
      expect(AstryxBrowserContextMenu.claims, 1);
    });
  });

  group('AstryxContextMenu', () {
    const entries = <AstryxMenuEntry>[AstryxMenuItem(label: 'Rename')];

    testWidgets('mounting and unmounting one is balanced', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxContextMenu(
          entries: entries,
          child: SizedBox(width: 100, height: 100),
        ),
      );

      // `isWeb` is stubbed true above, so the widget really does claim here.
      expect(AstryxBrowserContextMenu.claims, 1);
      expect(disabled, 1);

      await pumpAstryxWidget(tester, const SizedBox.shrink());
      await tester.pumpAndSettle();

      expect(AstryxBrowserContextMenu.claims, 0);
      expect(enabled, 1, reason: 'the last menu off the page gives it back');
      expect(tester.takeException(), isNull);
    });

    testWidgets('a right-click still opens the menu', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxContextMenu(
          entries: entries,
          child: SizedBox(width: 100, height: 100),
        ),
        surfaceSize: const Size(400, 400),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(SizedBox).first),
        buttons: kSecondaryButton,
      );
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('Rename'), findsOneWidget);
    });
  });
}
