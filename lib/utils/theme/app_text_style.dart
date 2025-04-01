import "package:flutter/material.dart";

abstract class AppTextStyle {
  static const TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(fontSize: 14, color: Colors.grey);

  static const TextStyle blackText = TextStyle(color: Colors.black);
}
