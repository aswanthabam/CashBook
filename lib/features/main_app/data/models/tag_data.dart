import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TagData {
  @Id()
  int id;
  String name;
  int color;
  int textColor;
  bool isSelected;

  TagData({
    required this.name,
    required this.id,
    required this.color,
    this.isSelected = false,
    this.textColor = 0xffffffff,
  });

  Color get colorValue => Color(color);

  Color get textColorValue => Color(textColor);
}
