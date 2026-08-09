// Compiles every code sample from the README, so a rename cannot rot the docs.
import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(accent: '#0F62FE'),
  ),
);

Widget app() => const AstryxApp(title: 'My internal tool', home: HomePage());

Widget themed() => AstryxThemeProvider(
  theme: matchaTheme,
  child: const HomePage(),
);

Widget dense() => const AstryxThemeProvider(
  density: AstryxDensity.touch,
  child: HomePage(),
);

void tokens(BuildContext context) {
  final theme = AstryxTheme.of(context);
  theme.color(AstryxColorToken.accent);
  theme.spacing(AstryxSpacingToken.spacing3);
}
