/// Validation status shared by every form control.
library;

import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The kind of validation feedback a control is showing.
///
/// Each maps to a status colour and to one of the `--shadow-inset-*` tokens —
/// the inset rings the Phase 3 shadow work identified. That is what upstream
/// draws around a validated input: a ring inside the control's own border,
/// not a recoloured border.
enum AstryxFieldStatusType {
  /// Something is wrong and must be fixed.
  error(
    AstryxColorToken.error,
    AstryxShadowToken.insetError,
    AstryxIconName.error,
  ),

  /// Worth attention, but not blocking.
  warning(
    AstryxColorToken.warning,
    AstryxShadowToken.insetWarning,
    AstryxIconName.warning,
  ),

  /// Confirmed good.
  success(
    AstryxColorToken.success,
    AstryxShadowToken.insetSuccess,
    AstryxIconName.success,
  );

  const AstryxFieldStatusType(this.color, this.ring, this.icon);

  /// The message and icon colour.
  final AstryxColorToken color;

  /// The inset ring drawn inside the control.
  final AstryxShadowToken ring;

  /// The icon shown beside the message.
  final AstryxIconName icon;

  /// Whether this status should be announced assertively.
  ///
  /// An error interrupts because it blocks the user; a warning or a success
  /// waits its turn, because interrupting for good news is its own problem.
  bool get isAssertive => this == AstryxFieldStatusType.error;
}

/// A validation state, optionally with a message.
///
/// {@tool snippet}
/// ```dart
/// const AstryxFieldStatus.error('Enter a valid email address');
/// const AstryxFieldStatus.success();
/// ```
/// {@end-tool}
@immutable
class AstryxFieldStatus {
  /// Creates a status of [type].
  const AstryxFieldStatus(this.type, [this.message]);

  /// Creates an error status.
  const AstryxFieldStatus.error([this.message])
    : type = AstryxFieldStatusType.error;

  /// Creates a warning status.
  const AstryxFieldStatus.warning([this.message])
    : type = AstryxFieldStatusType.warning;

  /// Creates a success status.
  const AstryxFieldStatus.success([this.message])
    : type = AstryxFieldStatusType.success;

  /// The kind of feedback.
  final AstryxFieldStatusType type;

  /// What to tell the user.
  ///
  /// Null colours the control and shows its icon without adding text — for a
  /// field whose problem is already described elsewhere, such as a summary at
  /// the top of a form.
  final String? message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxFieldStatus &&
          other.type == type &&
          other.message == message;

  @override
  int get hashCode => Object.hash(type, message);

  @override
  String toString() => 'AstryxFieldStatus.${type.name}($message)';
}
