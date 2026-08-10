import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/previews.g.dart';
import 'package:example/docs/snippets.g.dart';
import 'package:example/docs_ui/code_block.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/inline_markup.dart';
import 'package:example/docs_ui/segmented.dart';
import 'package:flutter/widgets.dart';

/// Below this, the preview area is already about phone-width and the width
/// picker has nothing to offer — so it is not drawn.
///
/// A little more than [DocsPreviewWidth.mobile]'s own width, because a frame
/// the same size as the space around it demonstrates nothing.
const double docsDevicePickerMinWidth = 460;

/// Identifies the box that constrains a preview, so a test can measure it.
const Key docsPreviewFrameKey = Key('docs-preview-frame');

/// A live example: the rendered widget under a `Preview` tab, and the source
/// that produced it under `Code`.
///
/// Both come from one region in `lib/examples/`, so the code cannot describe
/// something other than what is on screen.
class DocsExampleBlock extends StatefulWidget {
  const DocsExampleBlock(this.example, {super.key});

  final DocExample example;

  @override
  State<DocsExampleBlock> createState() => _DocsExampleBlockState();
}

enum _Tab { preview, code }

class _DocsExampleBlockState extends State<DocsExampleBlock> {
  _Tab _tab = _Tab.preview;

  /// The fallback for an example lifted out of the site, where there is no
  /// chrome to remember anything.
  DocsPreviewWidth _ownWidth = DocsPreviewWidth.desktop;

  /// The chosen width: the site's if there is a site, this block's if not.
  DocsPreviewWidth get _width =>
      DocsScope.maybeOf(context)?.previewWidth ?? _ownWidth;

  /// Records the choice where it will be remembered.
  ///
  /// On the controller it is site-wide, so every other example follows and the
  /// choice survives navigation — which is the whole point of choosing.
  void _chooseWidth(DocsPreviewWidth value) {
    final controller = DocsScope.maybeOf(context);
    if (controller == null) {
      setState(() => _ownWidth = value);
    } else {
      controller.previewWidth = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final id = widget.example.snippetId;
    final builder = docPreviews[id];
    final source = docSnippets[id];

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        if (widget.example.title != null)
          DocsInlineText(widget.example.title!, type: AstryxTextType.label),
        AstryxCard(
          padding: AstryxSpacingToken.spacing0,
          header: Padding(
            padding: EdgeInsetsDirectional.only(
              start: theme.spacing(AstryxSpacingToken.spacing2),
              end: theme.spacing(AstryxSpacingToken.spacing2),
              top: theme.spacing(AstryxSpacingToken.spacing1),
            ),
            // The device picker belongs to the preview, so it appears only on
            // that tab — and only where the preview area is wide enough for the
            // two widths to differ.
            child: LayoutBuilder(
              builder: (context, constraints) => AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                justify: AstryxStackJustify.between,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  AstryxTabList<_Tab>(
                    label: 'Example view',
                    size: AstryxTabSize.sm,
                    value: _tab,
                    onChanged: (value) => setState(() => _tab = value),
                    tabs: const <AstryxTab<_Tab>>[
                      AstryxTab(value: _Tab.preview, label: 'Preview'),
                      AstryxTab(value: _Tab.code, label: 'Code'),
                    ],
                  ),
                  if (_tab == _Tab.preview &&
                      constraints.maxWidth >= docsDevicePickerMinWidth)
                    DocsSegmented<DocsPreviewWidth>(
                      label: 'Preview width',
                      values: DocsPreviewWidth.values,
                      selected: _width,
                      labelOf: (value) => value.label,
                      iconOf: (value) => Icon(value.icon),
                      onSelected: _chooseWidth,
                    ),
                ],
              ),
            ),
          ),
          child: switch (_tab) {
            _Tab.preview => _Preview(
              example: widget.example,
              builder: builder,
              width: _width,
            ),
            _Tab.code => _Code(id: id, source: source),
          },
        ),
        if (widget.example.note != null)
          DocsInlineText(
            widget.example.note!,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
      ],
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    required this.example,
    required this.width,
    this.builder,
  });

  final DocExample example;
  final DocsPreviewWidth width;
  final WidgetBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    if (builder == null) {
      return Padding(
        padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing4)),
        child: AstryxBanner(
          status: AstryxBannerStatus.error,
          title: 'No preview for "${example.snippetId}"',
          description: 'Run `dart run tool/gen_snippets.dart`.',
        ),
      );
    }

    final child = Builder(builder: builder!);

    final content = switch (example.align) {
      DocExampleAlign.center => Center(child: child),
      DocExampleAlign.start => Align(
        alignment: AlignmentDirectional.topStart,
        child: child,
      ),
      DocExampleAlign.stretch => SizedBox(width: double.infinity, child: child),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: example.background
            ? theme.color(AstryxColorToken.backgroundBody)
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing6)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 120),
          child: switch (width.width) {
            null => KeyedSubtree(key: docsPreviewFrameKey, child: content),
            final pinned => _MobileFrame(width: pinned, child: content),
          },
        ),
      ),
    );
  }
}

/// A preview pinned to a fixed width, centred, with its edges drawn.
///
/// The border is the point: without it a narrow example looks like an example
/// that happens to be narrow, rather than one being shown at a phone's width.
class _MobileFrame extends StatelessWidget {
  const _MobileFrame({required this.width, required this.child});

  /// The width to pin to, before clamping.
  final double width;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Never wider than the room available. The picker is not offered on a
        // narrow page, but a window resized *after* choosing Mobile would
        // otherwise leave a 390 box in a smaller slot.
        final pinned = constraints.maxWidth < width
            ? constraints.maxWidth
            : width;

        return Center(
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.center,
            children: <Widget>[
              Container(
                key: docsPreviewFrameKey,
                width: pinned,
                padding: EdgeInsets.all(
                  theme.spacing(AstryxSpacingToken.spacing3),
                ),
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.backgroundSurface),
                  borderRadius: theme.borderRadius(AstryxRadiusToken.container),
                  border: Border.all(
                    color: theme.color(AstryxColorToken.border),
                    width: theme.borderWidth(),
                  ),
                ),
                child: child,
              ),
              // The measured width, not the constant: when the frame has been
              // clamped, the constant would be a caption describing a box that
              // is not on screen.
              AstryxText(
                '${pinned.round()} logical pixels wide',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Code extends StatelessWidget {
  const _Code({required this.id, this.source});

  final String id;
  final String? source;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    if (source == null) {
      return Padding(
        padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing4)),
        child: AstryxBanner(
          status: AstryxBannerStatus.error,
          title: 'No snippet for "$id"',
          description: 'Run `dart run tool/gen_snippets.dart`.',
        ),
      );
    }

    return DocsCodeBlock(
      source: source!,
      title: 'lib/examples — $id',
      showLineNumbers: true,
      bordered: false,
    );
  }
}
