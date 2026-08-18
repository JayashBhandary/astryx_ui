/// The strings Astryx widgets need, and their delegate.
library;

import 'package:flutter/widgets.dart';

/// The user-facing strings the Tier-1 widget set needs.
///
/// Transcribed from upstream's `packages/core/locales/en.json`, keeping the
/// same wording and the same distinctions — `banner.dismiss` ("Dismiss") is
/// deliberately separate from `toast.dismiss` ("Dismiss notification"), because
/// the two translate differently in some languages.
///
/// English only for 1.0. What matters now is the delegate structure: adding a
/// locale later is then additive rather than breaking. Subclass and override
/// to translate, or to reword for a product's voice.
///
/// {@tool snippet}
/// ```dart
/// class FrLocalizations extends AstryxLocalizations {
///   const FrLocalizations();
///
///   @override
///   String get dialogClose => 'Fermer';
/// }
/// ```
/// {@end-tool}
@immutable
class AstryxLocalizations {
  /// Creates the default English strings.
  const AstryxLocalizations();

  /// The strings from the nearest enclosing [AstryxLocalizationsScope].
  ///
  /// Falls back to the English defaults, so a widget always has a string to
  /// show — a missing localisation should never be an exception in front of a
  /// user.
  // ignore: prefer_constructors_over_static_methods
  static AstryxLocalizations of(BuildContext context) =>
      AstryxLocalizationsScope.maybeOf(context) ?? const AstryxLocalizations();

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Closes a dialog. Label and tooltip on the dialog's close button.
  String get dialogClose => 'Close';

  /// Closes a popover. Screen-reader label on its close button.
  String get popoverClose => 'Close popover';

  /// Declines the action an alert dialog is asking about.
  ///
  /// Deliberately not [dialogClose]: closing a dialog and declining a
  /// consequential action are the same gesture but not the same sentence, and
  /// they translate differently.
  String get alertDialogCancel => 'Cancel';

  /// Dismisses a banner. Label and tooltip on its close button.
  ///
  /// Distinct from [toastDismiss]: a banner is persistent, a toast transient.
  String get bannerDismiss => 'Dismiss';

  /// Expands a collapsed banner.
  String get bannerExpand => 'Expand';

  /// Collapses an expanded banner.
  String get bannerCollapse => 'Collapse';

  /// Dismisses a toast. Screen-reader label on its close button.
  String get toastDismiss => 'Dismiss notification';

  /// Closes one tab. Screen-reader label on a closable tab's close button.
  ///
  /// Named, because a strip of open files is a row of identical "Close"
  /// buttons otherwise.
  String tabClose(String label) => 'Close $label';

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  /// Announced while a button's action is in flight.
  String get buttonLoading => 'Loading';

  /// The accessible name of the region hosting the toast stack.
  String get toastViewport => 'Notifications';

  // ---------------------------------------------------------------------------
  // Forms
  // ---------------------------------------------------------------------------

  /// Marks a field that must be filled in. Shown inline after the label.
  String get fieldRequired => 'Required';

  /// Marks a field that need not be filled in. Shown inline after the label.
  String get fieldOptional => 'Optional';

  /// The last-ditch accessible name for an unlabelled checkbox in a list.
  String get checkboxFallbackLabel => 'Checkbox';

  /// The placeholder on an empty selector.
  String get selectorPlaceholder => 'Select…';

  /// The placeholder in a selector's option search field.
  String get selectorSearchPlaceholder => 'Search…';

  /// The accessible name of a selector's option search field.
  String get selectorSearchOptions => 'Search options';

  /// Clears the value of the field named [label].
  ///
  /// Used by both text inputs and selectors, which share the wording upstream.
  String clearField(String label) => 'Clear $label';

  /// Announces how many characters remain before a length limit.
  String charactersRemaining(int count) =>
      '$count ${count == 1 ? 'character' : 'characters'} remaining';

  /// Announces how far past a length limit the value has gone.
  String charactersOverLimit(int count) =>
      '$count ${count == 1 ? 'character' : 'characters'} over the limit';

  /// Summarises how many options a multiple selector is holding.
  String multiSelectorSelected(int count) => '$count selected';

  /// The tail of a token list too long for the trigger.
  String multiSelectorMore(int count) => '+$count more';

