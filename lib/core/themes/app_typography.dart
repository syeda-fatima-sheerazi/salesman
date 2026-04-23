import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// [Plus Jakarta Sans](https://fonts.google.com/specimen/Plus+Jakarta+Sans) —
/// clear at small sizes, works well for sales / field apps.
abstract final class AppTypography {
  static String? get fontFamily => GoogleFonts.plusJakartaSans().fontFamily;

  static TextStyle apply(TextStyle style) =>
      GoogleFonts.plusJakartaSans(textStyle: style);
}
