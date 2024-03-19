import 'package:flutter/material.dart';

abstract class AppPalate {
  static const Color primary = Color(0xFF6A85DE);
  static const Color primaryLight = Color.fromRGBO(124, 147, 195, 1);
  static const Color primarySemiDark = Color(0xff5A7A8E);
  static const Color primaryDark = Color(0xFF354D9D);

  static const Color red = Color(0xffE93939);
  static const Color green = Color.fromARGB(255, 0, 186, 74);
  static const Color background = Color(0xffffffff);
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const primaryLightTextColor = Color.fromRGBO(223, 235, 255, 1.0);
  static const primaryTextColor = Color(0xFF354D9D);
}


class AppPalateDark {
  static const Color primary = Color(0xFF6A85DE);
  static const Color primaryLight = Color.fromRGBO(138, 161, 211, 1);
  static const Color primarySemiDark = Color.fromARGB(255, 169, 203, 223);
  static const Color primaryDark = Color(0xFF354D9D);

  static const Color red = Color(0xffE93939);
  static const Color green = Color(0xff39E980);
  static const Color background = Color(0xff111111);
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xff000000);
  static const Color black = Color(0xffc5c5c5);
  static const primaryLightTextColor = Color.fromRGBO(223, 235, 255, 1.0);
  static const primaryTextColor = Color(0xFFB1C2FC);
}