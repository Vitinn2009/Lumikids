import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';


class AppTextStyles {
  // TITLES
  static final h1 = GoogleFonts.rubik(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.black,
  );

  static final h2 = GoogleFonts.rubik(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  // BODY
  static final body = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static final subtitle = GoogleFonts.roboto(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  // BUTTON
  static final button = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // INPUT
  static final input = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}