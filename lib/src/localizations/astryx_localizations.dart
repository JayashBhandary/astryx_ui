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
