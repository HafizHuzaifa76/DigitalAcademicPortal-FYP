// app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0FDF4), // Soft greenish-white
    primaryColor: const Color(0xFF1B4332), // Dark Green for AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B4332),
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardColor: const Color(0xFFE9F5EC), // Light green card
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2D6A4F),   // Green text/icons
      secondary: Color(0xFF74C69D), // Minty button color
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: Color(0xFF2D6A4F)),
      titleLarge: TextStyle(color: Color(0xFF1B4332), fontSize: 18, fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF74C69D),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF74C69D),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
