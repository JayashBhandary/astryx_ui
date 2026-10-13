import 'package:astryx_ui/astryx_ui.dart';
// Internal: the surfaces whose paint these tests are about.
import 'package:astryx_ui/src/components/overlay/bottom_sheet.dart'
    show AstryxBottomSheetPanel;
import 'package:astryx_ui/src/components/overlay/overlay_surface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// `AstryxDialogTheme` and `AstryxBottomSheetTheme`: the value types, and
/// that they reach the painted dialog and sheet surfaces.
void main() {
  const red = Color(0xFFFF0000);
  const green = Color(0xFF00FF00);
  const blue = Color(0xFF0000FF);
  const shadow = AstryxShadow(color: red, blurRadius: 4);

  group('AstryxDialogTheme', () {
    test('merge lets the other side win, field by field', () {
      const base = AstryxDialogTheme(
        backgroundColor: red,
        maxWidth: 300,
        titleTextStyle: TextStyle(fontSize: 20),
      );
      final merged = base.merge(
        const AstryxDialogTheme(
          backgroundColor: green,
          titleGap: 6,
          titleTextStyle: TextStyle(color: blue),
        ),
      );
      expect(merged.backgroundColor, green);
      expect(merged.maxWidth, 300);
      expect(merged.titleGap, 6);
      // Text styles merge rather than replace.
      expect(merged.titleTextStyle, const TextStyle(fontSize: 20, color: blue));
      expect(base.merge(null), same(base));
    });

    test('copyWith replaces only the given fields', () {
      const base = AstryxDialogTheme(scrimColor: red, actionsGap: 4);
      final copy = base.copyWith(actionsGap: 12);
      expect(copy.scrimColor, red);
      expect(copy.actionsGap, 12);
    });

    test('lerp interpolates and is null only when both sides are', () {
      expect(AstryxDialogTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxDialogTheme.lerp(
        const AstryxDialogTheme(maxWidth: 200, backgroundColor: red),
        const AstryxDialogTheme(maxWidth: 400, backgroundColor: blue),
        0.5,
      )!;
      expect(mid.maxWidth, 300);
      expect(mid.backgroundColor, Color.lerp(red, blue, 0.5));
    });

    test('== and hashCode are by value, lists deeply', () {
      // Built at runtime, so the two lists are distinct instances.
      AstryxDialogTheme make() => AstryxDialogTheme(
        shadows: List<AstryxShadow>.filled(1, shadow),
        borderRadius: BorderRadius.circular(3),
      );
      expect(make(), make());
      expect(make().hashCode, make().hashCode);
      expect(make(), isNot(const AstryxDialogTheme()));
    });
  });

  group('AstryxBottomSheetTheme', () {
    test('merge lets the other side win, field by field', () {
      const base = AstryxBottomSheetTheme(handleColor: red, maxWidth: 500);
      final merged = base.merge(
        const AstryxBottomSheetTheme(handleColor: green, handleWidth: 10),
      );
      expect(merged.handleColor, green);
      expect(merged.maxWidth, 500);
      expect(merged.handleWidth, 10);
      expect(base.merge(null), same(base));
    });

    test('copyWith replaces only the given fields', () {
      const base = AstryxBottomSheetTheme(scrimColor: red, handleHeight: 2);
      final copy = base.copyWith(handleHeight: 6);
      expect(copy.scrimColor, red);
      expect(copy.handleHeight, 6);
    });

    test('lerp interpolates and is null only when both sides are', () {
      expect(AstryxBottomSheetTheme.lerp(null, null, 0.5), isNull);
      final mid = AstryxBottomSheetTheme.lerp(
        const AstryxBottomSheetTheme(handleWidth: 10),
        const AstryxBottomSheetTheme(handleWidth: 30),
        0.5,
      )!;
      expect(mid.handleWidth, 20);
    });

    test('== and hashCode are by value, lists deeply', () {
      AstryxBottomSheetTheme make() =>
          AstryxBottomSheetTheme(shadows: List.filled(1, shadow));
      expect(make(), make());
      expect(make().hashCode, make().hashCode);
      expect(make(), isNot(const AstryxBottomSheetTheme()));
    });
  });

  /// The decoration the dialog panel paints.
  BoxDecoration dialogDecoration(WidgetTester tester) =>
      tester
              .widget<DecoratedBox>(
                find
                    .descendant(
                      of: find.byType(AstryxOverlaySurface),
                      matching: find.byType(DecoratedBox),
                    )
                    .first,
              )
              .decoration
          as BoxDecoration;

  /// The decoration the sheet panel paints.
  BoxDecoration sheetDecoration(WidgetTester tester) =>
      tester
              .widget<Container>(
                find
                    .descendant(
                      of: find.byType(AstryxBottomSheetPanel),
                      matching: find.byType(Container),
                    )
                    .first,
              )
              .decoration!
          as BoxDecoration;

  /// Whether any scrim-sized box on screen is painted [color].
  bool paintsScrim(WidgetTester tester, Color color) => tester
      .widgetList<ColoredBox>(find.byType(ColoredBox))
      .any((box) => box.color == color);

  Future<void> openDialog(
    WidgetTester tester, {
    AstryxComponentThemes componentThemes = const AstryxComponentThemes(),
    AstryxDialogTheme? theme,
    bool alert = false,
  }) async {
    final controller = AstryxDialogController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      AstryxApp(
        componentThemes: componentThemes,
        home: alert
            ? AstryxAlertDialog(
                controller: controller,
                title: 'Delete',
                description: 'Gone for good.',
                confirmLabel: 'Delete',
                theme: theme,
              )
            : AstryxDialog(
                controller: controller,
                title: 'Edit',
                theme: theme,
                child: const AstryxText('body'),
              ),
      ),
    );
    controller.show();
    await tester.pumpAndSettle();
  }

  Future<void> openSheet(
    WidgetTester tester, {
    AstryxComponentThemes componentThemes = const AstryxComponentThemes(),
    AstryxBottomSheetTheme? theme,
  }) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      AstryxApp(
        componentThemes: componentThemes,
        home: AstryxBottomSheet(
          controller: controller,
          label: 'Filters',
          theme: theme,
          child: const AstryxText('body'),
        ),
      ),
    );
    controller.show();
    await tester.pumpAndSettle();
  }

  group('dialog painting', () {
    testWidgets('defaults come from the tokens', (tester) async {
      await openDialog(tester);
      final context = tester.element(find.byType(AstryxOverlaySurface));
      final data = AstryxTheme.of(context);
      final decoration = dialogDecoration(tester);
      expect(
        decoration.color,
        data.color(AstryxColorToken.backgroundSurface),
      );
      expect(
        decoration.borderRadius,
        data.borderRadius(AstryxRadiusToken.container),
      );
      expect(decoration.boxShadow, data.boxShadows(AstryxShadowToken.high));
      expect(paintsScrim(tester, data.color(AstryxColorToken.overlay)), true);
      expect(tester.getSize(find.byType(AstryxOverlaySurface)).width, 480);
    });

    testWidgets('the app-wide theme reaches the painted panel', (
      tester,
    ) async {
      await openDialog(
        tester,
        componentThemes: const AstryxComponentThemes(
          dialog: AstryxDialogTheme(
            backgroundColor: red,
            scrimColor: green,
            borderRadius: BorderRadius.zero,
            border: BorderSide(color: blue, width: 3),
            shadows: <AstryxShadow>[shadow],
            maxWidth: 300,
          ),
        ),
      );
      final decoration = dialogDecoration(tester);
      expect(decoration.color, red);
      expect(decoration.borderRadius, BorderRadius.zero);
      expect(
        decoration.border,
        const Border.fromBorderSide(BorderSide(color: blue, width: 3)),
      );
      expect(decoration.boxShadow, <BoxShadow>[shadow.toBoxShadow()]);
      expect(paintsScrim(tester, green), true);
      expect(tester.getSize(find.byType(AstryxOverlaySurface)).width, 300);
    });

    testWidgets('a widget-level theme wins over the app-wide one', (
      tester,
    ) async {
      await openDialog(
        tester,
        componentThemes: const AstryxComponentThemes(
          dialog: AstryxDialogTheme(backgroundColor: red, maxWidth: 300),
        ),
        theme: const AstryxDialogTheme(backgroundColor: blue),
      );
      expect(dialogDecoration(tester).color, blue);
      // Unset on the widget, so the app-wide value still applies.
      expect(tester.getSize(find.byType(AstryxOverlaySurface)).width, 300);
    });

    testWidgets('an alert dialog takes the dialog theme', (tester) async {
      await openDialog(
        tester,
        alert: true,
        componentThemes: const AstryxComponentThemes(
          dialog: AstryxDialogTheme(
            backgroundColor: red,
            descriptionTextStyle: TextStyle(color: green),
          ),
        ),
      );
      expect(dialogDecoration(tester).color, red);
      final description = tester.widget<RichText>(
        find
            .descendant(
              of: find.byType(AstryxText),
              matching: find.byType(RichText),
            )
            .first,
      );
      expect(description.text.style?.color, green);
      // The alert dialog's own default width survives an unset maxWidth.
      expect(tester.getSize(find.byType(AstryxOverlaySurface)).width, 420);
    });
  });

  group('bottom sheet painting', () {
    testWidgets('defaults come from the tokens', (tester) async {
      await openSheet(tester);
      final context = tester.element(find.byType(AstryxBottomSheetPanel));
      final data = AstryxTheme.of(context);
      final decoration = sheetDecoration(tester);
      expect(
        decoration.color,
        data.color(AstryxColorToken.backgroundSurface),
      );
      expect(decoration.boxShadow, data.boxShadows(AstryxShadowToken.high));
      expect(paintsScrim(tester, data.color(AstryxColorToken.overlay)), true);
    });

    testWidgets('the app-wide theme reaches the painted sheet', (
      tester,
    ) async {
      await openSheet(
        tester,
        componentThemes: const AstryxComponentThemes(
          bottomSheet: AstryxBottomSheetTheme(
            backgroundColor: red,
            scrimColor: green,
            borderRadius: BorderRadius.zero,
            shadows: <AstryxShadow>[],
            maxWidth: 300,
            handleColor: blue,
            handleWidth: 50,
          ),
        ),
      );
      final decoration = sheetDecoration(tester);
      expect(decoration.color, red);
      // Square: no radius, rather than a zero one Flutter would assert on.
      expect(decoration.borderRadius, isNull);
      expect(decoration.boxShadow, isEmpty);
      expect(paintsScrim(tester, green), true);
      expect(tester.getSize(find.byType(AstryxBottomSheetPanel)).width, 300);

      final handle = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(AstryxBottomSheetPanel),
              matching: find.byType(Container),
            ),
          )
          .where(
            (box) =>
                box.decoration is BoxDecoration &&
                (box.decoration! as BoxDecoration).color == blue,
          );
      expect(handle, hasLength(1));
      expect(handle.single.constraints?.maxWidth, 50);
    });

    testWidgets('a widget-level theme wins over the app-wide one', (
      tester,
    ) async {
      await openSheet(
        tester,
        componentThemes: const AstryxComponentThemes(
          bottomSheet: AstryxBottomSheetTheme(backgroundColor: red),
        ),
        theme: const AstryxBottomSheetTheme(backgroundColor: blue),
      );
      expect(sheetDecoration(tester).color, blue);
    });

    testWidgets('a subtree AstryxComponentTheme reaches the sheet', (
      tester,
    ) async {
      final controller = AstryxBottomSheetController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        AstryxApp(
          home: Builder(
            builder: (context) => AstryxComponentTheme(
              data: const AstryxComponentThemes(
                bottomSheet: AstryxBottomSheetTheme(backgroundColor: green),
              ),
              child: AstryxBottomSheet(
                controller: controller,
                label: 'Filters',
                child: const AstryxText('body'),
              ),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pumpAndSettle();
      expect(sheetDecoration(tester).color, green);
    });
  });
}
