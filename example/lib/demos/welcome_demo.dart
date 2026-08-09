import 'package:example/gallery/gallery_scope.dart';
import 'package:flutter/material.dart';

/// Landing page. Replaced by a real overview once components exist.
abstract final class WelcomeDemo {
  static Widget build(BuildContext context) => const _WelcomeDemo();
}

class _WelcomeDemo extends StatelessWidget {
  const _WelcomeDemo();

  @override
  Widget build(BuildContext context) {
    final gallery = GalleryScope.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Text('astryx_ui', style: textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'An unofficial Flutter port of Astryx 0.3.0, '
          "Meta's design system for internal tools.",
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        Text('Current selection', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        _Row(label: 'Theme', value: gallery.theme.label),
        _Row(label: 'Brightness', value: gallery.brightness.label),
        _Row(label: 'Density', value: gallery.density.label),
        _Row(
          label: 'Direction',
          value: gallery.textDirection.name.toUpperCase(),
        ),
        const SizedBox(height: 32),
        Text('Status', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        Text(
          'No components yet. The pickers above are wired to a '
          'GalleryController and will drive AstryxThemeProvider once the theme '
          'runtime lands in Phase 3.\n\n'
          'See dev/04-TRACKER.md for what is built and what is next.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
