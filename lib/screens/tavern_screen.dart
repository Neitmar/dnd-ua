import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class TavernScreen extends StatelessWidget {
  void _showLanguagePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1A0A2E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Оберіть мову / Choose language',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 16),
          _langOption(context, '🇺🇦', 'Українська', 'uk', true),
          _langOption(context, '🇬🇧', 'English', 'en', false),
          _langOption(context, '🇷🇺', 'Русский', 'ru', false),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Widget _langOption(BuildContext context, String flag, String label,
    String code, bool isActive) {
  return ListTile(
    leading: Text(flag, style: const TextStyle(fontSize: 24)),
    title: Text(label, style: const TextStyle(color: Colors.white)),
    trailing: isActive
        ? const Icon(Icons.check_circle, color: Colors.amber)
        : const Icon(Icons.circle_outlined, color: Colors.white24),
    onTap: () {
      Navigator.pop(context);
      if (!isActive) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Інші мови будуть доступні в наступному оновленні'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    },
  );
}
  const TavernScreen({super.key});

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        SizedBox.expand(
          child: CustomPaint(painter: _TavernPainter()),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0, height: 400,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.95),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text('ДнД',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.amber,
                            letterSpacing: 8,
                            fontWeight: FontWeight.w300)),
                    SizedBox(height: 4),
                    Text('Українською',
                        style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2)),
                    SizedBox(height: 8),
                    Text('Твій цифровий аркуш пригод',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                            letterSpacing: 1)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.read<AppState>().completeOnboarding(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B2D8B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_outline, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Грати локально',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _showComingSoon(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                              color: Colors.white24, width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_circle_outlined,
                                color: Colors.white70),
                            SizedBox(width: 8),
                            Text('Увійти через Google',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70)),
                            SizedBox(width: 8),
                            Text('скоро',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.amber)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _showLanguagePicker(context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.language,
                              color: Colors.white38, size: 16),
                          SizedBox(width: 6),
                          Text('Мова / Language',
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    ),
  );
}

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Скоро'),
        content: const Text(
            'Вхід через Google буде доступний у наступному оновленні. Поки що грай локально!'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Зрозуміло'),
          ),
        ],
      ),
    );
  }
}

