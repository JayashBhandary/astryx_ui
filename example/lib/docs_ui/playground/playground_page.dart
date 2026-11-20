/// The playground, after upstream's: an editor on one side — the example's
/// source, or the theme editor — and the example live on the other, in the
/// theme being built.
///
/// Upstream compiles JSX in the browser. Flutter on the web cannot compile Dart
/// at run time, so the code side is a picker over every example in the docs
/// with its real source; what is editable is the theme, which is the half of
/// the playground the engine can do live.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/categories.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs/previews.g.dart';
import 'package:example/docs/snippets.g.dart';
import 'package:example/docs_ui/code_block.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_sidebar.dart';
import 'package:example/docs_ui/playground/download.dart';
import 'package:example/docs_ui/playground/playground_theme.dart';
import 'package:example/docs_ui/segmented.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// One example the playground can show.
typedef PlaygroundExample = ({String id, String label, String group});

/// Every example with a preview, labelled by its page, in registry order.
final List<PlaygroundExample> playgroundExamples = () {
  final seen = <String>{};
  final out = <PlaygroundExample>[];
  for (final page in writtenDocPages) {
    final isTemplate = page.group == DocGroup.templates;
    if (!isTemplate && docCategory(page) == null) continue;
    for (final block in page.blocks.whereType<DocExample>()) {
      final id = block.snippetId;
      if (!docPreviews.containsKey(id) || !seen.add(id)) continue;
      final title = (block.title ?? '').replaceAll('`', '').trim();
      final name = docDisplayName(page);
      out.add((
        id: id,
        label: title.isEmpty ? name : '$name · $title',
        group: isTemplate ? 'Templates' : 'Components',
      ));
    }
  }
  return out;
}();

/// Which panel the editor shows.
enum _Tab { code, theme }

/// The preview's width.
enum _Device {
  desktop('Desktop', LucideIcons.monitor, null),
  phone('Phone', LucideIcons.smartphone, 390);

  const _Device(this.label, this.icon, this.width);

  final String label;
  final IconData icon;
  final double? width;
}

/// The page.
class DocsPlayground extends StatefulWidget {
  const DocsPlayground({super.key});

  /// Below this the editor stacks above the preview.
  static const double wideWidth = 1000;

  @override
  State<DocsPlayground> createState() => _DocsPlaygroundState();
}

class _DocsPlaygroundState extends State<DocsPlayground> {
  _Tab _tab = _Tab.code;
  _Device _device = _Device.desktop;
  bool _expanded = false;

  final ScrollController _editorScroll = ScrollController();
  final ScrollController _previewScroll = ScrollController();

  // The resolved theme, rebuilt only when the edited value changes: the
  // engine runs the whole colour solve on every call.
  String? _builtKey;
  AstryxDefinedTheme? _built;

  AstryxDefinedTheme _themeFor(PlaygroundTheme value) {
    final key = value.encode();
    if (key != _builtKey || _built == null) {
      _builtKey = key;
      try {
        _built = value.build();
      } on Object {
        // A value the engine rejects keeps the last good theme on screen.
        _built ??= value.base.theme;
      }
    }
    return _built!;
  }

  @override
  void dispose() {
    _editorScroll.dispose();
    _previewScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final siteDark = theme.mode == AstryxThemeMode.dark;
    final previewDark = switch (controller.playgroundMode) {
      AstryxColorMode.dark => true,
      AstryxColorMode.light => false,
      _ => siteDark,
    };
    final built = _themeFor(controller.playgroundTheme);

    final editor = _Editor(
      tab: _tab,
      onTab: (value) => setState(() => _tab = value),
      previewDark: previewDark,
      scroll: _editorScroll,
    );

    final preview = AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        _Toolbar(
          device: _device,
          onDevice: (value) => setState(() => _device = value),
          expanded: _expanded,
          onExpand: () => setState(() => _expanded = !_expanded),
          previewDark: previewDark,
        ),
        Expanded(
          child: _Preview(
            theme: built,
            dark: previewDark,
            device: _device,
            scroll: _previewScroll,
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final pad = theme.spacing(AstryxSpacingToken.spacing3);
        if (constraints.maxWidth < DocsPlayground.wideWidth) {
          return Padding(
            padding: EdgeInsets.all(pad),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                if (!_expanded) SizedBox(height: 380, child: editor),
                Expanded(child: preview),
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.all(pad),
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              if (!_expanded) SizedBox(width: 440, child: editor),
              Expanded(child: preview),
            ],
          ),
        );
      },
    );
  }
}

