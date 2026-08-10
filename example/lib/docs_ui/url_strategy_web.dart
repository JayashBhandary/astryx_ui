/// The web half of the conditional import in `url_strategy.dart`.
library;

import 'package:flutter_web_plugins/url_strategy.dart';

/// Puts the route in the path — `/tokens` — rather than the fragment.
void useDocsUrlStrategy() => usePathUrlStrategy();
