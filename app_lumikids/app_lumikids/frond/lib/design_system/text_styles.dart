import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // TÍTULOS
  static final h1 = GoogleFonts.nunito(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: AppColors.black,
    letterSpacing: -0.5,
  );

  static final h2 = GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.black,
  );

  // CORPO
  static final body = GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static final subtitle = GoogleFonts.nunito(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF8A94A6),
  );

  // BOTÃO
  static final button = GoogleFonts.nunito(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: 0.2,
  );

  // INPUT
  static final input = GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
}