import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs/previews.g.dart';
import 'package:example/docs/snippets.g.dart';
import 'package:example/docs_ui/code_block.dart';
import 'package:example/docs_ui/inline_markup.dart';
import 'package:flutter/widgets.dart';

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
          DocsInlineText(
            widget.example.title!,
            type: AstryxTextType.label,
          ),
        AstryxCard(
          padding: AstryxSpacingToken.spacing0,
          header: Padding(
            padding: EdgeInsetsDirectional.only(
              start: theme.spacing(AstryxSpacingToken.spacing2),
              top: theme.spacing(AstryxSpacingToken.spacing1),
            ),
            child: AstryxTabList<_Tab>(
              label: 'Example view',
              size: AstryxTabSize.sm,
              value: _tab,
              onChanged: (value) => setState(() => _tab = value),
              tabs: const <AstryxTab<_Tab>>[
                AstryxTab(value: _Tab.preview, label: 'Preview'),
                AstryxTab(value: _Tab.code, label: 'Code'),
              ],
            ),
          ),
          child: switch (_tab) {
            _Tab.preview => _Preview(
              example: widget.example,
              builder: builder,
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
  const _Preview({required this.example, this.builder});

  final DocExample example;
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
          child: switch (example.align) {
            DocExampleAlign.center => Center(child: child),
            DocExampleAlign.start => Align(
              alignment: AlignmentDirectional.topStart,
              child: child,
            ),
            DocExampleAlign.stretch => SizedBox(
              width: double.infinity,
              child: child,
            ),
          },
        ),
      ),
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
