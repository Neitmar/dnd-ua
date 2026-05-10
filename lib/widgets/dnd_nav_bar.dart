import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';

class DndNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<DndNavItem> items;

  const DndNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final border = isDark ? DesignTokens.darkBorderSoft : DesignTokens.lightBorderSoft;
    final accent = isDark ? DesignTokens.darkAccent : DesignTokens.lightAccent;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [DesignTokens.darkBg, const Color(0xFF0f0a07)]
              : [DesignTokens.lightBg, DesignTokens.lightBorderSoft],
        ),
        border: Border(top: BorderSide(color: border, width: 1)),
      ),
      padding: isMobile
          ? const EdgeInsets.fromLTRB(2, 6, 2, 8)
          : const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          items.length,
          (i) => _NavBarItem(
            item: items[i],
            isActive: i == currentIndex,
            onTap: () => onTap(i),
            isMobile: isMobile,
            accent: accent,
            isDark: isDark,
          ),
        ),
      ),
    );
  }
}

class DndNavItem {
  final String imagePath;
  final String label;

  DndNavItem({required this.imagePath, required this.label});
}

class _NavBarItem extends StatefulWidget {
  final DndNavItem item;
  final bool isActive;
  final VoidCallback onTap;
  final bool isMobile;
  final Color accent;
  final bool isDark;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.isMobile,
    required this.accent,
    required this.isDark,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _isHovered = false;

  // Матриця grayscale (повне знебарвлення)
  static const List<double> _grayscaleMatrix = [
    0.3, 0.59, 0.11, 0.0, 0.0,
    0.3, 0.59, 0.11, 0.0, 0.0,
    0.3, 0.59, 0.11, 0.0, 0.0,
    0.0, 0.0,  0.0,  1.0, 0.0,
  ];

  Widget _buildIcon(bool active, Color accent) {
    const size = 30.0;
    final img = Image.asset(
      widget.item.imagePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );

    if (active || _isHovered) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSmall),
          boxShadow: [
            BoxShadow(color: accent.withValues(alpha: 0.55), blurRadius: 6),
            BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 14),
          ],
        ),
        child: Transform.translate(
          offset: const Offset(0, -1), // translateY(-1px)
          child: img,
        ),
      );
    }

    // Неактивна: grayscale + dim
    return Opacity(
      opacity: widget.isDark ? 0.55 : 0.65,
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix(_grayscaleMatrix),
        child: img,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOn = widget.isActive || _isHovered;
    final labelColor = isOn
        ? widget.accent
        : (widget.isDark ? DesignTokens.darkTextMute : DesignTokens.lightTextMute);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: widget.isMobile ? 44 : 52,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: _buildIcon(widget.isActive, widget.accent),
              ),
              const SizedBox(height: 3),
              Text(
                widget.item.label,
                style: TextStyle(
                  fontFamily: DesignTokens.fontDeco,
                  fontSize: 9,
                  letterSpacing: 0.03,
                  color: labelColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
