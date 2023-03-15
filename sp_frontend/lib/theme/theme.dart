import 'package:flutter/material.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Palette.alpha),
  scaffoldBackgroundColor: Palette.betaLight,
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    displayColor: Palette.alphaDark,
    bodyColor: Palette.alphaDark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Palette.betaLight,
    foregroundColor: Color.fromARGB(255, 4, 57, 6),
  ),
);
