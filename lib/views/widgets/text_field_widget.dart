import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:todolist/models/text_field_model.dart";

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    required this.model,
    super.key,
  });

  final TextFieldModel model;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: model.txtController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: model.hintText,
          ),
          maxLines: model.maxLine,
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextFieldModel>("model", model));
  }
}
