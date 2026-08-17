import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/groups.dart';
import 'package:example/docs/issue_links.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs_ui/doc_blocks.dart';
import 'package:example/docs_ui/inline_markup.dart';
import 'package:flutter/widgets.dart';

/// Renders one [DocPage].
class DocsPageView extends StatelessWidget {
  const DocsPageView({
    required this.page,
    required this.onNavigate,
    this.previous,
    this.next,
    super.key,
  });

  final DocPage page;

  /// Called with a page id when a link or a footer button is pressed.
  final ValueChanged<String> onNavigate;

  final DocPage? previous;
  final DocPage? next;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        _Masthead(page: page),
        for (final block in page.blocks) docsBlock(context, block, onNavigate),
        const AstryxDivider(),
        _Issues(page: page, onNavigate: onNavigate),
        _Footer(previous: previous, next: next, onNavigate: onNavigate),
      ],
    );
  }
}

class _Masthead extends StatelessWidget {
  const _Masthead({required this.page});

  final DocPage page;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxText(
          page.group,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.accent,
        ),
        AstryxHeading(page.title, level: 1, type: AstryxHeadingType.display3),
        DocsInlineText(
          page.description,
          type: AstryxTextType.large,
          color: AstryxTextColor.secondary,
        ),
        if (page.source != null || page.upstream != null)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              if (page.source != null)
                AstryxBadge(
                  page.source!,
                  icon: const AstryxIcon(AstryxIconName.viewColumns),
                ),
              if (page.upstream != null)
                AstryxBadge(
                  'upstream: ${page.upstream}',
                  variant: AstryxBadgeVariant.info,
                ),
              if (page.since != null)
                AstryxBadge(
                  'since ${page.since}',
                ),
            ],
          ),
      ],
    );
  }
}

/// Where to report what this page documents.
///
/// Every page ends with it, so the reader who has just found a wrong colour or
/// a missing keyboard shortcut does not have to go and work out where to say
/// so. The templates take the component name as a prefilled field, which is why
/// this is built from the page rather than being one link in the footer: an
/// issue that already names the widget is one round trip shorter.
class _Issues extends StatelessWidget {
  const _Issues({required this.page, required this.onNavigate});

  final DocPage page;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    // A guide is not a component, and `component: Theming` in a bug report
    // reads as a widget nobody can find. Prefixed, it sorts with the other
    // documentation reports instead.
    final isGuide = page.group == DocGroup.gettingStarted;
    final area = isGuide ? 'Docs: ${page.title}' : page.title;

    final (String prompt, List<Widget> actions) = page.isWritten
        ? (
            isGuide
                ? 'Something wrong on this page, or missing from it?'
                : 'Something wrong with `${page.title}`, or missing from it?',
            <Widget>[
              _IssueButton(
                label: isGuide ? 'Report a problem' : 'Report a bug',
                url: bugReportUrl(area),
                onNavigate: onNavigate,
              ),
              _IssueButton(
                label: isGuide ? 'Suggest a change' : 'Request a change',
                url: featureRequestUrl(area),
                onNavigate: onNavigate,
              ),
            ],
          )
        : (
            '`${page.title}` is not written yet. A request that says what you '
                'need it for is what moves it up the order.',
            <Widget>[
              _IssueButton(
                label: 'Ask for this component',
                url: componentRequestUrl(
                  page.upstream ?? page.title,
                  upstreamPath: page.upstreamPath,
                ),
                onNavigate: onNavigate,
              ),
            ],
          );

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        DocsInlineText(
          prompt,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: actions,
        ),
      ],
    );
  }
}

class _IssueButton extends StatelessWidget {
  const _IssueButton({
    required this.label,
    required this.url,
    required this.onNavigate,
  });

  final String label;
  final String url;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) => AstryxButton(
    label: label,
    variant: AstryxButtonVariant.ghost,
    size: AstryxButtonSize.sm,
    trailing: const AstryxIcon(AstryxIconName.externalLink),
    onPressed: () => onNavigate(url),
  );
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.onNavigate,
    this.previous,
    this.next,
  });

  final DocPage? previous;
  final DocPage? next;
  final ValueChanged<String> onNavigate;

  /// Below this the two page titles cannot sit side by side.
  ///
  /// Some of them are long — `InternationalizationProvider` — so the pair
  /// stacks rather than being squeezed or, as it was, overflowing.
  static const double _minRowWidth = 520;

  @override
  Widget build(BuildContext context) {
    final back = previous;
    final forward = next;

    return LayoutBuilder(
      builder: (context, constraints) {
        final backButton = back == null
            ? null
            : AstryxButton(
                label: back.title,
                leading: const AstryxIcon(AstryxIconName.chevronLeft),
                onPressed: () => onNavigate(back.id),
              );
        final forwardButton = forward == null
            ? null
            : AstryxButton(
                label: forward.title,
                trailing: const AstryxIcon(AstryxIconName.chevronRight),
                onPressed: () => onNavigate(forward.id),
              );

        if (constraints.maxWidth < _minRowWidth) {
          return AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[?backButton, ?forwardButton],
          );
        }

        // Flexible, not bare: two long titles — `AstryxLocalizationsScope` next
        // to `useTranslator → AstryxLocalizations.of` — still exceed a wide
        // column, and a footer is not worth an overflow. Bounded, the button
        // truncates its own label instead.
        return AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(child: backButton ?? const SizedBox.shrink()),
            Flexible(child: forwardButton ?? const SizedBox.shrink()),
          ],
        );
      },
    );
  }
}
