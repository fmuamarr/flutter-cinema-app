import 'package:flutter/material.dart';

import '../../utils/const/borderradius_const.dart';
import '../../utils/const/string_const.dart';

// Tema yang digunakan clone dari Disney Plus

class AppTheme {
  static const Color disneyDeepBackground = Color(0xFF090B13);
  static const Color disneyCardSurface = Color(0xFF1A1D29);
  static const Color disneyElevated = Color(0xFF252836);
  static const Color disneyBlue = Color(0xFF0063E5); // CTA button primary
  static const Color disneyCyanAccent = Color(0xFF02E7C4);
  static const Color disneySilver = Color(0xFFCACACA); // Subtitle/Muted text

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: disneyBlue,
      surfaceTint: disneyBlue,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF04449B),
      onPrimaryContainer: Color(0xFFD6E4FF),
      secondary: disneyCyanAccent,
      onSecondary: Color(0xFF003730),
      secondaryContainer: Color(0xFF005047),
      onSecondaryContainer: Color(0xFF73F8DF),
      tertiary: Color(0xFF6B7AC9),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF22306D),
      onTertiaryContainer: Color(0xFFDEE0FF),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: disneyDeepBackground,
      onSurface: Color(0xFFF9F9F9),
      onSurfaceVariant: disneySilver,
      outline: Color(0xFF4F5361),
      outlineVariant: Color(0xFF2F3240),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFFE1E2EC),
      inversePrimary: Color(0xFF0058CA),
      surfaceDim: Color(0xFF06070C),
      surfaceBright: Color(0xFF161822),
      surfaceContainerLowest: Color(0xFF040509),
      surfaceContainerLow: Color(0xFF0E101A),
      surfaceContainer: disneyCardSurface,
      surfaceContainerHigh: disneyElevated,
      surfaceContainerHighest: Color(0xFF323647),
    );
  }

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0058CA),
      surfaceTint: Color(0xFF0058CA),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD6E4FF),
      onPrimaryContainer: Color(0xFF001A41),
      secondary: Color(0xFF006A5F),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF73F8DF),
      onSecondaryContainer: Color(0xFF00201C),
      tertiary: Color(0xFF515E9E),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFDEE0FF),
      onTertiaryContainer: Color(0xFF0B1B54),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFF7F9FD),
      onSurface: Color(0xFF14171F),
      onSurfaceVariant: Color(0xFF474955),
      outline: Color(0xFF767986),
      outlineVariant: Color(0xFFC6C7D5),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFF2E313D),
      inversePrimary: Color(0xFFA9C7FF),
      surfaceDim: Color(0xFFD7D9E3),
      surfaceBright: Color(0xFFF7F9FD),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFEFF1FB),
      surfaceContainer: Color(0xFFE9EBF5),
      surfaceContainerHigh: Color(0xFFE3E5EF),
      surfaceContainerHighest: Color(0xFFDDDFE9),
    );
  }

  static ThemeData dark() => theme(darkScheme());
  static ThemeData light() => theme(lightScheme());

  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    fontFamily: StringConst.interFont,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    appBarTheme: appBarTheme(colorScheme),
    textTheme: textTheme(colorScheme),
    elevatedButtonTheme: elevatedButtonTheme(colorScheme),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colorScheme.surfaceContainer,
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 14,
        color: colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

AppBarTheme appBarTheme(ColorScheme colorScheme) => AppBarTheme(
  centerTitle: false,
  backgroundColor: Colors.transparent,
  surfaceTintColor: Colors.transparent,
  scrolledUnderElevation: 0,
  elevation: 0,
);

TextTheme textTheme(ColorScheme colorScheme) {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: StringConst.montserratFont,
      fontSize: 48,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontFamily: StringConst.montserratFont,
      fontSize: 34,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: TextStyle(
      fontFamily: StringConst.montserratFont,
      fontSize: 26,
      fontWeight: FontWeight.w700,
    ),
    headlineLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    headlineMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    headlineSmall: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16, color: colorScheme.onSurface),
    bodyMedium: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
    bodySmall: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
    labelLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.8,
    ),
  );
}

ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderradiusConst.radiusAllSemiBig,
        ),
      ),
    );
