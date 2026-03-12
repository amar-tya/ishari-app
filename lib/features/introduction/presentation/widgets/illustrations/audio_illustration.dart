import 'package:flutter/material.dart';

/// Flat vector audio/headphones illustration for Slide 2.
class AudioIllustration extends StatelessWidget {
  const AudioIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 240,
      child: CustomPaint(painter: _AudioPainter()),
    );
  }
}

class _AudioPainter extends CustomPainter {
  static const _primary = Color(0xFF51C878);
  static const _primaryDark = Color(0xFF3DAF5E);
  static const _primaryContainer = Color(0xFFE8F8EE);
  static const _yellow = Color(0xFFFFD54F);
  static const _teal = Color(0xFFB2DFDB);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 280;
    final sy = size.height / 240;
    canvas
      ..save()
      ..scale(sx, sy);
    _draw(canvas);
    canvas.restore();
  }

  void _draw(Canvas c) {
    // Shadow
    c.drawOval(
      const Rect.fromLTWH(60, 215, 160, 18),
      Paint()..color = const Color(0xFF3DAF5E).withOpacity(0.14),
    );

    // Background medallion
    c.drawCircle(
      const Offset(140, 108),
      82,
      Paint()..color = _primaryContainer,
    );
    c.drawCircle(
      const Offset(140, 108),
      82,
      Paint()
        ..color = const Color(0xFFC8F0D6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _dashedCircle(c, 140, 108, 66, const Color(0xFFC8F0D6), 1.5, 5, 4);

    // Headphone arc (top band)
    final bandPaint = Paint()
      ..color = _primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    c.drawArc(
      const Rect.fromLTWH(88, 58, 104, 80),
      3.14159,
      3.14159,
      false,
      bandPaint,
    );

    // Left ear cup
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(80, 120, 28, 40),
        const Radius.circular(14),
      ),
      Paint()..color = _primary,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(87, 127, 14, 26),
        const Radius.circular(7),
      ),
      Paint()..color = _primaryDark,
    );

    // Right ear cup
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(172, 120, 28, 40),
        const Radius.circular(14),
      ),
      Paint()..color = _primary,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(179, 127, 14, 26),
        const Radius.circular(7),
      ),
      Paint()..color = _primaryDark,
    );

    // Sound waves left
    _soundWave(c, 68, 140, 12, false);
    _soundWave(c, 54, 140, 20, false);

    // Sound waves right
    _soundWave(c, 212, 140, 12, true);
    _soundWave(c, 226, 140, 20, true);

    // Music note center
    _musicNote(c, 130, 78);

    // Sparkles
    _star4(c, Paint()..color = _yellow, 228, 40, 8);
    _star4(c, Paint()..color = _yellow.withOpacity(0.8), 48, 62, 6);
    c.drawCircle(const Offset(50, 155), 5, Paint()..color = const Color(0xFFFF8A65).withOpacity(0.65));
    c.drawCircle(const Offset(242, 80), 4, Paint()..color = const Color(0xFF64B5F6).withOpacity(0.7));

    // Cross sparkles
    _cross(c, _yellow, 156, 25, 5, 2.2);
    _cross(c, _primary, 34, 126, 6, 2.5);

    _dashedCircle(c, 140, 108, 95, _primary, 1, 4, 6);
  }

  void _soundWave(Canvas c, double x, double y, double r, bool rightSide) {
    final paint = Paint()
      ..color = _teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final startAngle = rightSide ? -0.8 : 3.14159 + 0.8;
    final sweepAngle = rightSide ? 1.6 : -1.6;
    c.drawArc(
      Rect.fromCenter(center: Offset(x, y), width: r * 2, height: r * 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  void _musicNote(Canvas c, double x, double y) {
    final paint = Paint()..color = _primaryDark.withOpacity(0.5);
    c.drawCircle(Offset(x, y + 14), 8, paint);
    c.drawRect(Rect.fromLTWH(x + 6, y, 4, 18), paint);
    c.drawLine(
      Offset(x + 10, y),
      Offset(x + 18, y - 4),
      Paint()
        ..color = _primaryDark.withOpacity(0.5)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  void _star4(Canvas c, Paint paint, double cx, double cy, double r) {
    final path = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r * 0.35, cy - r * 0.35)
      ..lineTo(cx + r, cy)
      ..lineTo(cx + r * 0.35, cy + r * 0.35)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r * 0.35, cy + r * 0.35)
      ..lineTo(cx - r, cy)
      ..lineTo(cx - r * 0.35, cy - r * 0.35)
      ..close();
    c.drawPath(path, paint);
  }

  void _cross(Canvas c, Color color, double cx, double cy, double r, double w) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    c.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), paint);
    c.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), paint);
  }

  void _dashedCircle(Canvas c, double cx, double cy, double r, Color color, double sw, double dl, double gl) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw;
    final path = Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    final metrics = path.computeMetrics().first;
    var dist = 0.0;
    final dashed = Path();
    while (dist < metrics.length) {
      dashed.addPath(metrics.extractPath(dist, dist + dl), Offset.zero);
      dist += dl + gl;
    }
    c.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
