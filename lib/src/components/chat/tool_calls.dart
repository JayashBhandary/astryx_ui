/// The tool calls a model made, and their results.
library;

import 'package:astryx_ui/src/components/data/code.dart';
import 'package:astryx_ui/src/components/feedback/spinner.dart';
import 'package:astryx_ui/src/components/feedback/status_dot.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/collapsible.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How far along a tool call is.
enum AstryxToolCallStatus {
  /// Queued, not started.
  pending(AstryxStatusDotVariant.neutral),

  /// In flight.
  running(AstryxStatusDotVariant.accent),

  /// Returned a result.
  succeeded(AstryxStatusDotVariant.success),

  /// Returned an error, or timed out.
  failed(AstryxStatusDotVariant.error);

  const AstryxToolCallStatus(this.dot);

  /// The dot variant that stands for this status.
  final AstryxStatusDotVariant dot;
}

/// One call a model made to a tool.
@immutable
class AstryxToolCall {
  /// Describes a call.
  const AstryxToolCall({
    required this.name,
    this.status = AstryxToolCallStatus.succeeded,
    this.summary,
    this.arguments,
    this.result,
    this.language = 'json',
  });

  /// The tool's name — `search_logs`, `read_file`.
  final String name;

  /// How far along it is.
  final AstryxToolCallStatus status;

  /// A one-line description of what it did, for the collapsed row.
  ///
  /// "Searched 412 log lines" is worth more to a reader than the arguments are,
  /// which is why the arguments are behind the disclosure and this is not.
  final String? summary;

  /// What it was called with, already formatted.
  final String? arguments;

  /// What it returned, already formatted.
  final String? result;

  /// The language of [arguments] and [result], for the code blocks.
  final String language;

  @override
  bool operator ==(Object other) =>
      other is AstryxToolCall &&
      other.name == name &&
      other.status == status &&
      other.summary == summary &&
      other.arguments == arguments &&
      other.result == result &&
      other.language == language;

  @override
  int get hashCode =>
      Object.hash(name, status, summary, arguments, result, language);
}

/// The tool calls inside a turn, each one a disclosure.
///
/// Upstream's `ChatToolCalls`. Collapsed by default and **summarised in the
/// row**, because what a reader wants from a tool call is usually "did it work"
/// rather than the JSON: the status and the summary are on the header, and the
/// arguments and the result are behind it.
///
/// {@tool snippet}
/// ```dart
/// AstryxChatToolCalls(
///   calls: <AstryxToolCall>[
///     AstryxToolCall(
///       name: 'search_logs',
///       summary: 'Searched 412 lines',
///       arguments: '{"query": "bind"}',
///       result: '{"matches": 3}',
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// Put it in an `AstryxChatMessage.footer`: a tool call is *how* an answer was
/// reached, and belongs under the answer rather than in place of it.
class AstryxChatToolCalls extends StatelessWidget {
  /// Creates a run of tool calls.
  const AstryxChatToolCalls({
    required this.calls,
    super.key,
    this.label,
    this.initiallyExpanded = false,
  });

  /// The calls, in the order they were made.
  final List<AstryxToolCall> calls;

  /// An accessible name for the run. Defaults to "Tool calls".
  final String? label;

  /// Whether every call starts open.
  ///
  /// False by default. A turn that unfolds four screens of JSON on arrival has
  /// buried the answer the reader was waiting for.
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    if (calls.isEmpty) return const SizedBox.shrink();

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label ?? l10n.toolCallsLabel,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final call in calls)
            _Call(call: call, expanded: initiallyExpanded),
        ],
      ),
    );
  }
}

/// One call, as a disclosure.
class _Call extends StatelessWidget {
  const _Call({required this.call, required this.expanded});

  final AstryxToolCall call;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    final status = switch (call.status) {
      AstryxToolCallStatus.pending => l10n.toolCallPending,
      AstryxToolCallStatus.running => l10n.toolCallRunning,
      AstryxToolCallStatus.succeeded => l10n.toolCallSucceeded,
      AstryxToolCallStatus.failed => l10n.toolCallFailed,
    };

    final body = <Widget>[
      if (call.arguments != null) ...<Widget>[
        const AstryxText(
          'Arguments',
          type: AstryxTextType.label,
          color: AstryxTextColor.secondary,
        ),
        AstryxCodeBlock(call.arguments!, language: call.language),
      ],
      if (call.result != null) ...<Widget>[
        const AstryxText(
          'Result',
          type: AstryxTextType.label,
          color: AstryxTextColor.secondary,
        ),
        AstryxCodeBlock(call.result!, language: call.language),
      ],
    ];

    return AstryxCollapsible(
      title: call.name,
      description: call.summary,
      initiallyExpanded: expanded,
      // A spinner while it runs and a dot otherwise — both paired with the
      // word,
      // because colour alone is not a status and a spinner alone is not either.
      leading: call.status == AstryxToolCallStatus.running
          ? AstryxSpinner(size: AstryxSpinnerSize.sm, label: status)
          : AstryxStatusDot(call.status.dot, label: status),
      trailing: AstryxText(
        status,
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
      ),
      child: body.isEmpty
          ? AstryxText(
              status,
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            )
          : AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: body,
            ),
    );
  }
}
