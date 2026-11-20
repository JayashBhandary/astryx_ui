/// The web half of `download.dart`.
// JS property setters on an element; there is nothing to read back.
// ignore_for_file: avoid_setters_without_getters
library;

import 'dart:js_interop';

@JS('document.createElement')
external _Anchor _createElement(JSString tag);

extension type _Anchor(JSObject _) implements JSObject {
  external set href(JSString value);
  external set download(JSString value);
  external void click();
}

/// Starts a download of [contents] as [fileName].
void downloadTextFile(String fileName, String contents) {
  _createElement('a'.toJS)
    ..href =
        'data:text/plain;charset=utf-8,${Uri.encodeComponent(contents)}'.toJS
    ..download = fileName.toJS
    ..click();
}
