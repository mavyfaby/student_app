import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF9B4500),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFDBC9),
  onPrimaryContainer: Color(0xFF331200),
  secondary: Color(0xFF765848),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFDBC9),
  onSecondaryContainer: Color(0xFF2B160A),
  tertiary: Color(0xFF636032),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFEAE5AB),
  onTertiaryContainer: Color(0xFF1E1C00),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF201A17),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF201A17),
  surfaceVariant: Color(0xFFF4DED4),
  onSurfaceVariant: Color(0xFF52443C),
  outline: Color(0xFF85746B),
  onInverseSurface: Color(0xFFFBEEE9),
  inverseSurface: Color(0xFF362F2C),
  inversePrimary: Color(0xFFFFB68E),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF9B4500),
  outlineVariant: Color(0xFFD7C2B9),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFB68E),
  onPrimary: Color(0xFF532200),
  primaryContainer: Color(0xFF763300),
  onPrimaryContainer: Color(0xFFFFDBC9),
  secondary: Color(0xFFE6BEAA),
  onSecondary: Color(0xFF432B1D),
  secondaryContainer: Color(0xFF5C4132),
  onSecondaryContainer: Color(0xFFFFDBC9),
  tertiary: Color(0xFFCDC991),
  onTertiary: Color(0xFF343208),
  tertiaryContainer: Color(0xFF4B481D),
  onTertiaryContainer: Color(0xFFEAE5AB),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF201A17),
  onBackground: Color(0xFFECE0DB),
  surface: Color(0xFF201A17),
  onSurface: Color(0xFFECE0DB),
  surfaceVariant: Color(0xFF52443C),
  onSurfaceVariant: Color(0xFFD7C2B9),
  outline: Color(0xFF9F8D84),
  onInverseSurface: Color(0xFF201A17),
  inverseSurface: Color(0xFFECE0DB),
  inversePrimary: Color(0xFF9B4500),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFB68E),
  outlineVariant: Color(0xFF52443C),
  scrim: Color(0xFF000000),
);

// Light theme
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  brightness: Brightness.light
);

// Dark theme
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  brightness: Brightness.dark
);