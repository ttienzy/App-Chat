import 'package:flutter/material.dart';

Color getProgressColor(double progress) {
  if (progress < 0.3) return Colors.red;
  if (progress < 0.7) return Colors.orange;
  return Colors.green;
}
