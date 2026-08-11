/// The non-web half of the conditional import in `external_link.dart`.
library;

/// Does nothing: opening a URL off the web needs a plugin this app does not
/// depend on, and guessing would be worse than declining.
void openExternalLink(Uri uri, {String? target}) {}
