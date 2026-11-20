import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs_ui/components_overview.dart';
import 'package:example/docs_ui/doc_page_view.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_landing.dart';
import 'package:example/docs_ui/docs_sidebar.dart';
import 'package:example/docs_ui/docs_top_nav.dart';
import 'package:example/docs_ui/playground/playground_page.dart';
import 'package:example/docs_ui/themes_page.dart';
import 'package:flutter/widgets.dart';

/// The chrome around the documentation: the top bar, the sidebar, and the
/// page itself.
///
/// Built from `astryx_ui` throughout. The only Flutter primitives here are the
/// ones a design system does not supply — scrolling, and a scrollbar.
class DocsShell extends StatelessWidget {
  const DocsShell({super.key});

  /// Below this width the sidebar and the section links fold into the page
  /// menu in the top bar.
  static const double _wide = 1000;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);

    return ColoredBox(
      color: theme.color(AstryxColorToken.backgroundBody),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= _wide;

          // The landing page keeps the bar and drops the sidebar: the sidebar
          // answers "where is X", and somebody on the front door is still
          // asking "what is this".
          final Widget body;
          if (controller.onLanding) {
            body = const _LandingContent();
          } else if (controller.onPlayground) {
            // A workspace, not a page: it brings its own editor panel.
            body = const DocsPlayground();
          } else if (!controller.onComponentsOverview &&
              controller.pageId == docsThemesPageId) {
            // The Themes page brings its own panel instead of the sidebar.
            body = const DocsThemesPage();
          } else {
            body = AstryxHStack(
              align: AstryxStackAlign.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (wide) const DocsSidebar(),
                Expanded(
                  child: controller.onComponentsOverview
                      ? const DocsComponentsOverview()
                      : _Content(pageId: controller.pageId),
                ),
              ],
            );
          }

          return AstryxVStack(
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              DocsTopNav(wide: wide),
              const AstryxDivider(),
              Expanded(child: body),
            ],
          );
        },
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({required this.pageId});

  final String pageId;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final ScrollController _scroll = ScrollController();

  @override
  void didUpdateWidget(_Content oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A new page starts at its top, not where the last one was left.
    if (oldWidget.pageId != widget.pageId && _scroll.hasClients) {
      _scroll.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final ref = controller.page;

    return DocsScroller(
      controller: _scroll,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing(AstryxSpacingToken.spacing6),
          vertical: theme.spacing(AstryxSpacingToken.spacing8),
        ),
        child: AstryxCenter(
          axis: AstryxCenterAxis.horizontal,
          maxWidth: 900,
          child: DocsPageView(
            key: ValueKey<String>(ref.page.id),
            page: ref.page,
            previous: ref.previous,
            next: ref.next,
            // A page id navigates; anything else is a link off the site — the
            // upstream page a component ports, the repository, the issue
            // tracker — and goes to the delegate the app installed.
            onNavigate: (target) => docsFollow(context, target),
          ),
        ),
      ),
    );
  }
}

/// The landing page, with its own scroll position.
///
/// Separate from `_Content` because it is not a `DocPage`: it has no previous
/// or next, no measure of 900, and nothing to scroll back to the top of when
/// the page id changes.
class _LandingContent extends StatefulWidget {
  const _LandingContent();

  @override
  State<_LandingContent> createState() => _LandingContentState();
}

class _LandingContentState extends State<_LandingContent> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      DocsScroller(controller: _scroll, child: const DocsLanding());
}
