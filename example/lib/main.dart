import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_shell.dart';
import 'package:example/docs_ui/external_link.dart';
import 'package:example/docs_ui/url_strategy.dart';
import 'package:flutter/widgets.dart';

void main() {
  useDocsUrlStrategy();
  runApp(const DocsApp());
}

/// The `astryx_ui` documentation site.
///
/// Every component, with prose, live examples, the source that produced them,
/// and an API reference — in any of the eight themes, either brightness, both
/// densities and both text directions.
///
/// The site is built from `astryx_ui` itself. There is no Material here: the
/// navigation is a column of ghost buttons, the example frames are cards, the
/// Preview/Code switch is a tab list, the API references are tables. If a
/// widget is awkward to build a real application with, this is where it shows.
class DocsApp extends StatefulWidget {
  const DocsApp({super.key});

  @override
  State<DocsApp> createState() => _DocsAppState();
}

class _DocsAppState extends State<DocsApp> {
  final DocsController _controller = DocsController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DocsScope(
      notifier: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => AstryxApp(
          title: 'astryx_ui — documentation',
          theme: _controller.theme.theme,
          mode: _controller.mode,
          density: _controller.density,
          debugShowCheckedModeBanner: false,
          // The package deliberately does not decide what following a link
          // means — `AstryxLinkDelegate.none` warns and does nothing. This is
          // the application filling that hole, and it is the same seam an
          // `AstryxButton(destination:)` goes through.
          linkDelegate: const AstryxLinkDelegate.fromCallback(openExternalLink),
          // The page is chosen from the URL by `DocsController`, not by the
          // navigator. Pinning the initial route stops `WidgetsApp` trying to
          // push `/tokens` as a named route it has never heard of.
          initialRoute: '/',
          home: Directionality(
            textDirection: _controller.textDirection,
            child: const DocsShell(),
          ),
        ),
      ),
    );
  }
}

/// The smallest tree an example needs to render.
///
/// Used by `test/widget_test.dart` to pump all 150-odd previews, and by anyone
/// wanting to lift one example out of the docs into a scratch app.
class DocsPreviewHarness extends StatelessWidget {
  const DocsPreviewHarness({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AstryxApp(
      home: Builder(
        builder: (context) => ColoredBox(
          color: AstryxTheme.of(
            context,
          ).color(AstryxColorToken.backgroundBody),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );
  }
}
