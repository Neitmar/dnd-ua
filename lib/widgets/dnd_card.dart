import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';

/// Переиспользуемая карточка з дизайн-системи DnD
class DndCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final bool hasBorder;
  final Color? borderColor;
  final Color? backgroundColor;
  final List<BoxShadow>? shadows;

  const DndCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = DesignTokens.borderRadiusLarge,
    this.hasBorder = true,
    this.borderColor,
    this.backgroundColor,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Container(
      padding: padding ?? const EdgeInsets.all(DesignTokens.spacing16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor ?? 
            (isDark ? DesignTokens.darkBgCard : DesignTokens.lightBgCard),
        border: hasBorder
            ? Border.all(
                color: borderColor ?? primaryColor.withValues(alpha: 0.2),
                width: 1,
              )
            : null,
        boxShadow: shadows ?? DesignTokens.shadowSmall,
      ),
      child: child,
    );
  }
}
