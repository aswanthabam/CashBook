import 'package:cashbook/core/theme/app_palatte.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension>{
  AppColorsExtension({
    required this.primary,
    required this.primaryLight,
    required this.primarySemiDark,
    required this.primaryDark,
    required this.red,
    required this.green,
    required this.background,
    required this.transparent,
    required this.white,
    required this.black,
  });

  final Color primary;
  final Color primaryLight;
  final Color primarySemiDark;
  final Color primaryDark;
  final Color red;
  final Color green;
  final Color background;
  final Color transparent;
  final Color white;
  final Color black;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primarySemiDark,
    Color? primaryDark,
    Color? red,
    Color? green,
    Color? background,
    Color? transparent,
    Color? white,
    Color? black,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primarySemiDark: primarySemiDark ?? this.primarySemiDark,
      primaryDark: primaryDark ?? this.primaryDark,
      red: red ?? this.red,
      green: green ?? this.green,
      background: background ?? this.background,
      transparent: transparent ?? this.transparent,
      white: white ?? this.white,
      black: black ?? this.black,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
      covariant ThemeExtension<AppColorsExtension>? other,
      double t,
      ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primarySemiDark: Color.lerp(primarySemiDark, other.primarySemiDark, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      red: Color.lerp(red, other.red, t)!,
      green: Color.lerp(green, other.green, t)!,
      background: Color.lerp(background, other.background, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
    );
  }
}

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalatte.background,
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: GoogleFonts.roboto().fontFamily
    ),
    extensions: [
      AppColorsExtension(
        primary: AppPalatte.primary,
        primaryLight: AppPalatte.primaryLight,
        primarySemiDark: AppPalatte.primarySemiDark,
        primaryDark: AppPalatte.primaryDark,
        red: AppPalatte.red,
        green: AppPalatte.green,
        background: AppPalatte.background,
        transparent: AppPalatte.transparent,
        white: AppPalatte.white,
        black: AppPalatte.black,
      )
    ]
  );
  static final darkTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalatteDark.background,
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: GoogleFonts.roboto().fontFamily,
        ).copyWith(
    ),
    extensions: [
      AppColorsExtension(
        primary: AppPalatteDark.primary,
        primaryLight: AppPalatteDark.primaryLight,
        primarySemiDark: AppPalatteDark.primarySemiDark,
        primaryDark: AppPalatteDark.primaryDark,
        red: AppPalatteDark.red,
        green: AppPalatteDark.green,
        background: AppPalatteDark.background,
        transparent: AppPalatteDark.transparent,
        white: AppPalatteDark.white,
        black: AppPalatteDark.black,
      )
    ]
  );
}

class BrandColors {
  final Color primary;

  const BrandColors({required this.primary});
}