// Elderly-Friendly UI Theme Configuration
// This file provides theme settings optimized for elderly users

import 'package:flutter/material.dart';

/// Theme configuration for elderly-friendly UI
class ElderlyTheme {
  // Font sizes - larger for better readability
  static const double fontSizeSmall = 16.0;
  static const double fontSizeMedium = 20.0;
  static const double fontSizeLarge = 26.0;
  static const double fontSizeXLarge = 32.0;
  static const double fontSizeTitle = 40.0;

  // Colors - high contrast for visibility
  static const Color primaryColor = Color(0xFF4A90D9);
  static const Color primaryDark = Color(0xFF2E6BB0);
  static const Color accentColor = Color(0xFF48BB78);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color warningColor = Color(0xFFED8936);

  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color background = Color(0xFFF7FAFC);
  static const Color cardBackground = Colors.white;
  static const Color borderColor = Color(0xFFE2E8F0);

  // Spacing - more generous for easier touch targets
  static const double paddingSmall = 12.0;
  static const double paddingMedium = 20.0;
  static const double paddingLarge = 32.0;

  // Border radius
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;

  // Button dimensions - larger for easier tapping
  static const double buttonHeight = 64.0;
  static const double buttonHeightLarge = 72.0;
  static const double minTouchTarget = 56.0;

  /// Get the elderly-friendly theme data
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: cardBackground,
        background: background,
      ),
      scaffoldBackgroundColor: background,

      // Text Theme with larger fonts
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: fontSizeTitle,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: fontSizeXLarge,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: fontSizeLarge,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSizeMedium,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSizeSmall,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
          elevation: 4,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          side: const BorderSide(color: primaryColor, width: 2),
          textStyle: const TextStyle(
            fontSize: fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingMedium,
            vertical: paddingSmall,
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        margin: const EdgeInsets.all(paddingSmall),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(
          fontSize: fontSizeMedium,
          color: textSecondary,
        ),
        hintStyle: const TextStyle(
          fontSize: fontSizeMedium,
          color: textSecondary,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 28,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 28,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        titleTextStyle: const TextStyle(
          fontSize: fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: fontSizeMedium,
          color: textPrimary,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: const TextStyle(
          fontSize: fontSizeMedium,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Korean localizations for elderly users
class ElderlyKoreanStrings {
  static const Map<String, String> strings = {
    // Main screen
    'app_name': 'Deskon',
    'my_code': '내 연결 코드',
    'copy_code': '코드 복사',
    'code_copied': '코드가 복사되었습니다',
    'request_help': '도움 요청하기',
    'connection_ready': '연결 준비됨',
    'connection_waiting': '연결 대기 중...',

    // Instructions
    'how_to_use': '사용 방법',
    'step1': '1. 위의 연결 코드를 도우미에게 알려주세요',
    'step2': '2. 도우미가 연결하면 확인 창이 나타납니다',
    'step3': '3. "허용"을 누르면 도움을 받을 수 있습니다',

    // Dialogs
    'confirm_connection': '연결을 허용하시겠습니까?',
    'allow': '허용',
    'deny': '거부',
    'disconnect': '연결 끊기',
    'disconnected': '연결이 끊어졌습니다',

    // Settings (simplified)
    'settings': '설정',
    'display_settings': '화면 설정',
    'audio_settings': '소리 설정',
    'about': '정보',

    // Status
    'online': '온라인',
    'offline': '오프라인',
    'connecting': '연결 중...',
    'connected': '연결됨',

    // Errors
    'error': '오류',
    'connection_failed': '연결에 실패했습니다',
    'try_again': '다시 시도',

    // Help button tooltips
    'help_button_tooltip': '이 버튼을 누르면 도움을 받을 수 있습니다',
    'code_explanation': '이 코드를 도우미에게 알려주세요',
  };

  static String get(String key) {
    return strings[key] ?? key;
  }
}

/// Widget extensions for elderly-friendly UI
extension ElderlyWidgetExtensions on Widget {
  /// Wrap widget with elderly-friendly padding
  Widget withElderlyPadding() {
    return Padding(
      padding: const EdgeInsets.all(ElderlyTheme.paddingMedium),
      child: this,
    );
  }

  /// Add tooltip for accessibility
  Widget withTooltip(String message) {
    return Tooltip(
      message: message,
      textStyle: const TextStyle(
        fontSize: ElderlyTheme.fontSizeMedium,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: ElderlyTheme.primaryDark,
        borderRadius: BorderRadius.circular(ElderlyTheme.borderRadiusSmall),
      ),
      child: this,
    );
  }
}
