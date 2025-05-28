import 'package:flutter/material.dart';

class WindArrow extends StatelessWidget {
  const WindArrow({super.key, required this.angle, required this.color});
  final double angle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(angle: angle * (3.14 / 180), child: Icon(Icons.arrow_upward, size: 20, color: color),);
  }
}