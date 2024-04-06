import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TagData {
  @Id()
  int id;
  String title;
  String? description;
  int color;
  String icon;
  bool isSelected;

  TagData({
    required this.title,
    required this.id,
    required this.color,
    required this.icon,
    this.description,
    this.isSelected = false,
    // this.textColor = 0xffffffff,
  });

  Color get colorValue => Color(color);

// Color get textColorValue => Color(textColor);
}
