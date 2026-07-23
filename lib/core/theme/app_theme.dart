import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const background = Color(0xFFFFFFFF);
  static const groupedBackground = Color(0xFFF2F2F7);
  static const separator = Color(0xFFE5E5EA);
  static const label = Color(0xFF1C1C1E);
  static const labelSecondary = Color(0xFF6B5D4C); // as per spec, or 8E8E93
  static const Color accent = Color(0xFFD99A3D);
  static const Color accentTint = Color(0xFFFDF3E1);
  static const Color gold = Color(0xFFE3A438);
  static const darkCard = Color(0xFF1C1C1E);
  static const Color card = Color(0xFFF2F2F7); // Added based on typical usage
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
}

class AppSpacings {
  static double get s4 => 4.0.r;
  static double get s8 => 8.0.r;
  static double get s12 => 12.0.r;
  static double get s16 => 16.0.r;
  static double get s24 => 24.0.r;
  static double get s32 => 32.0.r;
  static double get s48 => 48.0.r;
}

class AppRadius {
  static double get card => 20.0.r;
  static double get button => 22.0.r;
  static double get full => 999.0.r;
}

class AppTypography {
  static const String fontFamily = 'Inter';

  static TextStyle get largeTitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 34.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.label,
  );

  static TextStyle get title1 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.label,
  );

  static TextStyle get title2 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.label,
  );

  static TextStyle get title3 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.label,
  );

  static TextStyle get headline => TextStyle(
    fontFamily: fontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.label,
  );

  static TextStyle get body => TextStyle(
    fontFamily: fontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.label,
  );

  static TextStyle get subhead => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.label,
  );

  static TextStyle get footnote => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.label,
  );

  static TextStyle get caption => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.label,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        surface: AppColors.background,
        error: CupertinoColors.destructiveRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.label),
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.label,
        ),
      ),
      // To keep standard dialogs matching our spec
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
