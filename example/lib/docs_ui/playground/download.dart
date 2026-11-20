/// Saving a text file from the browser.
///
/// Conditional on `dart:js_interop`, like `external_link.dart`: off the web
/// there is no download to start, and the export still offers Copy.
library;

export 'download_stub.dart' if (dart.library.js_interop) 'download_web.dart';
