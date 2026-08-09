import 'package:example/gallery/demo.dart';
import 'package:example/gallery/gallery_controller.dart';
import 'package:example/gallery/gallery_scope.dart';
import 'package:flutter/material.dart';

/// The gallery chrome: navigation on the left, the selected demo on the right,
/// and the theme / brightness / density / direction pickers in the app bar.
///
/// Deliberately Material. This is the app around the design system, not part of
/// it — see the note in `analysis_options.yaml`.
class GalleryShell extends StatefulWidget {
  const GalleryShell({super.key});

  @override
  State<GalleryShell> createState() => _GalleryShellState();
}

class _GalleryShellState extends State<GalleryShell> {
  String _selectedId = galleryDemos.first.id;

  GalleryDemo get _selected =>
      galleryDemos.firstWhere((demo) => demo.id == _selectedId);

  @override
  Widget build(BuildContext context) {
    final gallery = GalleryScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_selected.title),
        actions: [
          _Picker<GalleryTheme>(
            tooltip: 'Theme',
            icon: Icons.palette_outlined,
            values: GalleryTheme.values,
            selected: gallery.theme,
            labelOf: (value) => value.label,
            onSelected: (value) => gallery.theme = value,
          ),
          _Picker<GalleryBrightness>(
            tooltip: 'Brightness',
            icon: Icons.brightness_6_outlined,
            values: GalleryBrightness.values,
            selected: gallery.brightness,
            labelOf: (value) => value.label,
            onSelected: (value) => gallery.brightness = value,
          ),
          _Picker<GalleryDensity>(
            tooltip: 'Density',
            icon: Icons.straighten_outlined,
            values: GalleryDensity.values,
            selected: gallery.density,
            labelOf: (value) => value.label,
            onSelected: (value) => gallery.density = value,
          ),
          _Picker<TextDirection>(
            tooltip: 'Direction',
            icon: Icons.swap_horiz_outlined,
            values: TextDirection.values,
            selected: gallery.textDirection,
            labelOf: (value) => value.name.toUpperCase(),
            onSelected: (value) => gallery.textDirection = value,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          _NavigationPane(
            selectedId: _selectedId,
            onSelected: (id) => setState(() => _selectedId = id),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Directionality(
              textDirection: gallery.textDirection,
              child: Builder(builder: _selected.builder),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationPane extends StatelessWidget {
  const _NavigationPane({required this.selectedId, required this.onSelected});

  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final groups = galleryDemosByGroup;

    return SizedBox(
      width: 240,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (final entry in groups.entries) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                entry.key.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            for (final demo in entry.value)
              ListTile(
                title: Text(demo.title),
                selected: demo.id == selectedId,
                dense: true,
                onTap: () => onSelected(demo.id),
              ),
          ],
        ],
      ),
    );
  }
}

class _Picker<T> extends StatelessWidget {
  const _Picker({
    required this.tooltip,
    required this.icon,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final String tooltip;
  final IconData icon;
  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: '$tooltip: ${labelOf(selected)}',
      icon: Icon(icon),
      initialValue: selected,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final value in values)
          PopupMenuItem<T>(value: value, child: Text(labelOf(value))),
      ],
    );
  }
}
