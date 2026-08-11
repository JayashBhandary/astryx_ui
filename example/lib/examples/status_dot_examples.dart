import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example status_dot_demo -> StatusDotDemoExample
class StatusDotDemoExample extends StatelessWidget {
  const StatusDotDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The dot is never the whole message: the words beside it are what a
    // reader who cannot tell green from amber relies on.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (variant, label) in const <(AstryxStatusDotVariant, String)>[
          (AstryxStatusDotVariant.success, 'Healthy'),
          (AstryxStatusDotVariant.warning, 'Degraded'),
          (AstryxStatusDotVariant.error, 'Unreachable'),
          (AstryxStatusDotVariant.accent, 'Deploying'),
          (AstryxStatusDotVariant.neutral, 'Not configured'),
        ])
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxStatusDot(variant, label: label),
              AstryxText(label),
            ],
          ),
      ],
    );
  }
}
// #end

// #example status_dot_in_place -> StatusDotInPlaceExample
class StatusDotInPlaceExample extends StatelessWidget {
  const StatusDotInPlaceExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Where a dot earns its keep: a list of rows whose text already says what
    // the state is, so the dot only has to make it scannable.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final (variant, service, state, pulsing)
            in const <(AstryxStatusDotVariant, String, String, bool)>[
          (AstryxStatusDotVariant.success, 'api-gateway', 'Healthy', false),
          (AstryxStatusDotVariant.accent, 'billing', 'Deploying', true),
          (AstryxStatusDotVariant.warning, 'search', 'Degraded', false),
          (AstryxStatusDotVariant.error, 'mailer', 'Unreachable', false),
        ])
          AstryxCard(
            padding: AstryxSpacingToken.spacing3,
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                AstryxStatusDot(
                  variant,
                  label: state,
                  pulsing: pulsing,
                  tooltip: '$service is $state'.toLowerCase(),
                ),
                Expanded(child: AstryxText(service)),
                AstryxText(
                  state,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
// #end
