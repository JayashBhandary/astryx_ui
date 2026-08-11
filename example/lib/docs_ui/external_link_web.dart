/// The web half of the conditional import in `external_link.dart`.
library;

import 'dart:js_interop';

@JS('window.open')
external JSAny? _windowOpen(JSString url, JSString target);

/// Opens [uri] in [target], which defaults to a new tab.
///
/// A new tab rather than the current one: the reader is in the middle of a
/// page, and a link to the upstream component or the issue tracker is a
/// sideways step, not a departure.
void openExternalLink(Uri uri, {String? target}) =>
    _windowOpen(uri.toString().toJS, (target ?? '_blank').toJS);
