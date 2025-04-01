import "package:flutter/material.dart";

class DateTimeModel {
  DateTimeModel({
    required this.titleText,
    required this.valueText,
    required this.iconSection,
    required this.onTap,
  });

  final String titleText;

  final String valueText;

  final IconData iconSection;

  final VoidCallback onTap;
}
