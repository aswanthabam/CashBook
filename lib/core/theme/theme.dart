import 'package:cashbook/core/theme/app_palatte.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalatte.background,
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: GoogleFonts.roboto().fontFamily
    ),
  );
  static final darkTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalatteDark.background,
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).apply(
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
  );
}