// ═══════════════════════════════════════════════════════════════════
//  ДнД Українською — UI Widgets
//  Файл: lib/widgets/dnd_ui_widgets.dart
//
//  Містить:
//   1. DndScaffold      — базовий scaffold з пергаментним фоном
//   2. DndPageHeader    — заголовок з крилами янгола/демона
//   3. DndParchmentBox  — картка-пергамент для контенту
//   4. AppBackground    — статичний пергаментний фон (до завантаження текстури)
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

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
          // ── Темний оверлей для читабельності (налаштуй opacity) ──
          Container(color: const Color(0x55000000)),
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
    return _ImageWithFallback(
      imagePath: AppAssets.bgParchmentV1Light,
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
//  2. DndPageHeader — заголовок з крилами
//
//  Використання:
//    DndPageHeader(title: 'ПЕРСОНАЖ')
//    DndPageHeader(title: 'ІНВЕНТАР', subtitle: 'Спорядження героя')
//    DndPageHeader(title: 'КУБИКИ', showWings: false) // без крил
// ───────────────────────────────────────────────────────────────────
class DndPageHeader extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool showWings;
  final double wingSize;
  final Color titleColor;

  const DndPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showWings = true,
    this.wingSize = 52,
    this.titleColor = const Color(0xFFC9A961),
  });

  @override
  State<DndPageHeader> createState() => _DndPageHeaderState();
}

class _DndPageHeaderState extends State<DndPageHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _wingAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _wingAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Верхній орнаментальний роздільник ──
              _OrnamentDivider(),
              const SizedBox(height: 8),

              // ── Рядок з крилами та заголовком ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Крило демона (ліве)
                  if (widget.showWings)
                    Transform.scale(
                      scale: _wingAnim.value.clamp(0.0, 1.0),
                      alignment: Alignment.centerRight,
                      child: Transform.scale(
                        scaleX: -1, // дзеркало для лівого крила
                        child: _WingImage(
                          path: AppAssets.wingDemon,
                          size: widget.wingSize,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),

                  if (widget.showWings) const SizedBox(width: 10),

                  // ── Текст заголовку ──
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: widget.titleColor,
                          letterSpacing: 3,
                          shadows: const [
                            Shadow(
                              color: Color(0xAA000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                            Shadow(
                              color: Color(0x44C9A961),
                              blurRadius: 16,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          widget.subtitle!,
                          style: const TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 10,
                            color: Color(0xFF9E8A6A),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ],
                  ),

                  if (widget.showWings) const SizedBox(width: 10),

                  // Крило янгола (праве)
                  if (widget.showWings)
                    Transform.scale(
                      scale: _wingAnim.value.clamp(0.0, 1.0),
                      alignment: Alignment.centerLeft,
                      child: _WingImage(
                        path: AppAssets.wingAngel,
                        size: widget.wingSize,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),
              // ── Нижній орнаментальний роздільник ──
              _OrnamentDivider(),
            ],
          ),
        );
      },
    );
  }
}

// ───────────────────────────────────────────────────────────────────
//  Крило — зображення з graceful fallback
// ───────────────────────────────────────────────────────────────────
class _WingImage extends StatelessWidget {
  final String path;
  final double size;
  final Alignment alignment;

  const _WingImage({
    required this.path,
    required this.size,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      alignment: alignment,
      errorBuilder: (_, _, _) => SizedBox(
        width: size * 0.6,
        height: size,
        child: CustomPaint(painter: _FallbackWingPainter()),
      ),
    );
  }
}

// Кодове крило якщо ассет не завантажений
class _FallbackWingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x88C9A961)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(size.width, size.height * 0.5)
      ..quadraticBezierTo(0, 0, size.width * 0.1, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.2, size.width, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.8, size.width * 0.1, size.height * 0.7)
      ..quadraticBezierTo(0, size.height, size.width, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FallbackWingPainter old) => false;
}

// ───────────────────────────────────────────────────────────────────
//  Орнаментальний роздільник
// ───────────────────────────────────────────────────────────────────
class _OrnamentDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 12),
      painter: _DividerPainter(),
    );
  }
}

class _DividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final linePaint = Paint()
      ..color = const Color(0xFFC9A961)
      ..strokeWidth = 0.8;

    // Ліва лінія
    canvas.drawLine(
      Offset(20, cy),
      Offset(cx - 24, cy),
      linePaint,
    );
    // Права лінія
    canvas.drawLine(
      Offset(cx + 24, cy),
      Offset(size.width - 20, cy),
      linePaint,
    );

    // Центральний ромб
    final diamondPaint = Paint()
      ..color = const Color(0xFFC9A961)
      ..style = PaintingStyle.fill;

    final diamond = Path()
      ..moveTo(cx, cy - 5)
      ..lineTo(cx + 5, cy)
      ..lineTo(cx, cy + 5)
      ..lineTo(cx - 5, cy)
      ..close();
    canvas.drawPath(diamond, diamondPaint);

    // Маленькі бічні ромбики
    for (final offset in [-14.0, 14.0]) {
      final smallDiamond = Path()
        ..moveTo(cx + offset, cy - 3)
        ..lineTo(cx + offset + 3, cy)
        ..lineTo(cx + offset, cy + 3)
        ..lineTo(cx + offset - 3, cy)
        ..close();
      canvas.drawPath(
        smallDiamond,
        Paint()
          ..color = const Color(0xAAC9A961)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_DividerPainter old) => false;
}

// ───────────────────────────────────────────────────────────────────
//  3. DndParchmentBox — картка з пергаментним фоном
//
//  Використання:
//    DndParchmentBox(
//      child: YourContent(),
//    )
//    DndParchmentBox(
//      padding: EdgeInsets.all(20),
//      child: YourContent(),
//    )
// ───────────────────────────────────────────────────────────────────
class DndParchmentBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double borderRadius;

  const DndParchmentBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        // Якщо є текстура пергаменту — використовуємо DecorationImage
        // Якщо ні — красивий кодовий градієнт
        image: DecorationImage(
          image: const AssetImage(AppAssets.bgParchment),
          fit: BoxFit.cover,
          onError: (_, _) {},
        ),
        color: const Color(0xFFE8D9BC), // fallback колір
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xFFC9A961),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: Color(0x22C9A961),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
      child: child,
    );
  }
}

// ───────────────────────────────────────────────────────────────────
//  ПРИКЛАД використання на екрані:
// ───────────────────────────────────────────────────────────────────
//
//  class CharacterScreen extends StatelessWidget {
//    @override
//    Widget build(BuildContext context) {
//      return DndScaffold(
//        body: ListView(
//          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//          children: [
//
//            DndPageHeader(
//              title: 'ПЕРСОНАЖ',
//              subtitle: 'Аркуш пригодника',
//            ),
//
//            const SizedBox(height: 16),
//
//            DndParchmentBox(
//              child: Column(
//                children: [
//                  // Ім'я, клас, раса...
//                ],
//              ),
//            ),
//
//          ],
//        ),
//      );
//    }
//  }
//
// ───────────────────────────────────────────────────────────────────

// ───────────────────────────────────────────────────────────────────
//  Додати в AppAssets (lib/constants/app_assets.dart):
// ───────────────────────────────────────────────────────────────────
