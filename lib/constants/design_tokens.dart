import 'package:flutter/material.dart';

/// Дизайн-токены из CSS styles.css
/// Источник: D:\Project DnD\DnD app\styles.css
class DesignTokens {
  // ═══════════════════════════════════════════════════════════════════
  // ТЕМНА ТЕМА
  // ═══════════════════════════════════════════════════════════════════
  static const Color darkBg = Color(0xFF1a1410);
  static const Color darkBgElev = Color(0xFF221a14);
  static const Color darkBgCard = Color(0xFF2a2018);
  static const Color darkBgInput = Color(0xFF1f1812);
  static const Color darkBorder = Color(0xFF3a2e22);
  static const Color darkBorderSoft = Color(0xFF2e241a);
  static const Color darkText = Color(0xFFF0E6D2);
  static const Color darkTextDim = Color(0xFFA89880);
  static const Color darkTextMute = Color(0xFF6e5e48);
  static const Color darkAccent = Color(0xFFC9A44A); // gold
  static const Color darkDanger = Color(0xFFb73a3a); // blood red

  // ═══════════════════════════════════════════════════════════════════
  // СВІТЛА ТЕМА
  // ═══════════════════════════════════════════════════════════════════
  static const Color lightBg = Color(0xFFede2cc);
  static const Color lightBgElev = Color(0xFFe6d8be);
  static const Color lightBgCard = Color(0xFFf3e8d2);
  static const Color lightBgInput = Color(0xFFf7eed9);
  static const Color lightBorder = Color(0xFFc9b48e);
  static const Color lightBorderSoft = Color(0xFFd8c8a4);
  static const Color lightText = Color(0xFF2b1d10);
  static const Color lightTextDim = Color(0xFF5a4530);
  static const Color lightTextMute = Color(0xFF8a7a5e);
  static const Color lightAccent = Color(0xFF8a6a1e); // darker gold
  static const Color lightDanger = Color(0xFFa82828);

  // ═══════════════════════════════════════════════════════════════════
  // ТИПОГРАФІЯ
  // ═══════════════════════════════════════════════════════════════════
  static const String fontDeco = 'Cinzel'; // декоративний
  static const String fontBody = 'Cormorant Garamond'; // основний
  static const String fontUI = 'Inter'; // UI

  static const double fontSizeHeading1 = 22.0;
  static const double fontSizeHeading2 = 18.0;
  static const double fontSizeHeading3 = 16.0;
  static const double fontSizeBody = 16.0;
  static const double fontSizeSmall = 14.0;
  static const double fontSizeTiny = 12.0;

  static const double letterSpacingDeco = 0.08;
  static const double letterSpacingUI = 0.04;
  static const double letterSpacingDecoSmall = 0.06;

  // ═══════════════════════════════════════════════════════════════════
  // SPACING
  // ═══════════════════════════════════════════════════════════════════
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing14 = 14.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;

  // ═══════════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════════════
  static const double borderRadiusSmall = 6.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXL = 14.0;
  static const double borderRadiusCircle = 999.0;

  // ═══════════════════════════════════════════════════════════════════
  // SHADOWS
  // ═══════════════════════════════════════════════════════════════════
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x44000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════
  // TEXT SHADOWS + OUTLINE
  // ═══════════════════════════════════════════════════════════════════

  // Dark theme: thin black outline around cream text + drop shadow
  static const List<Shadow> darkTextShadow = [
    Shadow(color: Color(0xCC000000), offset: Offset(-0.7, 0), blurRadius: 0),
    Shadow(color: Color(0xCC000000), offset: Offset(0.7, 0), blurRadius: 0),
    Shadow(color: Color(0xCC000000), offset: Offset(0, -0.7), blurRadius: 0),
    Shadow(color: Color(0xCC000000), offset: Offset(0, 0.7), blurRadius: 0),
    Shadow(color: Color(0x99000000), blurRadius: 3, offset: Offset(0, 1.5)),
  ];

  // Light theme: subtle dark definition + soft drop shadow for dark text on parchment
  static const List<Shadow> lightTextShadow = [
    Shadow(color: Color(0x33000000), offset: Offset(-0.5, 0), blurRadius: 0),
    Shadow(color: Color(0x33000000), offset: Offset(0.5, 0), blurRadius: 0),
    Shadow(color: Color(0x33000000), offset: Offset(0, -0.5), blurRadius: 0),
    Shadow(color: Color(0x33000000), offset: Offset(0, 0.5), blurRadius: 0),
    Shadow(color: Color(0x22000000), blurRadius: 2, offset: Offset(0, 0.8)),
  ];

  static List<Shadow> getTextShadow(Brightness brightness) =>
      brightness == Brightness.dark ? darkTextShadow : lightTextShadow;

  // ═══════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════

  /// Отримати текст колір залежно від теми
  static Color getTextColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkText : lightText;

  /// Отримати колір фону залежно від теми
  static Color getBgColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkBg : lightBg;

  /// Отримати колір карточки залежно від теми
  static Color getBgCardColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkBgCard : lightBgCard;

  /// Отримати accent колір залежно від теми
  static Color getAccentColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkAccent : lightAccent;

  /// Отримати danger колір залежно від теми
  static Color getDangerColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkDanger : lightDanger;

  /// Отримати border колір залежно від теми
  static Color getBorderColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkBorder : lightBorder;
}
