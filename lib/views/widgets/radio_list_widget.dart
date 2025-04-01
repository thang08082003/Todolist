import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:todolist/models/radio_list_model.dart";

class RadioListWidget extends StatelessWidget {
  const RadioListWidget({
    required this.model,
    required this.onChangeValue,
    required this.isSelected,
    super.key,
  });

  final RadioListModel model;

  final VoidCallback onChangeValue;

  final bool isSelected;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onChangeValue,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: model.cateColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                model.titleRadio,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<RadioListModel>("model", model))
      ..add(
        ObjectFlagProperty<VoidCallback>.has("onChangeValue", onChangeValue),
      )
      ..add(DiagnosticsProperty<bool>("isSelected", isSelected));
  }
}
