/// Installs the web URL strategy, where there is one.
///
/// Flutter's default web strategy puts the route in the fragment — `/#/tokens`.
/// The path strategy gives `/tokens`, which is what a documentation URL should
/// look like. It needs `package:flutter_web_plugins`, which only exists on the
/// web, so the import is conditional and this file is the stub every other
/// platform gets.
///
/// The web build needs a server that serves `index.html` for any path. Firebase
/// Hosting does it through the `**` rewrite in `firebase.json`; `flutter run`
/// and `flutter build web`'s own dev server do it by default.
library;

export 'url_strategy_stub.dart'
    if (dart.library.js_interop) 'url_strategy_web.dart';
