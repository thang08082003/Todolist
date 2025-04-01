import "package:flutter/material.dart";

class ActionButtonModel {
  ActionButtonModel({
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.side,
  });

  final String text;

  final Color backgroundColor;

  final Color foregroundColor;

  final VoidCallback onPressed;

  final BorderSide? side;
}
