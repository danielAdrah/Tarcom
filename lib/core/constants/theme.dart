import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // -------------------------------------------------------------------------
    // General
    // -------------------------------------------------------------------------
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,

      secondary: AppColors.secondary,
      onSecondary: AppColors.white,

      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,

      error: AppColors.error,
      onError: AppColors.white,
    ),

    // -------------------------------------------------------------------------
    // App Bar
    // -------------------------------------------------------------------------
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    // -------------------------------------------------------------------------
    // Text
    // -------------------------------------------------------------------------
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'IBMPlexSansArabic',
      ),

      displayMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'IBMPlexSansArabic',
      ),

      displaySmall: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'IBMPlexSansArabic',
      ),

      headlineLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'IBMPlexSansArabic',
      ),

      headlineMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'IBMPlexSansArabic',
      ),

      headlineSmall: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'IBMPlexSansArabic',
      ),

      titleLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'IBMPlexSansArabic',
      ),

      titleMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'IBMPlexSansArabic',
      ),

      titleSmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'IBMPlexSansArabic',
      ),

      bodyLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'IBMPlexSansArabic',
      ),

      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'IBMPlexSansArabic',
      ),

      bodySmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'IBMPlexSansArabic',
      ),

      labelLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'IBMPlexSansArabic',
      ),

      labelMedium: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSansArabic',
      ),

      labelSmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSansArabic',
      ),
    ),

    // -------------------------------------------------------------------------
    // Elevated Buttons
    // -------------------------------------------------------------------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        minimumSize: Size(double.infinity, 52.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSansArabic',
        ),
      ),
    ),

    // -------------------------------------------------------------------------
    // Filled Buttons
    // -------------------------------------------------------------------------
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        minimumSize: Size(double.infinity, 52.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSansArabic',
        ),
      ),
    ),

    // -------------------------------------------------------------------------
    // Outlined Buttons
    // -------------------------------------------------------------------------
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: AppColors.primary, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    // -------------------------------------------------------------------------
    // Text Buttons
    // -------------------------------------------------------------------------
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // -------------------------------------------------------------------------
    // Cards
    // -------------------------------------------------------------------------
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
    ),

    // -------------------------------------------------------------------------
    // Input Fields
    // -------------------------------------------------------------------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,

      contentPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 15.r),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.error, width: 1.5.w),
      ),
      hintStyle: TextStyle(color: AppColors.textDisabled, fontSize: 14.sp),

      labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),

      prefixIconColor: AppColors.textSecondary,
      suffixIconColor: AppColors.textSecondary,
    ),

    // -------------------------------------------------------------------------
    // Bottom Navigation
    // -------------------------------------------------------------------------
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      indicatorColor: AppColors.blue100,

      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }

        return const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
      }),

      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary);
        }

        return const IconThemeData(color: AppColors.textSecondary);
      }),
    ),

    // -------------------------------------------------------------------------
    // Divider
    // -------------------------------------------------------------------------
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // -------------------------------------------------------------------------
    // Chip
    // -------------------------------------------------------------------------
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.blue100,
      disabledColor: AppColors.surfaceVariant,

      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),

      secondaryLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    ),

    // -------------------------------------------------------------------------
    // Snackbar
    // -------------------------------------------------------------------------
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: const TextStyle(color: AppColors.white, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    // -------------------------------------------------------------------------
    // Progress Indicator
    // -------------------------------------------------------------------------
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
  );
}
