/// A turn that came from neither participant.
library;

import 'package:astryx_ui/src/components/chat/chat_message.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A notice about the conversation itself.
///
/// Upstream's `ChatSystemMessage`. "The model changed", "This conversation was
/// resumed", "Context was trimmed" — things that happened *to* the conversation
/// rather than in it.
///
/// It is `AstryxChatMessage` with `AstryxChatRole.system` and a shorter way to
/// say so: centred, quiet, never in a bubble, and announced as a system message
/// rather than as somebody's turn.
///
/// {@tool snippet}
/// ```dart
/// const AstryxChatSystemMessage('The model changed to the long-context one')
/// ```
/// {@end-tool}
class AstryxChatSystemMessage extends StatelessWidget {
  /// Creates a system notice.
  const AstryxChatSystemMessage(
    this.message, {
    super.key,
    this.icon,
    this.action,
    this.semanticsLabel,
  });

  /// What happened.
  final String message;

  /// A glyph before the text.
  final AstryxIconName? icon;

  /// One control — "Undo", "Why?".
  ///
  /// A single slot rather than a list: a notice with three buttons in it has
  /// stopped being a notice and become a form.
  final Widget? action;

  /// Overrides what a screen reader announces.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) => AstryxChatMessage(
    role: AstryxChatRole.system,
    semanticsLabel: semanticsLabel,
    footer: action,
    child: AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        if (icon != null)
          AstryxIcon(
            icon!,
            size: AstryxIconSize.sm,
            color: AstryxIconColor.secondary,
          ),
        Flexible(
          child: AstryxText(
            message,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ),
      ],
    ),
  );
}