/// A painted panel that can hold a scroll view (an `AstryxCard` sizes to its
/// content and cannot).
class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundCard),
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        border: Border.all(color: theme.color(AstryxColorToken.border)),
      ),
      child: ClipRRect(
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        child: child,
      ),
    );
  }
}

class _Editor extends StatelessWidget {
  const _Editor({
    required this.tab,
    required this.onTab,
    required this.previewDark,
    required this.scroll,
  });

  final _Tab tab;
  final ValueChanged<_Tab> onTab;
  final bool previewDark;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final pad = theme.spacing(AstryxSpacingToken.spacing4);

    final exampleEntries = <AstryxSelectorEntry<String>>[];
    String? group;
    for (final example in playgroundExamples) {
      if (example.group != group) {
        group = example.group;
        exampleEntries.add(AstryxSelectorSection<String>(example.group));
      }
      exampleEntries.add(
        AstryxSelectorOption<String>(value: example.id, label: example.label),
      );
    }

    return _Panel(
      child: AstryxVStack(
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(pad, pad, pad, 0),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                const AstryxHeading('Playground', level: 1),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: AstryxSelector<String>(
                        label: 'Example',
                        labelHidden: true,
                        size: AstryxInputSize.sm,
                        showSearch: true,
                        searchPlaceholder: 'Search examples',
                        maxListHeight: 420,
                        value: controller.playgroundExample,
                        leading: const Icon(LucideIcons.layoutGrid, size: 14),
                        onChanged: (value) {
                          if (value != null) {
                            controller.playgroundExample = value;
                          }
                        },
                        options: exampleEntries,
                      ),
                    ),
                    Expanded(
                      child: AstryxSelector<DocsTheme>(
                        label: 'Base theme',
                        labelHidden: true,
                        size: AstryxInputSize.sm,
                        value: controller.playgroundTheme.base,
                        leading: const Icon(LucideIcons.palette, size: 14),
                        onChanged: (value) {
                          if (value == null) return;
                          // A new base starts clean: overrides tuned against
                          // one palette rarely suit another.
                          controller.playgroundTheme = PlaygroundTheme(
                            name: controller.playgroundTheme.name,
                            base: value,
                          );
                        },
                        options: <AstryxSelectorEntry<DocsTheme>>[
                          for (final value in DocsTheme.values)
                            AstryxSelectorOption<DocsTheme>(
                              value: value,
                              label: value.label,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                AstryxTabList<_Tab>(
                  label: 'Editor',
                  value: tab,
                  onChanged: onTab,
                  tabs: const <AstryxTab<_Tab>>[
                    AstryxTab(value: _Tab.code, label: 'Code'),
                    AstryxTab(value: _Tab.theme, label: 'Theme editor'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (tab) {
              _Tab.code => _CodePanel(scroll: scroll),
              _Tab.theme => DocsScroller(
                controller: scroll,
                child: Padding(
                  padding: EdgeInsets.all(pad),
                  child: PlaygroundThemeEditor(dark: previewDark),
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _CodePanel extends StatelessWidget {
  const _CodePanel({required this.scroll});

  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final id = controller.playgroundExample;
    final source = docSnippets[id];

    return AstryxVStack(
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing(AstryxSpacingToken.spacing4),
            vertical: theme.spacing(AstryxSpacingToken.spacing2),
          ),
          child: const AstryxText(
            'Read-only: the source that renders the preview. Change the '
            'theme in the Theme editor tab.',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ),
        Expanded(
          child: DocsScroller(
            controller: scroll,
            child: source == null
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: AstryxText('No source for this example.'),
                  )
                : DocsCodeBlock(
                    source: source,
                    title: 'lib/examples — $id',
                    showLineNumbers: true,
                    bordered: false,
                  ),
          ),
        ),
      ],
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.device,
    required this.onDevice,
    required this.expanded,
    required this.onExpand,
    required this.previewDark,
  });

  final _Device device;
  final ValueChanged<_Device> onDevice;
  final bool expanded;
  final VoidCallback onExpand;
  final bool previewDark;

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      justify: AstryxStackJustify.between,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        AstryxIconButton.custom(
          label: expanded ? 'Show the editor' : 'Hide the editor',
          tooltip: expanded ? 'Show the editor' : 'Expand the preview',
          variant: AstryxButtonVariant.ghost,
          onPressed: onExpand,
          child: Icon(
            expanded ? LucideIcons.minimize2 : LucideIcons.maximize2,
            size: 18,
          ),
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxIconButton.custom(
              label: previewDark ? 'Preview in light' : 'Preview in dark',
              tooltip: previewDark ? 'Switch to light' : 'Switch to dark',
              variant: AstryxButtonVariant.ghost,
              onPressed: () => controller.playgroundMode = previewDark
                  ? AstryxColorMode.light
                  : AstryxColorMode.dark,
              child: Icon(
                previewDark ? LucideIcons.sun : LucideIcons.moon,
                size: 18,
              ),
            ),
            DocsSegmented<_Device>(
              label: 'Preview width',
              values: _Device.values,
              selected: device,
              labelOf: (value) => value.label,
              iconOf: (value) => Icon(value.icon),
              onSelected: onDevice,
            ),
          ],
        ),
        const _ExportButton(),
      ],
    );
  }
}

/// Export: the share link, and the theme as a Dart file.
class _ExportButton extends StatelessWidget {
  const _ExportButton();

  @override
  Widget build(BuildContext context) {
    return AstryxPopover(
      label: 'Export',
      align: AstryxOverlayAlign.end,
      width: 380,
      triggerBuilder: (context, overlay) => AstryxButton(
        label: 'Export',
        variant: AstryxButtonVariant.primary,
        size: AstryxButtonSize.sm,
        trailing: const Icon(LucideIcons.share),
        onPressed: overlay.toggle,
      ),
      content: const _ExportPanel(),
    );
  }
}

class _ExportPanel extends StatefulWidget {
  const _ExportPanel();

  @override
  State<_ExportPanel> createState() => _ExportPanelState();
}

class _ExportPanelState extends State<_ExportPanel> {
  late final TextEditingController _name = TextEditingController(
    text: DocsScope.of(context).playgroundTheme.name,
  );

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final link = Uri.base.resolveUri(controller.playgroundUri).toString();
    final source = controller.playgroundTheme.toDartSource();
    final slug = controller.playgroundTheme.name
        .replaceAll(RegExp('[^A-Za-z0-9_]+'), '_')
        .toLowerCase();
    final fileName = '$slug.dart';

    return Padding(
      padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing3)),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxText('Share URL', type: AstryxTextType.label),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: AstryxText(
                  link,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ),
              AstryxButton(
                label: 'Copy URL',
                size: AstryxButtonSize.sm,
                onPressed: () => Clipboard.setData(ClipboardData(text: link)),
              ),
            ],
          ),
          const AstryxDivider(),
          AstryxTextInput(
            label: 'Theme name',
            controller: _name,
            size: AstryxInputSize.sm,
            onChanged: (value) => controller.playgroundTheme = controller
                .playgroundTheme
                .copyWith(name: value.trim().isEmpty ? 'my_theme' : value),
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: AstryxButton(
                  label: 'Copy Dart',
                  size: AstryxButtonSize.sm,
                  leading: const AstryxIcon(AstryxIconName.copy),
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: source)),
                ),
              ),
              Expanded(
                child: AstryxButton(
                  label: 'Download theme',
                  variant: AstryxButtonVariant.primary,
                  size: AstryxButtonSize.sm,
                  leading: const Icon(LucideIcons.download),
                  onPressed: () => downloadTextFile(fileName, source),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 220,
            child: SingleChildScrollView(
              child: DocsCodeBlock(source: source, title: fileName),
            ),
          ),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    required this.theme,
    required this.dark,
    required this.device,
    required this.scroll,
  });

  final AstryxDefinedTheme theme;
  final bool dark;
  final _Device device;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    final site = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final builder = docPreviews[controller.playgroundExample];

    final content = builder == null
        ? const Center(child: AstryxText('This example has no preview.'))
        : Builder(builder: builder);

    return _Panel(
      child: AstryxThemeProvider(
        theme: theme,
        mode: dark ? AstryxColorMode.dark : AstryxColorMode.light,
        density: controller.density,
        child: Builder(
          builder: (context) {
            final t = AstryxTheme.of(context);
            return ColoredBox(
              color: t.color(AstryxColorToken.backgroundBody),
              child: DocsScroller(
                controller: scroll,
                child: Padding(
                  padding: EdgeInsets.all(
                    site.spacing(AstryxSpacingToken.spacing6),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: device.width ?? 1100,
                        minHeight: 200,
                      ),
                      child: device.width == null
                          ? KeyedSubtree(
                              key: ValueKey<String>(
                                controller.playgroundExample,
                              ),
                              child: content,
                            )
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: t.color(AstryxColorToken.border),
                                ),
                                borderRadius: t.borderRadius(
                                  AstryxRadiusToken.container,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: KeyedSubtree(
                                  key: ValueKey<String>(
                                    controller.playgroundExample,
                                  ),
                                  child: content,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The theme editor: every control writes to the controller's
/// [PlaygroundTheme], and the preview rebuilds from it.
class PlaygroundThemeEditor extends StatefulWidget {
  const PlaygroundThemeEditor({required this.dark, super.key});

  /// Which half of a colour override the colour fields edit.
  final bool dark;

  @override
  State<PlaygroundThemeEditor> createState() => _PlaygroundThemeEditorState();
}

enum _Section { base, type, advanced }

class _PlaygroundThemeEditorState extends State<PlaygroundThemeEditor> {
  _Section _section = _Section.base;

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final value = controller.playgroundTheme;
    void set(PlaygroundTheme next) => controller.playgroundTheme = next;

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<_Section>(
          label: 'Theme editor section',
          size: AstryxTabSize.sm,
          value: _section,
          onChanged: (s) => setState(() => _section = s),
          tabs: const <AstryxTab<_Section>>[
            AstryxTab(value: _Section.base, label: 'Colours & size'),
            AstryxTab(value: _Section.type, label: 'Type & motion'),
            AstryxTab(value: _Section.advanced, label: 'Advanced'),
          ],
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: AstryxText(
                value.isEdited
                    ? 'Extends ${value.base.label}, with your changes.'
                    : 'Showing ${value.base.label} as shipped.',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ),
            AstryxButton(
              label: 'Reset',
              variant: AstryxButtonVariant.secondary,
              size: AstryxButtonSize.sm,
              enabled: value.isEdited,
              onPressed: () =>
                  set(PlaygroundTheme(name: value.name, base: value.base)),
            ),
          ],
        ),
        ...switch (_section) {
          _Section.base => _baseControls(value, set),
          _Section.type => _typeControls(value, set),
          _Section.advanced => _advancedControls(value, set),
        },
      ],
    );
  }

  List<Widget> _baseControls(
    PlaygroundTheme value,
    void Function(PlaygroundTheme) set,
  ) {
    final baseTokens = value.base.theme.tokens;
    String current(String token) {
      final override = value.colors[token];
      final mine = widget.dark ? override?.dark : override?.light;
      if (mine != null) return mine;
      final (light, dark) = splitLightDark(baseTokens[token]);
      return widget.dark ? dark : light;
    }

    final density = playgroundDensities.indexWhere(
      (d) =>
          d.$2 == (value.spacingScale ?? 1) &&
          d.$3 == (value.elementScale ?? 1),
    );

    return <Widget>[
      _Heading(
        'Colours',
        note:
            'Fields edit the ${widget.dark ? 'dark' : 'light'} half of each '
            'colour. Switch the preview to edit the other.',
      ),
      _ColorField(
        label: 'Accent (seed)',
        value: value.accent ?? splitLightDark(baseTokens['--color-accent']).$1,
        edited: value.accent != null,
        onChanged: (hex) => set(value.copyWith(accent: () => hex)),
        hint: 'Regenerates the palette from one colour, in both modes.',
      ),
      for (final (token, label) in playgroundColorTokens)
        _ColorField(
          label: label,
          value: current(token),
          edited:
              (widget.dark
                  ? value.colors[token]?.dark
                  : value.colors[token]?.light) !=
              null,
          onChanged: (hex) =>
              set(value.withColor(token, dark: widget.dark, value: hex)),
        ),
      const _Heading('Preset'),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          for (var i = 0; i < playgroundDensities.length; i++)
            _ChoiceChip(
              label: playgroundDensities[i].$1,
              selected: density == i,
              onPressed: () => set(
                value.copyWith(
                  spacingScale: () => i == 1 ? null : playgroundDensities[i].$2,
                  elementScale: () => i == 1 ? null : playgroundDensities[i].$3,
                ),
              ),
            ),
        ],
      ),
      _StepRow(
        label: 'Corner radius',
        steps: playgroundRadii,
        value: value.radiusMultiplier,
        onChanged: (v) => set(value.copyWith(radiusMultiplier: () => v)),
        format: (v) => '${(4 * v * 2).round()}px buttons',
      ),
      _StepRow(
        label: 'Spacing',
        steps: playgroundSpacings,
        value: value.spacingScale,
        onChanged: (v) => set(value.copyWith(spacingScale: () => v)),
        format: (v) => '$v×',
      ),
      _Labeled(
        label: 'Element size',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            for (final scale in playgroundElementScales)
              _ChoiceChip(
                label: '$scale×',
                selected: (value.elementScale ?? 1) == scale,
                onPressed: () => set(
                  value.copyWith(elementScale: () => scale == 1 ? null : scale),
                ),
              ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _typeControls(
    PlaygroundTheme value,
    void Function(PlaygroundTheme) set,
  ) {
    return <Widget>[
      const _Heading(
        'Fonts',
        note:
            'Named, not bundled: a family applies once it is in your '
            'app’s pubspec. The export carries it either way.',
      ),
      _FontField(
        label: 'Heading font',
        value: value.headingFont,
        onChanged: (v) => set(value.copyWith(headingFont: () => v)),
      ),
      _FontField(
        label: 'Body font',
        value: value.bodyFont,
        onChanged: (v) => set(value.copyWith(bodyFont: () => v)),
      ),
      const _Heading('Type'),
      AstryxSelector<double>(
        label: 'Type scale',
        size: AstryxInputSize.sm,
        value: value.typeRatio,
        placeholder: 'Inherit from base',
        showClear: true,
        onChanged: (v) => set(value.copyWith(typeRatio: () => v)),
        options: <AstryxSelectorEntry<double>>[
          for (final (ratio, label) in playgroundTypeRatios)
            AstryxSelectorOption<double>(value: ratio, label: label),
        ],
      ),
      _StepRow(
        label: 'Type size',
        steps: playgroundTypeSizes,
        value: value.typeBase,
        onChanged: (v) => set(value.copyWith(typeBase: () => v)),
        format: (v) => '${v.round()}px body',
      ),
      const _Heading('Motion'),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          for (var i = 0; i < playgroundMotions.length; i++)
            _ChoiceChip(
              label: playgroundMotions[i].$1,
              selected: value.motion == i,
              onPressed: () => set(
                value.copyWith(motion: () => value.motion == i ? null : i),
              ),
            ),
        ],
      ),
      if (value.motion != null)
        AstryxText(
          () {
            final m = playgroundMotions[value.motion!];
            return 'Fast ${m.$2.round()}ms · medium ${m.$3.round()}ms · '
                'slow ${m.$4.round()}ms';
          }(),
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
    ];
  }

  List<Widget> _advancedControls(
    PlaygroundTheme value,
    void Function(PlaygroundTheme) set,
  ) {
    return <Widget>[
      const _Heading(
        'Palette generation',
        note:
            'Used when the accent is set: how the neutrals lean, and how '
            'far text is pushed from its background.',
      ),
      _Labeled(
        label: 'Neutral style',
        child: DocsSegmented<AstryxNeutralStyle>(
          label: 'Neutral style',
          values: AstryxNeutralStyle.values,
          selected: value.neutralStyle ?? AstryxNeutralStyle.cool,
          labelOf: (v) => v.name,
          onSelected: (v) => set(value.copyWith(neutralStyle: () => v)),
        ),
      ),
      _Labeled(
        label: 'Contrast',
        child: DocsSegmented<AstryxContrastLevel>(
          label: 'Contrast',
          values: AstryxContrastLevel.values,
          selected: value.contrast ?? AstryxContrastLevel.standard,
          labelOf: (v) => v.name,
          onSelected: (v) => set(value.copyWith(contrast: () => v)),
        ),
      ),
      const _Heading('What will be exported'),
      DocsCodeBlock(source: value.toDartSource(), title: 'theme.dart'),
    ];
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {this.note});

  final String text;
  final String? note;

  @override
  Widget build(BuildContext context) => AstryxVStack(
    gap: AstryxSpacingToken.spacing1,
    align: AstryxStackAlign.stretch,
    children: <Widget>[
      AstryxHeading(text, level: 4),
      if (note != null)
        AstryxText(
          note!,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
    ],
  );
}

class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => AstryxVStack(
    gap: AstryxSpacingToken.spacing2,
    align: AstryxStackAlign.stretch,
    children: <Widget>[
      AstryxText(label, type: AstryxTextType.label),
      child,
    ],
  );
}

/// A small toggle chip: a ghost button that reads as selected.
class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: AstryxButton(
      label: label,
      size: AstryxButtonSize.sm,
      variant: selected
          ? AstryxButtonVariant.primary
          : AstryxButtonVariant.secondary,
      onPressed: onPressed,
    ),
  );
}

/// S / M / L / XL, plus "inherit".
class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.label,
    required this.steps,
    required this.value,
    required this.onChanged,
    required this.format,
  });

  final String label;
  final Map<PlaygroundStep, double> steps;
  final double? value;
  final ValueChanged<double?> onChanged;
  final String Function(double) format;

  @override
  Widget build(BuildContext context) => _Labeled(
    label: label,
    child: AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Wrap(
          spacing: 6,
          children: <Widget>[
            for (final entry in steps.entries)
              _ChoiceChip(
                label: entry.key.label,
                selected: value == entry.value,
                onPressed: () =>
                    onChanged(value == entry.value ? null : entry.value),
              ),
          ],
        ),
        Expanded(
          child: AstryxText(
            value == null ? 'Inherit' : format(value!),
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
            maxLines: 1,
          ),
        ),
      ],
    ),
  );
}

