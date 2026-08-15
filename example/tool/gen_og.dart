// This is a command-line tool: printing is how it reports.
// ignore_for_file: avoid_print

/// Gives the built site link previews, per route.
///
/// ## Why this exists
///
/// The site is a single-page app behind a `**` → `/index.html` rewrite, so
/// every route serves the same HTML. A crawler does not run Dart, so it never
/// reaches the router: without this, `/button` and `/table` would share one
/// card, or — as before this script — no card at all, since `web/index.html`
/// carries no Open Graph tags.
///
/// So the fix has to be static. For every page that has a marketing image, this
/// writes a real HTML file at that route, identical to `index.html` except for
/// its title, description and Open Graph block. Firebase serves the file when
/// one exists and falls through to the rewrite when it does not, so a route
/// without an image still works — it just gets the site-wide card.
///
/// ## The rule
///
/// A page gets its own card when `marketing/<id>/<id>-light.png` exists. That
/// is the whole condition: shoot a component, rerun, and the route has a card.
/// Nothing here lists components by hand.
///
/// ## Running it
///
/// After `flutter build web`, from the `example/` directory — it reads the
/// *built* `index.html` rather than `web/index.html`, so the bootstrap it
/// copies is the one that shipped, base href already substituted:
///
/// ```bash
/// flutter build web --release --wasm
/// dart run tool/gen_og.dart
/// ```
///
/// `firebase.json` runs both as `predeploy`, so a normal deploy needs neither.
library;

import 'dart:io';

import 'package:example/docs/pages.dart';

/// Where the site is served from. Open Graph requires absolute URLs — a
/// relative `og:image` is silently dropped by every crawler.
const String _site = 'https://astryxui.web.app';

/// The built site, relative to `example/`.
const String _build = 'build/web';

/// The marketing assets, relative to `example/`.
const String _marketing = '../marketing';

/// The page whose image stands in for every route that has none.
///
/// The login card, because it reads as a product rather than as a component
/// gallery — which is the right first impression for a link with no more
/// specific one available.
const String _fallbackShot = 'card';

/// Marks the injected block, so re-running without a rebuild replaces it
/// rather than stacking a second copy on top.
const String _begin = '<!-- og:begin -->';
const String _end = '<!-- og:end -->';

const int _imageWidth = 1200;
const int _imageHeight = 675;

void main() {
  if (!Directory('lib/docs').existsSync()) {
    stderr.writeln('Run this from the example/ directory.');
    exit(1);
  }

  final index = File('$_build/index.html');
  if (!index.existsSync()) {
    stderr.writeln(
      'No $_build/index.html — run `flutter build web` first. This script '
      'copies the built bootstrap, so there has to be one.',
    );
    exit(1);
  }

  // Read before anything is written: every generated page is a copy of the
  // template, and index.html is itself one of them.
  final template = _strip(index.readAsStringSync());
  final siteTitle = _tagged(template, 'title') ?? 'astryx_ui';
  final siteDescription = _description(template) ?? '';

  final images = Directory('$_build/og')..createSync(recursive: true);

  var cards = 0;
  for (final page in writtenDocPages) {
    final shot = File('$_marketing/${page.id}/${page.id}-light.png');
    if (!shot.existsSync()) continue;

    shot.copySync('${images.path}/${page.id}.png');
    File('$_build/${page.id}.html').writeAsStringSync(
      _render(
        template,
        // The widget name is what someone shared the link to see, so it leads.
        title: '${page.title} — astryx_ui',
        description: page.description,
        url: '$_site/${page.id}',
        image: '$_site/og/${page.id}.png',
        alt: '${page.title} in the astryx_ui documentation.',
      ),
    );
    cards++;
  }

  final fallback = File('$_marketing/$_fallbackShot/$_fallbackShot-light.png');
  if (!fallback.existsSync()) {
    stderr.writeln(
      'No $_fallbackShot image — every route would lose its card.',
    );
    exit(1);
  }
  fallback.copySync('${images.path}/default.png');

  index.writeAsStringSync(
    _render(
      template,
      title: siteTitle,
      description: siteDescription,
      url: '$_site/',
      image: '$_site/og/default.png',
      alt: 'astryx_ui — a Flutter design system for internal tools.',
    ),
  );

  print(
    'Wrote $cards route cards and a site-wide default to $_build/ '
    '(${writtenDocPages.length - cards} routes fall back).',
  );
}

/// Returns [html] with the Open Graph block replaced and the title and
/// description swapped for this page's.
String _render(
  String html, {
  required String title,
  required String description,
  required String url,
  required String image,
  required String alt,
}) {
  final block =
      '''
$_begin
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="astryx_ui">
  <meta property="og:title" content="${_escape(title)}">
  <meta property="og:description" content="${_escape(description)}">
  <meta property="og:url" content="${_escape(url)}">
  <meta property="og:image" content="${_escape(image)}">
  <meta property="og:image:type" content="image/png">
  <meta property="og:image:width" content="$_imageWidth">
  <meta property="og:image:height" content="$_imageHeight">
  <meta property="og:image:alt" content="${_escape(alt)}">
  <!--
    `summary_large_image` is what makes the card the full-width one. Twitter
    reads the `og:` tags above for everything else, so they are not repeated.
  -->
  <meta name="twitter:card" content="summary_large_image">
  <link rel="canonical" href="${_escape(url)}">
  $_end''';

  return html
      .replaceFirst(
        RegExp('<title>.*?</title>', dotAll: true),
        '<title>${_escape(title)}</title>',
      )
      .replaceFirst(
        RegExp('<meta name="description" content="[^"]*">'),
        '<meta name="description" content="${_escape(description)}">',
      )
      .replaceFirst('</head>', '$block\n</head>');
}

/// Removes a previously injected block, so the script is idempotent even when
/// run twice against the same build.
String _strip(String html) => html.replaceFirst(
  RegExp('${RegExp.escape(_begin)}.*?${RegExp.escape(_end)}\\s*', dotAll: true),
  '',
);

String? _tagged(String html, String tag) =>
    RegExp('<$tag>(.*?)</$tag>', dotAll: true).firstMatch(html)?.group(1);

String? _description(String html) => RegExp(
  '<meta name="description" content="([^"]*)">',
).firstMatch(html)?.group(1);

/// Escapes what can appear inside a double-quoted attribute. The descriptions
/// are prose from the registry, and an unescaped quote in one would truncate
/// the tag and take the rest of the block with it.
String _escape(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
