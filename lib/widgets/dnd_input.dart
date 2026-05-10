import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';

/// Адаптивне текстове поле з дизайн-системи DnD
class DndInput extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final bool isReadOnly;
  final bool isEnabled;

  const DndInput({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.isReadOnly = false,
    this.isEnabled = true,
  });

  @override
  State<DndInput> createState() => _DndInputState();
}

class _DndInputState extends State<DndInput> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // Адаптивні розміри
    final fontSize = isMobile ? 16.0 : 14.0;
    final labelFontSize = isMobile ? 13.0 : 12.0;
    final contentPadding = isMobile
        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 14, vertical: 10);

    final bgColor = isDark ? DesignTokens.darkBgInput : DesignTokens.lightBgInput;
    final borderColor = isDark ? DesignTokens.darkBorder : DesignTokens.lightBorder;
    final textColor = isDark ? DesignTokens.darkText : DesignTokens.lightText;
    final labelColor = isDark ? DesignTokens.darkTextDim : DesignTokens.lightTextDim;
    final hintColor = isDark ? DesignTokens.darkTextMute : DesignTokens.lightTextMute;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Лейбл
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.label,
              style: TextStyle(
                fontFamily: DesignTokens.fontDeco,
                fontSize: labelFontSize,
                color: widget.errorText != null ? DesignTokens.darkDanger : labelColor,
                letterSpacing: DesignTokens.letterSpacingDecoSmall,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        // Input field
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          readOnly: widget.isReadOnly,
          enabled: widget.isEnabled,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          style: TextStyle(
            fontFamily: DesignTokens.fontBody,
            fontSize: fontSize,
            color: textColor,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgColor,
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: DesignTokens.fontBody,
              fontSize: fontSize,
              color: hintColor,
              fontStyle: FontStyle.italic,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 18, color: labelColor)
                : null,
            suffixIcon: widget.suffixIcon,
            contentPadding: contentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMedium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMedium),
              borderSide: BorderSide(
                color: widget.errorText != null ? DesignTokens.darkDanger : borderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMedium),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMedium),
              borderSide: const BorderSide(
                color: DesignTokens.darkDanger,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMedium),
              borderSide: const BorderSide(
                color: DesignTokens.darkDanger,
                width: 1.5,
              ),
            ),
            errorText: widget.errorText,
          ),
        ),
      ],
    );
  }
}