  /// The row that ticks or unticks every option.
  String get multiSelectorSelectAll => 'Select all';

  /// Shown when a search matches no option.
  String get selectorNoResults => 'No matches';

  /// Names the increment stepper on the field named [label].
  String numberInputIncrement(String label) =>
      label.isEmpty ? 'Increase' : 'Increase $label';

  /// Names the decrement stepper on the field named [label].
  String numberInputDecrement(String label) =>
      label.isEmpty ? 'Decrease' : 'Decrease $label';

  /// Announces that a typed number was refused and the old value put back.
  ///
  /// A number field reverts silently on blur, which leaves a screen-reader user
  /// with no idea their entry was thrown away — WCAG 3.3.1.
  String numberInputRejected(String input) => '$input is not accepted here';

  /// The prompt on an empty single-file field.
  String get fileInputChooseFile => 'Choose file';

  /// The prompt on an empty multiple-file field.
  String get fileInputChooseFiles => 'Choose files';

  /// Summarises a selection of more than one file.
  String fileInputSelected(int count) => '$count files selected';

  /// Removes every file chosen in the field named [label].
  String fileInputClear(String label) =>
      label.isEmpty ? 'Remove files' : 'Remove the files chosen for $label';

  /// Rejects [name] for not being one of the accepted types.
  String fileInputWrongType(String name) =>
      '"$name" is not an accepted file type';

  /// Rejects [name] for being larger than [limit], already formatted.
  String fileInputTooLarge(String name, String limit) =>
      '"$name" exceeds the $limit limit';

  /// Rejects a selection of more than [limit] files.
  String fileInputTooMany(int limit) => 'Maximum $limit files allowed';

  // ---------------------------------------------------------------------------
  // Date and time
  //
  // The package has no `intl` dependency, so the month and weekday names live
  // here — which also makes them the seam a product overrides to reword or
  // translate them, the same as every other string.
  // ---------------------------------------------------------------------------

  /// The months, January first.
  ///
  /// Twelve entries, in calendar order. A calendar's heading and every day
  /// cell's accessible name read from this list.
  List<String> get monthNames => const <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// The months abbreviated, January first. Twelve entries.
  List<String> get monthNamesShort => const <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// The days of the week, **Monday first** — ISO order, so index `n` is
  /// `DateTime.weekday == n + 1`.
  ///
  /// Monday-first regardless of which day a calendar starts its week on: the
  /// list is indexed by [DateTime.weekday], and the calendar rotates it.
  List<String> get weekdayNames => const <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// The days of the week abbreviated, Monday first. Seven entries.
  ///
  /// The column headings of a month grid, where there is room for three
  /// characters and not for nine.
  List<String> get weekdayNamesShort => const <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  /// The morning half of a twelve-hour clock.
  ///
  /// Also read when parsing, so a field accepts what it prints.
  String get timeAnteMeridiem => 'am';

  /// The afternoon half of a twelve-hour clock.
  String get timePostMeridiem => 'pm';

  /// The fallback accessible name for a calendar.
  String get calendarLabel => 'Calendar';

  /// Moves a calendar back one month.
  String get calendarPreviousMonth => 'Previous month';

  /// Moves a calendar forward one month.
  String get calendarNextMonth => 'Next month';

  /// Said after today's date in a calendar.
  ///
  /// Today is marked with a ring, which a screen-reader user cannot see — so
  /// the word goes in the cell's name as well.
  String get calendarToday => 'today';

  /// Said after the first day of a range being picked.
  String get calendarRangeStart => 'start of the range';

  /// Said after the last day of a range being picked.
  String get calendarRangeEnd => 'end of the range';

  /// Opens the calendar attached to the field named [label].
  String dateInputOpenCalendar(String label) =>
      label.isEmpty ? 'Choose a date' : 'Choose a date for $label';

  /// Announces that a typed date was refused and the old value put back.
  ///
  /// The counterpart of [numberInputRejected]: reverting silently leaves a
  /// screen-reader user with no idea their entry was thrown away — WCAG 3.3.1.
  String dateInputRejected(String input) => '$input is not a date';

  /// Announces that a typed time was refused and the old value put back.
  String timeInputRejected(String input) => '$input is not a time';

  /// The accessible name of a range's first field.
  String get dateRangeStartLabel => 'Start date';

