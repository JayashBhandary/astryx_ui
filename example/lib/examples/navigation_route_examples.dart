import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example page_route_demo -> PageRouteDemoExample
class PageRouteDemoExample extends StatefulWidget {
  const PageRouteDemoExample({super.key});

  @override
  State<PageRouteDemoExample> createState() => _PageRouteDemoExampleState();
}

class _PageRouteDemoExampleState extends State<PageRouteDemoExample> {
  AstryxPageTransition _transition = AstryxPageTransition.fade;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxRadioList<AstryxPageTransition>(
          label: 'Transition',
          orientation: AstryxRadioListOrientation.horizontal,
          value: _transition,
          onChanged: (value) => setState(() => _transition = value),
          options: <AstryxRadioOption<AstryxPageTransition>>[
            for (final transition in AstryxPageTransition.values)
              AstryxRadioOption(value: transition, label: transition.name),
          ],
        ),
        // A navigator of its own, so the demo pages move inside the frame.
        // In an app, `AstryxApp` builds every route as an AstryxPageRoute.
        SizedBox(
          width: 360,
          height: 200,
          child: ClipRect(
            child: AstryxPageTransitionScope(
              transition: _transition,
              child: Navigator(
                key: ValueKey<AstryxPageTransition>(_transition),
                onGenerateRoute: (settings) => AstryxPageRoute<void>(
                  settings: settings,
                  builder: (_) => const _DemoPage(depth: 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DemoPage extends StatelessWidget {
  const _DemoPage({required this.depth});

  final int depth;

  @override
  Widget build(BuildContext context) {
    return AstryxCenter(
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.center,
        children: <Widget>[
          AstryxHeading('Page $depth'),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              if (depth > 1)
                AstryxButton(
                  label: 'Back',
                  onPressed: () => Navigator.pop(context),
                ),
              AstryxButton(
                label: 'Open page ${depth + 1}',
                variant: AstryxButtonVariant.primary,
                onPressed: () => Navigator.push(
                  context,
                  AstryxPageRoute<void>(
                    builder: (_) => _DemoPage(depth: depth + 1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// #end

// #example theme_animation -> ThemeAnimationExample
class ThemeAnimationExample extends StatefulWidget {
  const ThemeAnimationExample({super.key});

  @override
  State<ThemeAnimationExample> createState() => _ThemeAnimationExampleState();
}

class _ThemeAnimationExampleState extends State<ThemeAnimationExample> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // In an app, flipping `AstryxApp(mode:)` cross-fades the same way: the
    // provider installs an AstryxAnimatedTheme. This one animates a subtree.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxSwitch(
          label: 'Dark preview',
          value: _dark,
          onChanged: (value) => setState(() => _dark = value),
        ),
        AstryxAnimatedTheme(
          data: theme.copyWith(
            mode: _dark ? AstryxThemeMode.dark : AstryxThemeMode.light,
          ),
          duration: theme.duration(AstryxDurationToken.medium),
          curve: theme.ease(),
          child: const SizedBox(
            width: 320,
            child: AstryxCard(
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  AstryxHeading('Atlas'),
                  AstryxText('4,102 requests this week.'),
                  AstryxBadge('Healthy'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// #end
