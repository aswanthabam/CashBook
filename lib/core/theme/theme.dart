import 'package:cashbook/core/theme/app_palatte.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
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
    required this.primaryTextColor,
    this.primaryLightTextColor = AppPalate.primaryLightTextColor,
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
  final Color primaryLightTextColor;
  final Color primaryTextColor;

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
    Color? primaryTextColor,
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
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
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
      primaryTextColor: Color.lerp(primaryTextColor, other.primaryTextColor, t)!,
    );
  }
}

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppPalate.background,
      textTheme: ThemeData.light()
          .textTheme
          .apply(fontFamily: GoogleFonts.roboto().fontFamily),
      bottomSheetTheme: const BottomSheetThemeData(
        modalBackgroundColor: AppPalate.white,
        modalBarrierColor: AppPalate.transparent,
        backgroundColor: AppPalate.white,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: AppPalate.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalate.white,
        iconTheme: IconThemeData(color: AppPalate.black),
        actionsIconTheme: IconThemeData(color: AppPalate.black),
      ),
      extensions: [
        AppColorsExtension(
          primary: AppPalate.primary,
          primaryLight: AppPalate.primaryLight,
          primarySemiDark: AppPalate.primarySemiDark,
          primaryDark: AppPalate.primaryDark,
          red: AppPalate.red,
          green: AppPalate.green,
          background: AppPalate.background,
          transparent: AppPalate.transparent,
          white: AppPalate.white,
          black: AppPalate.black,
          primaryTextColor: AppPalate.primaryTextColor,
        )
      ]);
  static final darkTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppPalateDark.background,
      textTheme: ThemeData.dark()
          .textTheme
          .apply(
            fontFamily: GoogleFonts.roboto().fontFamily,
          )
          .copyWith(),
      bottomSheetTheme: const BottomSheetThemeData(
        modalBackgroundColor: AppPalateDark.white,
        modalBarrierColor: AppPalateDark.transparent,
        backgroundColor: AppPalateDark.white,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: AppPalateDark.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalateDark.white,
        iconTheme: IconThemeData(color: AppPalateDark.black),
        actionsIconTheme: IconThemeData(color: AppPalateDark.black),
        titleTextStyle: TextStyle(color: AppPalateDark.black),
      ),

      extensions: [
        AppColorsExtension(
          primary: AppPalateDark.primary,
          primaryLight: AppPalateDark.primaryLight,
          primarySemiDark: AppPalateDark.primarySemiDark,
          primaryDark: AppPalateDark.primaryDark,
          red: AppPalateDark.red,
          green: AppPalateDark.green,
          background: AppPalateDark.background,
          transparent: AppPalateDark.transparent,
          white: AppPalateDark.white,
          black: AppPalateDark.black,
          primaryTextColor: AppPalateDark.primaryTextColor,
        )
      ]);
}

class BrandColors {
  final Color primary;

  const BrandColors({required this.primary});
}