/// A colour: a swatch and a hex field. Invalid input is held, not applied.
class _ColorField extends StatefulWidget {
  const _ColorField({
    required this.label,
    required this.value,
    required this.edited,
    required this.onChanged,
    this.hint,
  });

  final String label;

  /// What the theme has now — the override, or the base theme's value.
  final String value;
  final bool edited;

  /// Called with a valid hex, or null to drop the override.
  final ValueChanged<String?> onChanged;
  final String? hint;

  @override
  State<_ColorField> createState() => _ColorFieldState();
}

class _ColorFieldState extends State<_ColorField> {
  late final TextEditingController _text = TextEditingController(
    text: widget.value,
  );
  bool _invalid = false;

  @override
  void didUpdateWidget(_ColorField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && _text.text != widget.value) {
      _text.text = widget.value;
      _invalid = false;
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Color? get _swatch {
    final v = widget.value.trim();
    if (!isHexColor(v)) return null;
    var hex = v.substring(1);
    if (hex.length == 3) hex = hex.split('').map((c) => '$c$c').join();
    if (hex.length == 6) hex = 'ff$hex';
    if (hex.length == 8 && v.length == 9) {
      // #rrggbbaa → aarrggbb
      hex = hex.substring(6) + hex.substring(0, 6);
    }
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final swatch = _swatch;

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing0,
            children: <Widget>[
              AstryxText(
                widget.label,
                type: AstryxTextType.label,
                color: widget.edited
                    ? AstryxTextColor.accent
                    : AstryxTextColor.primary,
              ),
              if (widget.hint != null)
                AstryxText(
                  widget.hint!,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
            ],
          ),
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: swatch,
            borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
            border: Border.all(color: theme.color(AstryxColorToken.border)),
          ),
        ),
        SizedBox(
          width: 132,
          child: AstryxTextInput(
            label: widget.label,
            labelHidden: true,
            controller: _text,
            size: AstryxInputSize.sm,
            status: _invalid
                ? const AstryxFieldStatus.error(
                    'Use #rgb, #rrggbb or #rrggbbaa',
                  )
                : null,
            onChanged: (text) {
              final v = text.trim();
              final ok = isHexColor(v);
              setState(() => _invalid = !ok && v.isNotEmpty);
              if (ok) widget.onChanged(v);
              if (v.isEmpty) widget.onChanged(null);
            },
          ),
        ),
        AstryxIconButton(
          icon: AstryxIconName.close,
          label: 'Reset ${widget.label}',
          tooltip: 'Reset',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          enabled: widget.edited,
          onPressed: () => widget.onChanged(null),
        ),
      ],
    );
  }
}

/// A font family: a few suggestions, or free text.
class _FontField extends StatelessWidget {
  const _FontField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  static const List<String> _suggestions = <String>[
    'Inter',
    'DM Sans',
    'Figtree',
    'Outfit',
    'Poppins',
    'Montserrat',
    'Fraunces',
    'Playwrite US Trad',
    'JetBrains Mono',
  ];

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => AstryxSelector<String>(
    label: label,
    size: AstryxInputSize.sm,
    value: value,
    placeholder: 'Inherit from base',
    showClear: true,
    onChanged: onChanged,
    options: <AstryxSelectorEntry<String>>[
      for (final family in _suggestions)
        AstryxSelectorOption<String>(value: family, label: family),
    ],
  );
}