// --- Художник таверни ---
class _TavernPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Небо / фон
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0D0A1A),
          const Color(0xFF1A0A2E),
          const Color(0xFF2D1B1B),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // Зірки
    final starPaint = Paint()..color = Colors.white.withOpacity(0.6);
    final stars = [
      [0.1, 0.05], [0.3, 0.03], [0.5, 0.08], [0.7, 0.04],
      [0.9, 0.06], [0.15, 0.12], [0.45, 0.10], [0.65, 0.07],
      [0.85, 0.13], [0.25, 0.15], [0.55, 0.02], [0.75, 0.09],
    ];
    for (final s in stars) {
      canvas.drawCircle(Offset(w * s[0], h * s[1]), 1.5, starPaint);
    }

    // Місяць
    final moonPaint = Paint()..color = const Color(0xFFFFF4C2);
    canvas.drawCircle(Offset(w * 0.8, h * 0.1), 20, moonPaint);
    final moonShadow = Paint()..color = const Color(0xFF1A0A2E);
    canvas.drawCircle(Offset(w * 0.83, h * 0.09), 18, moonShadow);

    // Будівля таверни
    final wallPaint = Paint()..color = const Color(0xFF3D2B1F);
    canvas.drawRect(
        Rect.fromLTWH(w * 0.05, h * 0.3, w * 0.9, h * 0.7), wallPaint);

    // Дах
    final roofPaint = Paint()..color = const Color(0xFF2A1A0F);
    final roofPath = Path()
      ..moveTo(w * 0.0, h * 0.3)
      ..lineTo(w * 0.5, h * 0.05)
      ..lineTo(w * 1.0, h * 0.3)
      ..close();
    canvas.drawPath(roofPath, roofPaint);

    // Дошки даху
    final roofLinePaint = Paint()
      ..color = const Color(0xFF1A0D08)
      ..strokeWidth = 2;
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(w * 0.5, h * 0.05),
        Offset(w * i / 7, h * 0.3),
        roofLinePaint,
      );
    }

    // Вивіска
    final signPaint = Paint()..color = const Color(0xFF5C3D1E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, h * 0.28, w * 0.5, h * 0.08),
        const Radius.circular(6),
      ),
      signPaint,
    );

    // Двері (відчинені)
    final doorFramePaint = Paint()..color = const Color(0xFF1A0D08);
    canvas.drawRect(
        Rect.fromLTWH(w * 0.35, h * 0.55, w * 0.3, h * 0.45), doorFramePaint);

    // Тепле світло з дверей
    final lightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF9800).withOpacity(0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.7),
        width: w * 0.5,
        height: h * 0.4,
      ));
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.75),
        width: w * 0.5,
        height: h * 0.3,
      ),
      lightPaint,
    );

    // Ліва стулка дверей
    final doorPaint = Paint()..color = const Color(0xFF4A2E0D);
    final leftDoor = Path()
      ..moveTo(w * 0.35, h * 0.55)
      ..lineTo(w * 0.35, h * 1.0)
      ..lineTo(w * 0.48, h * 1.0)
      ..lineTo(w * 0.5, h * 0.55)
      ..close();
    canvas.drawPath(leftDoor, doorPaint);

    // Права стулка дверей
    final rightDoor = Path()
      ..moveTo(w * 0.65, h * 0.55)
      ..lineTo(w * 0.65, h * 1.0)
      ..lineTo(w * 0.52, h * 1.0)
      ..lineTo(w * 0.5, h * 0.55)
      ..close();
    canvas.drawPath(rightDoor, doorPaint);

    // Вікна з теплим світлом
    _drawWindow(canvas, w * 0.1, h * 0.38, w * 0.15, h * 0.12);
    _drawWindow(canvas, w * 0.75, h * 0.38, w * 0.15, h * 0.12);

    // Силуети в вікнах
    _drawSilhouette(canvas, w * 0.145, h * 0.42, 8.0);
    _drawSilhouette(canvas, w * 0.82, h * 0.42, 10.0);
    _drawSilhouette(canvas, w * 0.79, h * 0.43, 7.0);

    // Силует у дверях
    _drawSilhouette(canvas, w * 0.44, h * 0.62, 12.0);
    _drawSilhouette(canvas, w * 0.56, h * 0.63, 11.0);

    // Бочки біля входу
    _drawBarrel(canvas, w * 0.12, h * 0.72);
    _drawBarrel(canvas, w * 0.18, h * 0.75);
    _drawBarrel(canvas, w * 0.82, h * 0.73);

    // Факели
    _drawTorch(canvas, w * 0.3, h * 0.52);
    _drawTorch(canvas, w * 0.7, h * 0.52);
  }

  void _drawWindow(Canvas canvas, double x, double y, double w, double h) {
    final windowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFCC44).withOpacity(0.9),
          const Color(0xFFFF8800).withOpacity(0.5),
        ],
      ).createShader(Rect.fromLTWH(x, y, w, h));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, w, h), const Radius.circular(4)),
      windowPaint,
    );
    // Хрест на вікні
    final crossPaint = Paint()
      ..color = const Color(0xFF2A1A0F)
      ..strokeWidth = 2;
    canvas.drawLine(
        Offset(x + w / 2, y), Offset(x + w / 2, y + h), crossPaint);
    canvas.drawLine(
        Offset(x, y + h / 2), Offset(x + w, y + h / 2), crossPaint);
  }

  void _drawSilhouette(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()..color = Colors.black.withOpacity(0.7);
    canvas.drawCircle(Offset(cx, cy), r * 0.6, paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy + r * 0.9),
            width: r * 1.4,
            height: r * 1.2),
        paint);
  }

  void _drawBarrel(Canvas canvas, double x, double y) {
    final barrelPaint = Paint()..color = const Color(0xFF5C3D1E);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 28, height: 36),
        barrelPaint);
    final ringPaint = Paint()
      ..color = const Color(0xFF8B6914)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y - 8), width: 28, height: 8),
        ringPaint);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y + 8), width: 28, height: 8),
        ringPaint);
  }

  void _drawTorch(Canvas canvas, double x, double y) {
    final stickPaint = Paint()
      ..color = const Color(0xFF5C3D1E)
      ..strokeWidth = 4;
    canvas.drawLine(Offset(x, y), Offset(x, y + 20), stickPaint);

    final flamePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.yellow,
          Colors.orange,
          Colors.transparent,
        ],
      ).createShader(
          Rect.fromCenter(center: Offset(x, y - 8), width: 20, height: 24));
    canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y - 8), width: 12, height: 20),
        flamePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}