  /// The accessible name of a range's second field.
  String get dateRangeEndLabel => 'End date';

  /// Rejects a range whose end falls before its start.
  String get dateRangeInvalid => 'The end date is before the start date';

  /// The accessible name of the date half of a date-and-time field.
  String get dateTimeInputDateLabel => 'Date';

  /// The accessible name of the time half of a date-and-time field.
  String get dateTimeInputTimeLabel => 'Time';

  /// A moment ago, in either direction.
  String get timestampJustNow => 'just now';

  /// [count] minutes in the past.
  String timestampMinutesAgo(int count) =>
      '$count ${count == 1 ? 'minute' : 'minutes'} ago';

  /// [count] hours in the past.
  String timestampHoursAgo(int count) =>
      '$count ${count == 1 ? 'hour' : 'hours'} ago';

  /// [count] days in the past.
  String timestampDaysAgo(int count) =>
      '$count ${count == 1 ? 'day' : 'days'} ago';

  /// [count] minutes from now.
  String timestampInMinutes(int count) =>
      'in $count ${count == 1 ? 'minute' : 'minutes'}';

  /// [count] hours from now.
  String timestampInHours(int count) =>
      'in $count ${count == 1 ? 'hour' : 'hours'}';

  /// [count] days from now.
  String timestampInDays(int count) =>
      'in $count ${count == 1 ? 'day' : 'days'}';

  // ---------------------------------------------------------------------------
  // Chat
  // ---------------------------------------------------------------------------

  /// The fallback accessible name for a conversation transcript.
  String get chatTranscript => 'Conversation';

  /// The accessible name of the composer's field.
  String get chatComposerLabel => 'Message';

  /// The placeholder in an empty composer.
  String get chatComposerPlaceholder => 'Send a message…';

  /// Sends the draft. Label and tooltip on the composer's send control.
  String get chatSend => 'Send';

  /// Stops a reply that is being generated.
  ///
  /// The same control as [chatSend], which is why the two are separate strings:
  /// a button whose meaning changes needs a name that changes with it.
  String get chatStop => 'Stop generating';

  /// Returns the transcript to the newest turn.
  String get chatScrollToLatest => 'Jump to latest';

  /// The fallback accessible name for a turn from the person using the app.
  String get chatFromUser => 'You';

  /// The fallback accessible name for a turn from the assistant.
  String get chatFromAssistant => 'Assistant';

  /// Names a turn that came from neither participant.
  String get chatSystemMessage => 'System message';

  /// Begins speech-to-text.
  String get chatDictationStart => 'Dictate';

  /// Ends speech-to-text.
  ///
  /// Separate from [chatDictationStart]: the control is the same button, and a
  /// button whose meaning changes needs a name that changes with it.
  String get chatDictationStop => 'Stop dictating';

  /// Removes the token named [label].
  ///
  /// Named for what it removes: a row of five buttons all called "Remove" is a
  /// row a screen-reader user cannot choose from.
  String tokenRemove(String label) => 'Remove $label';

  /// The fallback accessible name for a tokenizing field.
  String get tokenizerLabel => 'Values';

  /// The placeholder in an empty tokenizing field.
  String get tokenizerPlaceholder => 'Type and press Enter…';

  /// Summarises how many values a tokenizing field holds.
  String tokenizerValue(int count) =>
      '$count ${count == 1 ? 'value' : 'values'}';

  /// Names a citation marker that has no source to name.
  String citationLabel(int number) => 'Source $number';

  /// Names a citation marker and what it points at.
  String citationLabelled(int number, String source) =>
      'Source $number: $source';

  /// The fallback accessible name for a run of tool calls.
  String get toolCallsLabel => 'Tool calls';

  /// A tool call that has not finished.
  String get toolCallRunning => 'Running';

  /// A tool call that finished.
  String get toolCallSucceeded => 'Finished';

  /// A tool call that failed.
  String get toolCallFailed => 'Failed';

  /// A tool call that was never started.
  String get toolCallPending => 'Pending';

  // ---------------------------------------------------------------------------
  // Command and search
  // ---------------------------------------------------------------------------

  /// The fallback accessible name for a typeahead's suggestion list.
  String get typeaheadLabel => 'Suggestions';

