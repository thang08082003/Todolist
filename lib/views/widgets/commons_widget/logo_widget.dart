import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
    this.width = 300,
    this.height = 180,
    this.color = Colors.black,
  });
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/images/logo.png',
        width: width,
        height: height,
        color: color,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('width', width));
  }
}
