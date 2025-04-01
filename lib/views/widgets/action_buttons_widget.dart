import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:todolist/models/action_buttons_model.dart";

class ActionButtonsWidget extends ConsumerWidget {
  const ActionButtonsWidget({
    required this.model,
    super.key,
  });

  final ActionButtonModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: model.side,
                backgroundColor: model.backgroundColor,
                foregroundColor: model.foregroundColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(),
                ),
              ),
              onPressed: model.onPressed,
              child: Text(model.text),
            ),
          ),
        ],
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ActionButtonModel>("model", model));
  }
}
