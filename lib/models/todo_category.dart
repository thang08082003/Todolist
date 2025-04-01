import 'package:flutter/material.dart';

enum TodoCategory {
  learn,
  work,
  general,
}

extension CategoryExtension on TodoCategory {
  String get displayTitle {
    switch (this) {
      case TodoCategory.learn:
        return "Learn";
      case TodoCategory.work:
        return "Work";
      case TodoCategory.general:
        return "General";
    }
  }

  Color get color {
    switch (this) {
      case TodoCategory.learn:
        return Colors.red;
      case TodoCategory.work:
        return Colors.blue;
      case TodoCategory.general:
        return Colors.green;
    }
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case "Learn":
      return Colors.red;
    case "Work":
      return Colors.blue;
    case "General":
      return Colors.green;
    default:
      return Colors.white;
  }
}
