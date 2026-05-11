// ═══════════════════════════════════════════════════════════════════
//  ДнД Українською — UI Widgets
//  Файл: lib/widgets/dnd_ui_widgets.dart
//
//  Містить:
//   1. DndScaffold  — базовий scaffold з пергаментним фоном
//   2. DndAppBar    — централізований хедер (крила + назва + шестерня)
// ═══════════════════════════════════════════════════════════════════

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_assets.dart';
import '../constants/design_tokens.dart';
import '../providers/app_state.dart';
import 'settings_dialog.dart';

// ───────────────────────────────────────────────────────────────────
//  1. DndScaffold
//  Використовуй замість звичайного Scaffold на всіх екранах.
//  Автоматично додає пергаментний фон.
//
//  Використання:
//    DndScaffold(
//      body: YourScreenContent(),
//      bottomNavigationBar: DndNavBar(...),
//    )
// ───────────────────────────────────────────────────────────────────
class DndScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final bool resizeToAvoidBottomInset;

  const DndScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.appBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Пергаментний фон ──
          const _ParchmentBackground(),
          // ── Оверлей для читабельності залежно від теми ──
          Container(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0x1AFFFFFF)
                : const Color(0x33000000),
          ),
          // ── Контент ──
          body,
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────
//  Внутрішній пергаментний фон
//  Спочатку показує кодовий градієнт, після завантаження — текстуру
// ───────────────────────────────────────────────────────────────────
class _ParchmentBackground extends StatelessWidget {
  const _ParchmentBackground();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return _ImageWithFallback(
      imagePath: isLight
          ? AppAssets.bgParchmentV2Sand
          : AppAssets.bgParchmentV4Dark,
      fallback: _CodeParchment(),
    );
  }
}

class _ImageWithFallback extends StatelessWidget {
  final String imagePath;
  final Widget fallback;

  const _ImageWithFallback({
    required this.imagePath,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

// Кодовий пергамент — показується поки немає ассету текстури
class _CodeParchment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParchmentPainter(),
    );
  }
}

class _ParchmentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Базовий градієнт
    final baseGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [
        Color(0xFFEDE0C8),
        Color(0xFFE8D9BC),
        Color(0xFFDDCFAE),
        Color(0xFFE4D5B8),
      ],
      stops: const [0.0, 0.35, 0.65, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = baseGrad,
    );

    // Легкий центральний відблиск (ефект освітлення)
    final centerGlow = RadialGradient(
      center: Alignment.center,
      radius: 0.75,
      colors: [
        const Color(0x22FFFFFF),
        const Color(0x00FFFFFF),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = centerGlow,
    );

    // Кутові затемнення (vignette)
    final vignette = RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [
        const Color(0x00000000),
        const Color(0x33000000),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = vignette,
    );
  }

  @override
  bool shouldRepaint(_ParchmentPainter oldDelegate) => false;
}

// ───────────────────────────────────────────────────────────────────
//  2. DndAppBar — централізований хедер (крила + назва + шестерня)
//  Як у React chrome.jsx: один компонент на весь застосунок.
//  Використання: DndScaffold(appBar: DndAppBar(title: 'ПЕРСОНАЖ'), ...)
// ───────────────────────────────────────────────────────────────────
class DndAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const DndAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wingPath = isDark ? AppAssets.wingDemonClean : AppAssets.wingAngelClean;
    final textColor = isDark ? DesignTokens.darkText : DesignTokens.lightText;
    final borderColor = isDark ? DesignTokens.darkBorderSoft : DesignTokens.lightBorderSoft;

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [DesignTokens.darkBgElev, DesignTokens.darkBg]
              : [DesignTokens.lightBgElev, DesignTokens.lightBg],
        ),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Центр: ліве крило (дзеркало) + назва + праве крило
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scaleX: -1,
                  child: _WingIcon(path: wingPath),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: DesignTokens.fontDeco,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: DesignTokens.letterSpacingDeco,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 8),
                _WingIcon(path: wingPath),
              ],
            ),
            // Права кнопка — шестерня налаштувань (long press = тестовий інвентар)
            Positioned(
              right: 4,
              child: InkWell(
                onTap: () => showSettingsDialog(context),
                onLongPress: () {
                  final state = context.read<AppState>();
                  state.update(state.fillTestInventory);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Тестовий інвентар заповнено')),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.settings,
                    color: isDark ? DesignTokens.darkAccent : DesignTokens.lightAccent,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WingIcon extends StatelessWidget {
  final String path;
  const _WingIcon({required this.path});

  Widget _layer(String path, double blur, Color color) => ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          child: Image.asset(path, width: 46, height: 36, fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox(width: 10)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFFDC2828) : const Color(0xFF1A0A05);

    return Stack(
      alignment: Alignment.center,
      children: [
        _layer(path, 5.0, base.withValues(alpha: isDark ? 0.45 : 0.35)),
        _layer(path, 2.0, base.withValues(alpha: isDark ? 0.70 : 0.55)),
        _layer(path, 0.5, base.withValues(alpha: isDark ? 0.95 : 1.00)),
        Image.asset(path, width: 46, height: 36, fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const SizedBox(width: 10)),
      ],
    );
  }
}