  /// The placeholder in an empty typeahead.
  String get typeaheadPlaceholder => 'Search…';

  /// Announced while a search is in flight.
  String get typeaheadSearching => 'Searching';

  /// Announces how many suggestions a search returned.
  ///
  /// A dropdown appearing is silent to a screen reader, so the count is said
  /// instead — otherwise there is no way to know a search answered at all.
  String typeaheadResults(int count) =>
      '$count ${count == 1 ? 'result' : 'results'}';

  /// The fallback accessible name for a command palette.
  String get commandPaletteLabel => 'Commands';

  /// The placeholder in an empty command palette.
  String get commandPalettePlaceholder => 'Type a command or search…';

  /// Shown when a palette query matches no command.
  String get commandPaletteNoResults => 'No commands match';

  /// The hint on a palette's footer: how to move.
  String get commandPaletteNavigate => 'to navigate';

  /// The hint on a palette's footer: how to run.
  String get commandPaletteRun => 'to run';

  /// The hint on a palette's footer: how to leave.
  String get commandPaletteClose => 'to close';

  /// The fallback accessible name for a power search field.
  String get powerSearchLabel => 'Search';

  /// The placeholder in an empty power search field.
  String get powerSearchPlaceholder => 'Search, or add a filter…';

  /// Opens the menu of filters that can be added.
  String get powerSearchAddFilter => 'Add a filter';

  /// Removes every filter and the query.
  String get powerSearchClear => 'Clear the search';

  /// Summarises how many filters are applied.
  String powerSearchFilters(int count) =>
      '$count ${count == 1 ? 'filter' : 'filters'}';

  // ---------------------------------------------------------------------------
  // Media
  // ---------------------------------------------------------------------------

  /// Names the avatars an overflow chip stands for.
  ///
  /// Deliberately not [overflowMore]: that one names items that did not fit in
  /// a row, this one names *people*, and the two are not the same sentence in
  /// every language.
  String avatarGroupMore(int count) => '$count more';

  /// Announces how many people an avatar group holds.
  String avatarGroupCount(int count) =>
      '$count ${count == 1 ? 'person' : 'people'}';

  /// Moves a carousel back one slide.
  String get carouselPrevious => 'Previous';

  /// Moves a carousel on one slide.
  String get carouselNext => 'Next';

  /// Says where in a carousel the reader is.
  String carouselPosition(int index, int count) => 'Item $index of $count';

  /// The fallback accessible name for a carousel.
  String get carouselLabel => 'Carousel';

  /// The fallback accessible name for a lightbox.
  String get lightboxLabel => 'Media viewer';

  /// Closes a lightbox.
  String get lightboxClose => 'Close the viewer';

  /// Moves a lightbox back one item.
  String get lightboxPrevious => 'Previous item';

  /// Moves a lightbox on one item.
  String get lightboxNext => 'Next item';

  /// Says where in a lightbox the reader is.
  String lightboxPosition(int index, int count) => '$index of $count';

  // ---------------------------------------------------------------------------
  // Text selection
  //
  // Astryx builds its own selection toolbar rather than Material's, so these
  // are the strings the framework would otherwise take from
  // `MaterialLocalizations`. See `AstryxTextSelectionToolbar`.
  // ---------------------------------------------------------------------------

  /// Removes the selection and puts it on the clipboard.
  String get textCut => 'Cut';

  /// Copies the selection to the clipboard.
  String get textCopy => 'Copy';

  /// Inserts the clipboard contents.
  String get textPaste => 'Paste';

  /// Selects the whole value.
  String get textSelectAll => 'Select all';

  /// Removes the selection without copying it.
  String get textDelete => 'Delete';

  /// Looks the selection up in the platform's dictionary. iOS only.
  String get textLookUp => 'Look Up';

  /// Searches the web for the selection. iOS only.
  String get textSearchWeb => 'Search Web';

  /// Opens the platform share sheet with the selection.
  String get textShare => 'Share';

  /// Captures text from the camera. iOS only.
  String get textLiveTextInput => 'Live Text';

  // ---------------------------------------------------------------------------
  // Tabs and tables
  // ---------------------------------------------------------------------------

  /// The fallback accessible name for a tab bar.
  String get tabListLabel => 'Tabs';

  /// The fallback accessible name for a table.
  String get tableLabel => 'Table';

