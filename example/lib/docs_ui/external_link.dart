/// Opens a link that leaves the site, where the platform has an answer.
///
/// The pages link outwards — to the repository, to the issue tracker, to the
/// upstream page each one ports. Until this existed those links were painted,
/// underlined and inert, which is worse than plain text: it looks like the
/// click failed.
///
/// The web half uses `dart:js_interop`, which only exists there, so the import
/// is conditional in the same shape as `url_strategy.dart`. Off the web there
/// is nothing to do that would not be a guess.
library;

export 'external_link_stub.dart'
    if (dart.library.js_interop) 'external_link_web.dart';
