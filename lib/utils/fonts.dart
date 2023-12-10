import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appFont(
    {Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing}) {
  return GoogleFonts.openSans(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