  /// The empty state shown when a table has no rows.
  String get tableNoData => 'No data';

  /// Sorts the column ascending.
  String get tableSortAscending => 'Sort ascending';

  /// Sorts the column descending.
  String get tableSortDescending => 'Sort descending';

  /// Removes the current sort.
  String get tableSortClear => 'Clear sort';

  /// Sorts by the column named [label].
  String tableSortBy(String label) => 'Sort by $label';

  /// Selects an unnamed table row.
  String get tableSelectRow => 'Select row';

  /// Selects the row identified by [label].
  String tableSelectRowNamed(String label) => 'Select $label';

  /// Selects every row in the table.
  String get tableSelectAllRows => 'Select all rows';

  // ---------------------------------------------------------------------------
  // Lists
  // ---------------------------------------------------------------------------

  /// Opens the menu holding the [count] items an overflow list could not fit.
  ///
  /// Deliberately not `multiSelectorMore`: that one names *chosen* options that
  /// are not shown, this one names items that did not fit, and the two are not
  /// the same sentence in every language.
  String overflowMore(int count) => '+$count more';

  /// The fallback accessible name for an overflow list's menu.
  String get overflowMenuLabel => 'More items';

  // ---------------------------------------------------------------------------
  // Code
  // ---------------------------------------------------------------------------

  /// Copies a code block to the clipboard.
  ///
  /// Separate from [textCopy], which is the selection menu's own verb: this
  /// one names the whole block, not whatever happens to be selected.
  String get codeCopy => 'Copy code';

  /// Confirms that a code block was copied.
  String get codeCopied => 'Copied';

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// The fallback accessible name for a navigation.
  String get navLabel => 'Navigation';

  /// Narrows the navigation rail to its icons.
  String get navCollapse => 'Collapse the navigation';

  /// Restores the labels to a collapsed rail.
  String get navExpand => 'Expand the navigation';

  /// Opens the navigation drawer. Label on the toggle a narrow window gets.
  String get navOpen => 'Open the navigation';

  /// The disclosure title an `AstryxLayout` panel gets when it is too narrow
  /// to sit beside the body.
  ///
  /// A generic word, because the slot is generic — filters, an outline, the
  /// details of a selection all live in it. Name it with `panelLabel` and this
  /// is never read.
  String get layoutPanelLabel => 'Details';

  /// The fallback accessible name for a breadcrumb trail.
  String get breadcrumbsLabel => 'Breadcrumbs';

  /// Opens the menu holding the [count] steps a trail could not fit.
  ///
  /// A count rather than a bare ellipsis: "show 3 more" says what pressing it
  /// will do, and "…" does not.
  String breadcrumbsMore(int count) =>
      count == 1 ? 'Show 1 hidden step' : 'Show $count hidden steps';

  /// Said after a link that leaves the application.
  ///
  /// In the name rather than only in the glyph: a user who cannot see the
  /// glyph is the one most disrupted by a window they did not expect.
  String get linkExternal => 'opens in a new window';

  /// The fallback accessible name for a toolbar.
  String get toolbarLabel => 'Toolbar';

  /// The fallback accessible name for an overflow menu.
  String get moreMenuLabel => 'More actions';

  /// The fallback accessible name for a pagination control.
  String get paginationLabel => 'Pagination';

  /// Goes back one page.
  String get paginationPrevious => 'Previous page';

  /// Goes forward one page.
  String get paginationNext => 'Next page';

  /// Goes to page [page] of [count].
  String paginationPage(int page, int count) => 'Page $page of $count';
}

/// Makes an [AstryxLocalizations] available to the widgets beneath it.
///
/// Installed by `AstryxThemeProvider`. Use it directly only to override the
/// strings for one subtree.
class AstryxLocalizationsScope extends InheritedWidget {
  /// Creates a localisations scope.
  const AstryxLocalizationsScope({
    required this.localizations,
    required super.child,
    super.key,
  });

  /// The strings for this subtree.
  final AstryxLocalizations localizations;

  /// The strings from the nearest enclosing scope, or null if there is none.
  static AstryxLocalizations? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AstryxLocalizationsScope>()
      ?.localizations;

  @override
  bool updateShouldNotify(AstryxLocalizationsScope oldWidget) =>
      localizations != oldWidget.localizations;
}
