/// The links out to the issue tracker, in one place.
///
/// Every page carries a way to report what is wrong with the thing it
/// documents, and the templates in `.github/ISSUE_TEMPLATE/` arrive with the
/// component name already in them. GitHub prefills a form field whose `id:`
/// matches a query parameter, so the builders below are coupled to those ids —
/// renaming `component:` in `bug_report.yml` stops the prefill silently, which
/// is exactly why the coupling is written down here rather than spelled out on
/// two hundred pages.
///
/// **Pure Dart** — see the note on `model.dart`. `tool/gen_docs_md.dart` builds
/// the same URLs, so a page's markdown and its live version send the reader to
/// the same prefilled form.
library;

/// The repository. Every link here hangs off it.
const String astryxRepoUrl = 'https://github.com/JayashBhandary/astryx_ui';

/// Meta's own Astryx, for the upstream field of a component request.
const String astryxUpstreamUrl = 'https://astryx.atmeta.com';

/// The contributing guide, for anyone who would rather send the fix.
const String astryxContributingUrl =
    '$astryxRepoUrl/blob/main/.github/CONTRIBUTING.md';

/// A new issue from [template], with [fields] prefilled.
String _issue(
  String template, {
  String? title,
  Map<String, String> fields = const <String, String>{},
}) => Uri.parse('$astryxRepoUrl/issues/new').replace(
  queryParameters: <String, String>{
    'template': template,
    'title': ?title,
    ...fields,
  },
).toString();

/// A bug report against [area] — a widget name, or `Docs: Theming`.
///
/// The title carries no trailing dash or colon inviting the reporter to finish
/// the sentence: half of them would not, and `[bug] AstryxButton —` is a worse
/// title than `[bug] AstryxButton`.
String bugReportUrl(String area) => _issue(
  'bug_report.yml',
  title: '[bug] $area',
  fields: <String, String>{'component': area},
);

/// A feature request against [area], which already exists.
String featureRequestUrl(String area) => _issue(
  'feature_request.yml',
  title: '[feature] $area',
  fields: <String, String>{'area': area},
);

/// A request for a component that has no page yet.
///
/// [upstreamPath] is the path on [astryxUpstreamUrl] the widget would be
/// written from — the same value the page carries for the parity check, so a
/// reader asking for `StackItem` does not have to go and find it.
String componentRequestUrl(String component, {String? upstreamPath}) => _issue(
  'component_request.yml',
  title: '[component] $component',
  fields: <String, String>{
    'component': component,
    if (upstreamPath != null)
      'upstream-page': '$astryxUpstreamUrl$upstreamPath',
    // The dropdown's own wording. A page that exists as a placeholder *is*
    // marked Soon in the sidebar, so answering it for the reader is honest
    // rather than presumptuous. A mismatch here just leaves it unset.
    'status': 'Yes — it is planned, I am asking for it sooner',
  },
);

/// The showcase submission — an app someone built with the package.
///
/// Written out rather than built, so it is `const`: the page carrying it is a
/// `const DocPage` like every other, and one template name needs no encoding.
const String showcaseIssueUrl =
    '$astryxRepoUrl/issues/new?template=showcase.yml';
