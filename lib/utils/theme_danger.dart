import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';

const kDangerOutlineShadows = [
  Shadow(color: Color(0x55FFFFFF), offset: Offset(-0.8, 0), blurRadius: 1.5),
  Shadow(color: Color(0x55FFFFFF), offset: Offset(0.8, 0), blurRadius: 1.5),
  Shadow(color: Color(0x55FFFFFF), offset: Offset(0, -0.8), blurRadius: 1.5),
  Shadow(color: Color(0x55FFFFFF), offset: Offset(0, 0.8), blurRadius: 1.5),
];

Color dangerColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? DesignTokens.darkDanger
        : DesignTokens.lightDanger;

TextStyle dangerStyle(BuildContext context, [TextStyle? base]) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final style = base ?? const TextStyle();
  return style.copyWith(
    color: isDark ? DesignTokens.darkDanger : DesignTokens.lightDanger,
    shadows: isDark ? kDangerOutlineShadows : null,
  );
}
