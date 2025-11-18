import 'package:aura_project/core/style/colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final theme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      surface: AppColors.backgroundColor,
      onPrimary: Colors.white,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Inter',
  );
}
