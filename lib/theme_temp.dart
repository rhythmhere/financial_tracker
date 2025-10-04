import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color tokens
const Color kPrimary = Color(0xFF00BFA5); // silky teal-green
const Color kAccent = Color(0xFF1DE9B6);
const Color kCardLight = Color(0xFFFFFFFF);
const Color kCardDark = Color(0xFF1E1E1E);
const Color kTextPrimary = Color(0xFF212121);
const Color kTextMuted = Color(0xFF424242);
const Color kUnselected = Color(0xFFB0B0B0);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: kPrimary, brightness: Brightness.light),
  scaffoldBackgroundColor: const Color(0xFFF6F7FA),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
    headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800),
    bodyLarge: GoogleFonts.poppins(fontSize: 16),
    bodySmall: GoogleFonts.poppins(fontSize: 12, color: kTextMuted),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: kTextPrimary,
    titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: kTextPrimary),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: kPrimary, elevation: 6),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: kPrimary, brightness: Brightness.dark),
  scaffoldBackgroundColor: const Color(0xFF0B0B0B),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
    headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
    bodyLarge: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
    bodySmall: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
    titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: kPrimary, elevation: 8),
);

// Reusable shadows
List<BoxShadow> softShadows({bool greenish = false}) => [
      BoxShadow(
        color: greenish ? kPrimary.withOpacity(0.12) : Colors.black.withOpacity(0.12),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ];
