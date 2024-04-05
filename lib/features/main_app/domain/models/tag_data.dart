import 'package:flutter/material.dart';

class TagData {
  final String id;
  final String name;
  final Color color;
  final Color textColor;
  bool isSelected;

  TagData({
    required this.name,
    required this.id,
    required this.color,
    this.isSelected = false,
    this.textColor = Colors.white,
  });
}
