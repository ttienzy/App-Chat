import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;
  late ThemeData _currentTheme;

  ThemeNotifier() {
    _currentTheme = _buildLightTheme();
  }

  bool get isDarkMode => _isDarkMode;
  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? _buildDarkTheme() : _buildLightTheme();
    notifyListeners();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primaryColor: Colors.blue[800],
      colorScheme: const ColorScheme.light().copyWith(secondary: Colors.amber),
      scaffoldBackgroundColor: Colors.grey[50],
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        headlineLarge: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[800]),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.blue[800],
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      primaryColor: Colors.blueGrey[800],
      colorScheme: const ColorScheme.dark().copyWith(
        secondary: Colors.amberAccent,
      ),
      scaffoldBackgroundColor: const Color(0xFF1C2841),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        headlineLarge: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
        bodyLarge: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[300]),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.blueGrey[800],
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
