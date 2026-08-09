import 'package:example/gallery/gallery_controller.dart';
import 'package:example/gallery/gallery_scope.dart';
import 'package:example/gallery/gallery_shell.dart';
import 'package:flutter/material.dart';

void main() => runApp(const GalleryApp());

/// Gallery for `astryx_ui`.
///
/// Every component, every theme, at both densities, in both brightnesses, in
/// both text directions. If a widget cannot be exercised from here, it is not
/// finished.
class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  final GalleryController _controller = GalleryController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GalleryScope(
      notifier: _controller,
      // Phase 3 wraps this in AstryxThemeProvider, fed from _controller.
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => MaterialApp(
          title: 'astryx_ui gallery',
          debugShowCheckedModeBanner: false,
          themeMode: switch (_controller.brightness) {
            GalleryBrightness.system => ThemeMode.system,
            GalleryBrightness.light => ThemeMode.light,
            GalleryBrightness.dark => ThemeMode.dark,
          },
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          home: const GalleryShell(),
        ),
      ),
    );
  }
}
