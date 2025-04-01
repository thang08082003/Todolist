import "package:flutter/material.dart";

class TitleController {
  final TextEditingController titleController = TextEditingController();

  void dispose() {
    titleController.dispose();
  }
}
