import "package:flutter/material.dart";

class DescriptionController {
  final TextEditingController descriptionController = TextEditingController();

  void dispose() {
    descriptionController.dispose();
  }
}
