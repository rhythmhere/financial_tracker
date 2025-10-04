import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color tokens (light, premium)
const Color kPrimary = Color(0xFF0ABF9E); // silky teal-green - slightly brighter
const Color kAccent = Color(0xFF7AE7C7);
const Color kCardLight = Color(0xFFFFFFFF);
const Color kCardDark = Color(0xFF1E1E1E);
const Color kBackgroundStart = Color(0xFFF7F8FA);
const Color kBackgroundEnd = Color(0xFFF2F4F7);
const Color kTextPrimary = Color(0xFF0F1720);
const Color kTextMuted = Color(0xFF6B7280);
const Color kUnselected = Color(0xFF94A3B8);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: kPrimary, brightness: Brightness.light),
  scaffoldBackgroundColor: kBackgroundStart,
  textTheme: TextTheme(
    titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: kTextPrimary),
    headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800, color: kTextPrimary),
    bodyLarge: GoogleFonts.poppins(fontSize: 16, color: kTextPrimary),
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
        color: greenish ? kPrimary.withAlpha(31) : Colors.black.withAlpha(31),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ];
