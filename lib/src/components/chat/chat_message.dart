/// One turn in a conversation, and the list that holds them.
library;

import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Who a turn came from.
enum AstryxChatRole {
  /// The person using the application.
  ///
  /// Drawn in a bubble, aligned to the reading end — the shape that says "you
  /// wrote this" without a label.
  user,

  /// The assistant, or whoever is being talked to.
  ///
  /// **Not** in a bubble: an answer is the content of the page, often long,
  /// often containing a code block or a list, and wrapping all of that in a
  /// rounded box makes it read as an aside rather than as the answer.
  assistant,

  /// Neither participant — a notice about the conversation itself.
  ///
  /// "The model changed", "This conversation was resumed". Centred, quiet, and
  /// never in a bubble, because it is not a turn anybody took.
  system,
}

/// One turn in a conversation.
///
/// A port of upstream's `ChatMessage`, `ChatMessageBubble` and
/// `ChatMessageMetadata` as one widget, because the three are never useful
/// apart: a bubble with no metadata has nothing to say about who wrote it, and
/// metadata with no bubble has nothing to attach to.
///
/// {@tool snippet}
/// ```dart
/// AstryxChatMessage(
///   role: AstryxChatRole.assistant,
///   author: 'Assistant',
///   timestamp: reply.at,
///   actions: <Widget>[copyButton, retryButton],
///   child: AstryxText(reply.text),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxChatMessageList`, which spaces a run of these.
///  * `AstryxStreamingText`, for an answer still arriving.
class AstryxChatMessage extends StatelessWidget {
  /// Creates a turn.
  const AstryxChatMessage({
    required this.child,
    super.key,
    this.role = AstryxChatRole.assistant,
    this.author,
    this.timestamp,
    this.leading,
    this.actions = const <Widget>[],
    this.footer,
    this.maxWidth,
    this.semanticsLabel,
  });

  /// The turn's content.
  ///
  /// Anything: text, a code block, a table, a card. An assistant's answer is
  /// page content, so it is not constrained to a sentence.
  final Widget child;

  /// Who it came from.
  final AstryxChatRole role;

  /// The name shown above the turn.
  ///
  /// Also the turn's accessible name, because "who said this" is the one thing
  /// a transcript cannot convey through layout to somebody who cannot see it.
  final String? author;

  /// Shown beside [author], as a relative time.
  final Widget? timestamp;

  /// A widget before the turn — an avatar, an icon.
  final Widget? leading;

  /// Controls for this turn — copy, retry, a rating.
  ///
  /// **Always visible.** Upstream reveals them on hover; this widget set does
  /// not, because touch has no hover and the density system suppresses hover
  /// styling there. A retry button nobody can reach on a phone is not a retry
  /// button.
  final List<Widget> actions;

  /// Content below the turn and its actions — sources, a tool call, a warning.
  final Widget? footer;

  /// How wide a [AstryxChatRole.user] bubble may get.
  ///
  /// Bubbles stop short of the full width so the alignment stays legible; an
  /// assistant turn is unconstrained, because it is the page.
  final double? maxWidth;

  /// Overrides what a screen reader announces for the whole turn.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);

    if (role == AstryxChatRole.system) {
      return Semantics(
        container: true,
        // Explicit, like the two real roles: without it the notice's own text
        // merges into this node, and "System message" stops being the name of
        // anything — it becomes the first half of one long string.
        explicitChildNodes: true,
        label: semanticsLabel ?? l10n.chatSystemMessage,
        child: Align(
          child: DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              align: AstryxStackAlign.center,
              children: <Widget>[
                DefaultTextStyle.merge(
                  style: TextStyle(
                    color: theme.color(AstryxColorToken.textSecondary),
                  ),
                  child: child,
                ),
                ?footer,
              ],
            ),
          ),
        ),
      );
    }

    final fromUser = role == AstryxChatRole.user;

    var content = child;
    if (fromUser) {
      content = Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 480),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: theme.spacing(AstryxSpacingToken.spacing4),
          vertical: theme.spacing(AstryxSpacingToken.spacing3),
        ),
        decoration: BoxDecoration(
          color: theme.color(AstryxColorToken.backgroundMuted),
          // `--radius-chat`, which exists for exactly this and nothing else.
          borderRadius: theme.borderRadius(AstryxRadiusToken.chat),
        ),
        child: child,
      );
    }

    final header = <Widget>[
      if (author != null)
        AstryxText(
          author!,
          type: AstryxTextType.label,
          color: AstryxTextColor.secondary,
        ),
      ?timestamp,
    ];

    final turn = AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: fromUser ? AstryxStackAlign.end : AstryxStackAlign.stretch,
      children: <Widget>[
        if (header.isNotEmpty)
          AstryxHStack(gap: AstryxSpacingToken.spacing2, children: header),
        content,
        if (actions.isNotEmpty)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing1,
            justify: fromUser
                ? AstryxStackJustify.end
                : AstryxStackJustify.start,
            children: actions,
          ),
        ?footer,
      ],
    );

    return Semantics(
      container: true,
      // The author is the label and the content keeps its own nodes: a
      // transcript read as one long string with no turn boundaries is not a
      // transcript.
      explicitChildNodes: true,
      label: semanticsLabel ?? author ?? _defaultLabel(l10n),
      child: leading == null
          ? turn
          : AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.start,
              children: <Widget>[leading!, Flexible(child: turn)],
            ),
    );
  }

  String _defaultLabel(AstryxLocalizations l10n) => switch (role) {
    AstryxChatRole.user => l10n.chatFromUser,
    AstryxChatRole.assistant => l10n.chatFromAssistant,
    AstryxChatRole.system => l10n.chatSystemMessage,
  };
}

/// A run of turns, spaced and announced as a transcript.
///
/// Upstream's `ChatMessageList`. It is **not** a scroller: `AstryxChatLayout`
/// owns the scrolling, and a list that scrolled inside a scroller is the
/// nested-viewport bug every chat UI ships once.
///
/// {@tool snippet}
/// ```dart
/// AstryxChatMessageList(
///   children: <AstryxChatMessage>[
///     AstryxChatMessage(role: AstryxChatRole.user, child: AstryxText(prompt)),
///     AstryxChatMessage(child: AstryxText(reply)),
///   ],
/// )
/// ```
/// {@end-tool}
class AstryxChatMessageList extends StatelessWidget {
  /// Creates a transcript.
  const AstryxChatMessageList({
    required this.children,
    super.key,
    this.gap = AstryxSpacingToken.spacing6,
    this.label,
  });

  /// The turns, oldest first.
  final List<Widget> children;

  /// The space between turns.
  ///
  /// Generous by default: the gap between two turns is what separates a
  /// question from its answer, and a tight one makes a conversation read as one
  /// wall of text.
  final AstryxSpacingToken gap;

  /// An accessible name for the transcript. Defaults to "Conversation".
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label ?? l10n.chatTranscript,
      child: AstryxVStack(
        gap: gap,
        align: AstryxStackAlign.stretch,
        children: children,
      ),
    );
  }
}
