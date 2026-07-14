import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_info.dart';

/// Material 3 라이트 테마 — 밝은 마케팅 스튜디오 톤.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: AppColors.blue,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.purple,
      onSecondary: AppColors.onPrimary,
      tertiary: AppColors.teal,
      error: AppColors.coral,
      surface: AppColors.card,
      onSurface: AppColors.body,
      surfaceContainerHighest: AppColors.bg,
      outline: AppColors.border,
    );

    final displayBase = GoogleFonts.plusJakartaSansTextTheme();
    final bodyBase = GoogleFonts.notoSansKrTextTheme();

    final textTheme = bodyBase.copyWith(
      displayLarge: displayBase.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        letterSpacing: -0.5,
      ),
      displayMedium: displayBase.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        letterSpacing: -0.3,
      ),
      displaySmall: displayBase.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      ),
      headlineLarge: displayBase.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      ),
      headlineMedium: displayBase.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      ),
      headlineSmall: displayBase.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
      ),
      titleLarge: bodyBase.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      ),
      titleMedium: bodyBase.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.body,
      ),
      titleSmall: bodyBase.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.body,
      ),
      bodyLarge: bodyBase.bodyLarge?.copyWith(
        color: AppColors.body,
        height: 1.55,
      ),
      bodyMedium: bodyBase.bodyMedium?.copyWith(
        color: AppColors.body,
        height: 1.55,
      ),
      bodySmall: bodyBase.bodySmall?.copyWith(
        color: AppColors.muted,
        height: 1.5,
      ),
      labelLarge: bodyBase.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.body,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bg,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: AppColors.onPrimary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bg,
        selectedColor: AppColors.blue.withValues(alpha: 0.12),
        side: const BorderSide(color: AppColors.border),
        labelStyle: textTheme.bodySmall,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: AppColors.sidebarBg),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static String get appTitle => AppInfo.seoTitle;
}
