import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';

/// Адаптивная кнопка з дизайн-системи DnD
class DndButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final bool isDanger;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isFullWidth;

  const DndButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.isDanger = false,
    this.width,
    this.height,
    this.icon,
    this.isFullWidth = false,
  });

  @override
  State<DndButton> createState() => _DndButtonState();
}

class _DndButtonState extends State<DndButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // Адаптивні розміри
    final buttonHeight = widget.height ?? (isMobile ? 48.0 : 40.0);

    // Кольори залежно від типу
    Color bgColor;
    Color textColor;
    Color borderColor;

    if (widget.isDanger) {
      bgColor = isDark ? DesignTokens.darkDanger : DesignTokens.lightDanger;
      textColor = Colors.white;
      borderColor = bgColor;
    } else if (widget.isPrimary) {
      bgColor = isDark ? DesignTokens.darkAccent : DesignTokens.lightAccent;
      textColor = isDark ? DesignTokens.darkBg : DesignTokens.lightBg;
      borderColor = bgColor;
    } else {
      bgColor = Colors.transparent;
      textColor = isDark ? DesignTokens.darkText : DesignTokens.lightText;
      borderColor = isDark ? DesignTokens.darkBorder : DesignTokens.lightBorder;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: widget.isFullWidth ? double.infinity : widget.width,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isPrimary || widget.isDanger ? bgColor : Colors.transparent,
            foregroundColor: textColor,
            side: BorderSide(
              color: _isHovered ? bgColor.withValues(alpha: 0.8) : borderColor,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMedium),
            ),
            elevation: 0,
            padding: EdgeInsets.zero,
            shadowColor: Colors.transparent,
          ),
          child: widget.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(textColor),
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: isMobile ? 18 : 16),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: DesignTokens.fontDeco,
                        fontSize: isMobile ? 14 : 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: DesignTokens.letterSpacingUI,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
