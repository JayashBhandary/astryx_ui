/// The documentation model.
///
/// **Pure Dart — nothing here imports `flutter`.** That is deliberate: the same
/// model feeds the in-app pages *and* `tool/gen_docs_md.dart`, which runs on the
/// plain Dart VM to emit `docs/components/*.md`. One source of truth for both.
///
/// A page is a list of [DocBlock]s. Prose carries a tiny inline markup —
/// `` `code` ``, `**bold**` and `[label](target)` — understood by both
/// renderers.
library;

/// How far along a page is.
///
/// The generators in `tool/` read this: a page that is not [ready] is not
/// written to `doc/` and not offered to the agent skill, so neither can claim
/// coverage the site does not have.
enum DocStatus {
  /// Written: prose, live examples, an API table.
  ready,

  /// The widget is ported and the route resolves, but the page is empty.
  stub,

  /// Upstream has it; this port does not, yet.
  planned,

  /// Deliberately not ported — React-only, or replaced by a Flutter idiom.
  notPlanned,
}

/// One documentation page.
class DocPage {
  /// Creates a page.
  const DocPage({
    required this.id,
    required this.title,
    required this.group,
    required this.description,
    required this.blocks,
    this.status = DocStatus.ready,
    this.since,
    this.source,
    this.upstream,
    this.upstreamPath,
  });

  /// The route segment and markdown file name — `card`, `button`.
  final String id;

  /// The page heading, normally the widget's name.
  final String title;

  /// The navigation group. Pages keep registry order within a group.
  final String group;

  /// One sentence saying what the component is for.
  final String description;

  /// The page body, in order.
  final List<DocBlock> blocks;

  /// How far along the page is. Defaults to [DocStatus.ready].
  final DocStatus status;

  /// The package version this component first shipped in.
  final String? since;

  /// The implementing file, relative to the package root.
  final String? source;

  /// The upstream Astryx component this ports, if any.
  ///
  /// Slash-separated when one page documents several — `Card / ClickableCard`.
  /// A page also claims every upstream sub-component it absorbs, so
  /// `scrape/completesite_map.md` can be checked against the registry.
  final String? upstream;

  /// The upstream page this ports, as a path — `/components/AlertDialog`.
  ///
  /// Where to read when writing the page. Null for pages with no upstream
  /// counterpart.
  final String? upstreamPath;

  /// Whether the page has content worth publishing.
  bool get isWritten => status == DocStatus.ready;
}

/// A block of page content.
sealed class DocBlock {
  const DocBlock();
}

/// A section heading.
class DocHeading extends DocBlock {
  /// Creates a heading.
  const DocHeading(this.text, {this.level = 2});

  /// The heading text.
  final String text;

  /// 2 for a section, 3 for a subsection.
  final int level;
}

/// One or more paragraphs of prose.
class DocProse extends DocBlock {
  /// Creates prose.
  const DocProse(this.text);

  /// The paragraph. Supports the inline markup described on this library.
  final String text;
}

/// A bulleted or numbered list.
class DocList extends DocBlock {
  /// Creates a list.
  const DocList(this.items, {this.ordered = false});

  /// The items, each supporting inline markup.
  final List<String> items;

  /// Whether to number the items.
  final bool ordered;
}

/// A live example: the rendered widget, and the source that produced it.
///
/// [snippetId] refers to a region in `lib/examples/`, extracted by
/// `tool/gen_snippets.dart`. The preview and the code cannot drift, because
/// both come from that one region.
class DocExample extends DocBlock {
  /// Creates an example.
  const DocExample(
    this.snippetId, {
    this.title,
    this.note,
    this.align = DocExampleAlign.center,
    this.background = true,
  });

  /// The region id, which is also the preview's registry key.
  final String snippetId;

  /// An optional caption above the example.
  final String? title;

  /// An optional line below it, explaining what to look at.
  final String? note;

  /// How the preview sits in its frame.
  final DocExampleAlign align;

  /// Whether the preview frame is filled and bordered.
  final bool background;
}

/// How an example's preview is positioned.
enum DocExampleAlign {
  /// Centred, for a single control.
  center,

  /// Aligned to the reading start, for a form or a list.
  start,

  /// Stretched to the frame's full width, for a table or a banner.
  stretch,
}

/// A code block with no live counterpart — an import line, a `pubspec` entry.
class DocCode extends DocBlock {
  /// Creates a code block.
  const DocCode(this.code, {this.language = 'dart', this.title});

  /// The source.
  final String code;

  /// `dart`, `yaml`, `bash` or `text`.
  final String language;

  /// A file name shown above the block.
  final String? title;
}

/// A composition tree, drawn in a monospace box.
class DocTree extends DocBlock {
  /// Creates a tree.
  const DocTree(this.tree);

  /// The pre-drawn tree, one node per line.
  final String tree;
}

/// A short aside — a warning, a note, an accessibility rule.
class DocCallout extends DocBlock {
  /// Creates a callout.
  const DocCallout(this.kind, this.text);

  /// Creates a note.
  const DocCallout.note(this.text) : kind = DocCalloutKind.note;

  /// Creates a warning.
  const DocCallout.warning(this.text) : kind = DocCalloutKind.warning;

  /// Creates an accessibility note.
  const DocCallout.accessibility(this.text)
    : kind = DocCalloutKind.accessibility;

  /// What kind of aside this is.
  final DocCalloutKind kind;

  /// The body, supporting inline markup.
  final String text;
}

/// The kinds of [DocCallout].
enum DocCalloutKind {
  /// Worth knowing.
  note('Note'),

  /// Easy to get wrong.
  warning('Careful'),

  /// A rule that keeps the component usable for everyone.
  accessibility('Accessibility');

  const DocCalloutKind(this.label);

  /// The heading shown on the callout.
  final String label;
}

/// A property reference table for one class.
class DocApi extends DocBlock {
  /// Creates an API table.
  const DocApi(this.title, this.props, {this.description});

  /// The class the table documents.
  final String title;

  /// A sentence about the class, above the table.
  final String? description;

  /// The rows, in constructor order.
  final List<DocProp> props;
}

/// One row of a [DocApi] table.
class DocProp {
  /// Creates a property row.
  const DocProp(
    this.name,
    this.type,
    this.description, {
    this.defaultValue,
    this.required = false,
  });

  /// The parameter name.
  final String name;

  /// Its Dart type.
  final String type;

  /// What it does. Supports inline markup.
  final String description;

  /// The default, as written in the constructor. Null when there is none.
  final String? defaultValue;

  /// Whether the parameter is `required`.
  final bool required;
}

/// A free-form table — enum values, token names, keyboard shortcuts.
class DocTable extends DocBlock {
  /// Creates a table.
  const DocTable({required this.headers, required this.rows, this.title});

  /// The column headings.
  final List<String> headers;

  /// The rows. Each must be [headers] long. Cells support inline markup.
  final List<List<String>> rows;

  /// A caption above the table.
  final String? title;
}
