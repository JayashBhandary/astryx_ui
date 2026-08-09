/// A full-width inline message.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

/// A banner's sentiment.
///
/// Each maps to one of the muted status fills — `--color-accent-muted` and
/// friends. Muted, not solid: a banner occupies real estate for as long as it
/// is relevant, and a saturated fill at that size is shouting.
enum AstryxBannerStatus {
  /// Neutral information.
  info(
    AstryxColorToken.accentMuted,
    AstryxIconName.info,
    AstryxIconColor.accent,
    Assertiveness.polite,
  ),

  /// Worth attention, not blocking.
  warning(
    AstryxColorToken.warningMuted,
    AstryxIconName.warning,
    AstryxIconColor.warning,
    Assertiveness.polite,
  ),

  /// Something is wrong.
  error(
    AstryxColorToken.errorMuted,
    AstryxIconName.error,
    AstryxIconColor.error,
    Assertiveness.assertive,
  ),

  /// Confirmation.
  success(
    AstryxColorToken.successMuted,
    AstryxIconName.success,
    AstryxIconColor.success,
    Assertiveness.polite,
  );

  const AstryxBannerStatus(
    this.background,
    this.icon,
    this.iconColor,
    this.assertiveness,
  );

  /// The muted fill.
  final AstryxColorToken background;

  /// The default icon.
  final AstryxIconName icon;

  /// The icon's colour role.
  final AstryxIconColor iconColor;

  /// How urgently a screen reader should interrupt.
  ///
  /// Only an error interrupts. A success banner that talks over what the user
  /// is doing has turned good news into an obstacle.
  final Assertiveness assertiveness;
}

/// A full-width message about the view it sits in.
///
/// **Announced when it appears.** A banner that shows up after a failed save is
/// invisible to a screen-reader user unless something says so; this one is a
/// live region, and it announces on *appearance and change* rather than on
/// every rebuild.
///
/// {@tool snippet}
/// ```dart
/// AstryxBanner(
///   status: AstryxBannerStatus.error,
///   title: 'Could not save',
///   description: 'The server rejected three of the fields.',
///   actions: <Widget>[AstryxButton(label: 'Retry', onPressed: _retry)],
///   onDismiss: () => setState(() => _showBanner = false),
/// )
/// ```
/// {@end-tool}
///
/// For a transient message use `AstryxToast`; a banner stays until the
/// condition it describes goes away.
class AstryxBanner extends StatefulWidget {
  /// Creates a banner.
  const AstryxBanner({
    required this.title,
    super.key,
    this.status = AstryxBannerStatus.info,
    this.description,
    this.actions = const <Widget>[],
    this.onDismiss,
    this.icon,
    this.showIcon = true,
    this.content,
    this.announce = true,
  });

  /// The headline. Short and specific.
  final String title;

  /// The sentiment.
  final AstryxBannerStatus status;

  /// Supporting text below the title.
  final String? description;

  /// Buttons at the trailing edge of the header.
  final List<Widget> actions;

  /// Shows a dismiss button that calls this.
  ///
  /// Null means the banner cannot be dismissed — correct for a condition the
  /// user has to resolve rather than acknowledge.
  final VoidCallback? onDismiss;

  /// Overrides the status's default icon.
  ///
  /// Any widget; size and colour come from the enclosing `IconTheme`. Null
  /// uses the icon that goes with [status], which is what a banner almost
  /// always wants (ADR-043).
  final Widget? icon;

  /// Whether to show an icon at all.
  final bool showIcon;

  /// Extra content below the header, on a card background.
  ///
  /// For a banner that needs to show detail — a list of what failed — without
  /// pushing it into the coloured area, where the contrast tokens are tuned
  /// for one line of text rather than a paragraph.
  final Widget? content;

  /// Whether to announce the banner when it appears or its text changes.
  ///
  /// Set false for a banner that is part of the page's initial state — a
  /// permanent notice at the top of a settings screen has nothing to announce.
  final bool announce;

  @override
  State<AstryxBanner> createState() => _AstryxBannerState();
}

class _AstryxBannerState extends State<AstryxBanner> {
  @override
  void initState() {
    super.initState();
    if (!widget.announce) return;
    // Deferred: `View.of` needs a mounted element, and an announcement on the
    // very first frame is exactly the case this exists for.
    WidgetsBinding.instance.addPostFrameCallback((_) => _announce());
  }

  @override
  void didUpdateWidget(AstryxBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.announce) return;
    if (widget.title == oldWidget.title &&
        widget.description == oldWidget.description &&
        widget.status == oldWidget.status) {
      return;
    }
    _announce();
  }

  void _announce() {
    if (!mounted) return;
    final message = widget.description == null
        ? widget.title
        : '${widget.title}. ${widget.description}';
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      Directionality.of(context),
      assertiveness: widget.status.assertiveness,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final radius = theme.borderRadius(AstryxRadiusToken.container);

    final hasContent = widget.content != null;

    // Only a title and some actions: everything centres on one line. With a
    // description the icon has to align to the first line of text instead.
    final centred = widget.description == null;

    final header = Container(
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing(AstryxSpacingToken.spacing3),
        horizontal: theme.spacing(AstryxSpacingToken.spacing4),
      ),
      decoration: BoxDecoration(
        color: theme.color(widget.status.background),
        borderRadius: hasContent
            ? BorderRadius.only(
                topLeft: radius.topLeft,
                topRight: radius.topRight,
              )
            : radius,
      ),
      child: Row(
        crossAxisAlignment: centred
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        spacing: theme.spacing(AstryxSpacingToken.spacing2),
        children: <Widget>[
          if (widget.showIcon)
            IconTheme.merge(
              data: IconThemeData(size: AstryxIconSize.sm.pixels),
              child:
                  widget.icon ??
                  AstryxIcon(
                    widget.status.icon,
                    size: AstryxIconSize.sm,
                    color: widget.status.iconColor,
                  ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AstryxText(widget.title, type: AstryxTextType.label),
                if (widget.description != null)
                  AstryxText(
                    widget.description!,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
              ],
            ),
          ),
          if (widget.actions.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: theme.spacing(AstryxSpacingToken.spacing2),
              children: widget.actions,
            ),
          if (widget.onDismiss != null)
            AstryxIconButton(
              icon: AstryxIconName.close,
              label: l10n.bannerDismiss,
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: widget.onDismiss,
            ),
        ],
      ),
    );

    final banner = hasContent
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              header,
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.backgroundCard),
                  borderRadius: BorderRadius.only(
                    bottomLeft: radius.bottomLeft,
                    bottomRight: radius.bottomRight,
                  ),
                  border: Border(
                    left: BorderSide(
                      color: theme.color(AstryxColorToken.border),
                      width: theme.borderWidth(),
                    ),
                    right: BorderSide(
                      color: theme.color(AstryxColorToken.border),
                      width: theme.borderWidth(),
                    ),
                    bottom: BorderSide(
                      color: theme.color(AstryxColorToken.border),
                      width: theme.borderWidth(),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: theme.spacing(AstryxSpacingToken.spacing3),
                    horizontal: theme.spacing(AstryxSpacingToken.spacing4),
                  ),
                  child: widget.content,
                ),
              ),
            ],
          )
        : header;

    return Semantics(
      container: true,
      // A live region *and* an explicit announcement. The region covers a
      // screen reader that watches for changes; the announcement covers one
      // that does not, and neither alone is reliable across platforms.
      liveRegion: widget.announce,
      explicitChildNodes: true,
      child: banner,
    );
  }
}
