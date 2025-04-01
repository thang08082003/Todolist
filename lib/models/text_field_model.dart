import "package:flutter/widgets.dart";

class TextFieldModel {
  TextFieldModel({
    required this.hintText,
    required this.maxLine,
    required this.txtController,
  });

  final String hintText;

  final int maxLine;

  final TextEditingController txtController;
}
