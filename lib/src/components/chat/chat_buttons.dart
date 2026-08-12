/// The composer's two controls.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/widgets.dart';

/// The control that sends a message, and stops a reply.
///
/// Upstream's `ChatSendButton`. **One control, two jobs** — which is the whole
/// design: the thing you press to start a reply is the thing you press to stop
/// it, in the place your hand is already going. Two buttons side by side, one
/// of
/// them always inert, is the arrangement this replaces.
///
/// {@tool snippet}
/// ```dart
/// AstryxChatSendButton(
///   canSend: _draft.text.trim().isNotEmpty,
///   generating: _isGenerating,
///   onSend: _send,
///   onStop: _stop,
/// )
/// ```
/// {@end-tool}
///
/// `AstryxChatComposer` builds one of these itself; reach for it directly only
/// when assembling a composer of your own.
class AstryxChatSendButton extends StatelessWidget {
  /// Creates a send control.
  const AstryxChatSendButton({
    super.key,
    this.onSend,
    this.onStop,
    this.canSend = false,
    this.generating = false,
    this.enabled = true,
  });

  /// Called to send.
  final VoidCallback? onSend;

  /// Called to stop a reply in flight.
  final VoidCallback? onStop;

  /// Whether there is something to send.
  ///
  /// Separate from [enabled] on purpose: an empty draft is not an error and not
  /// a disabled composer — it is a button with nothing to do yet.
  final bool canSend;

  /// Whether a reply is being generated. Turns this into a stop control.
  final bool generating;

  /// Whether the control responds at all.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    if (generating) {
      return AstryxIconButton(
        icon: AstryxIconName.stop,
        // A separate string from `chatSend`, because a button whose meaning
        // changes needs a name that changes with it — and a screen reader
        // announces the name, not the glyph.
        label: l10n.chatStop,
        tooltip: l10n.chatStop,
        variant: AstryxButtonVariant.secondary,
        enabled: enabled && onStop != null,
        onPressed: () => onStop?.call(),
      );
    }

    return AstryxIconButton(
      icon: AstryxIconName.arrowUp,
      label: l10n.chatSend,
      tooltip: l10n.chatSend,
      variant: AstryxButtonVariant.primary,
      enabled: enabled && canSend && onSend != null,
      onPressed: () => onSend?.call(),
    );
  }
}

/// The composer's speech-to-text control.
///
/// Upstream's `ChatDictationButton`. **This package does no speech
/// recognition** — there is no platform channel here and no dependency that
/// would bring one. What it provides is the control and its states, so a caller
/// wiring `speech_to_text` or a platform API has somewhere to put it that looks
/// and behaves like the rest of the composer.
///
/// {@tool snippet}
/// ```dart
/// AstryxChatDictationButton(
///   listening: _listening,
///   onStart: _startDictation,
///   onStop: _stopDictation,
/// )
/// ```
/// {@end-tool}
class AstryxChatDictationButton extends StatelessWidget {
  /// Creates a dictation control.
  const AstryxChatDictationButton({
    super.key,
    this.onStart,
    this.onStop,
    this.listening = false,
    this.enabled = true,
    this.unavailableReason,
  });

  /// Called to begin listening.
  final VoidCallback? onStart;

  /// Called to stop listening.
  final VoidCallback? onStop;

  /// Whether it is listening now.
  final bool listening;

  /// Whether dictation is available at all.
  final bool enabled;

  /// Why dictation is unavailable, if it is.
  ///
  /// Shown as the tooltip on the disabled control. A control that is dim for no
  /// stated reason is one a user assumes is broken — "No microphone permission"
  /// is a sentence they can act on.
  final String? unavailableReason;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    final label = listening ? l10n.chatDictationStop : l10n.chatDictationStart;

    return AstryxIconButton(
      icon: AstryxIconName.microphone,
      label: label,
      tooltip: enabled ? label : (unavailableReason ?? label),
      // Pressed-looking while listening: the state has to be visible without
      // relying on an animation, which reduced motion would remove.
      variant: listening
          ? AstryxButtonVariant.secondary
          : AstryxButtonVariant.ghost,
      enabled: enabled && (listening ? onStop != null : onStart != null),
      onPressed: () => listening ? onStop?.call() : onStart?.call(),
    );
  }
}
