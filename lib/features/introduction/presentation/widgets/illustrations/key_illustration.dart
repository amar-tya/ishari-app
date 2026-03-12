import 'package:flutter/material.dart';

/// Flat vector key + shield illustration for Slide 5 (Masuk untuk Mulai).
/// Faithfully recreates the SVG from the design mockup.
class KeyIllustration extends StatelessWidget {
  const KeyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 240,
      child: CustomPaint(painter: _KeyPainter()),
    );
  }
}

class _KeyPainter extends CustomPainter {
  static const _primary = Color(0xFF51C878);
  static const _primaryDark = Color(0xFF3DAF5E);
  static const _primaryContainer = Color(0xFFE8F8EE);
  static const _yellow = Color(0xFFFFD54F);
  static const _orange = Color(0xFFFF8A65);
  static const _blue = Color(0xFF64B5F6);
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
      const Rect.fromLTWH(60, 212, 160, 20),
      Paint()..color = _primaryDark.withOpacity(0.14),
    );

    // Large background ring / medallion
    c.drawCircle(const Offset(140, 108), 82, Paint()..color = _primaryContainer);
    c.drawCircle(
      const Offset(140, 108),
      82,
      Paint()
        ..color = const Color(0xFFC8F0D6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // Inner dashed ring
    _dashedCircle(c, 140, 108, 66, const Color(0xFFC8F0D6), 1.5, 5, 4);

    // Key head outer ring
    c.drawCircle(const Offset(104, 108), 38, Paint()..color = _primary);
    // Key head inner ring
    c.drawCircle(const Offset(104, 108), 22, Paint()..color = _primaryDark);
    // Key head center hole
    c.drawCircle(const Offset(104, 108), 13, Paint()..color = const Color(0xFFF0FAF4));

    // Key shank (horizontal bar)
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(125, 100, 110, 16), const Radius.circular(8)),
      Paint()..color = _primary,
    );

    // Key tooth 1
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(196, 116, 14, 20), const Radius.circular(4)),
      Paint()..color = _primary,
    );

    // Key tooth 2
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(220, 116, 11, 14), const Radius.circular(3.5)),
      Paint()..color = _primary,
    );

    // Key shank highlight
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(130, 101, 100, 5), const Radius.circular(2.5)),
      Paint()..color = _primaryDark.withOpacity(0.35),
    );

    // Key head highlight arc
    final highlightPaint = Paint()
      ..color = _primaryDark.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    c.drawArc(
      const Rect.fromLTWH(74, 78, 60, 60),
      3.14159 + 0.2,
      0.9,
      false,
      highlightPaint,
    );

    // Shield icon (centered below key)
    _drawShield(c, 118, 148);

    // Sparkles
    _star4(c, Paint()..color = _yellow, 228, 34, 8);
    _star4(c, Paint()..color = _yellow.withOpacity(0.85), 46, 56, 7);
    _star4(c, Paint()..color = _yellow.withOpacity(0.7), 240, 148, 5.5);

    // Cross sparkles
    _cross(c, _primary, 34, 126, 6, 2.5);
    _cross(c, _yellow, 156, 25, 5, 2.2);

    // Dot accents
    c.drawCircle(const Offset(50, 158), 5, Paint()..color = _orange.withOpacity(0.65));
    c.drawCircle(const Offset(242, 80), 4, Paint()..color = _blue.withOpacity(0.7));
    c.drawCircle(const Offset(246, 104), 3, Paint()..color = _primary.withOpacity(0.5));
    c.drawCircle(const Offset(36, 90), 3.5, Paint()..color = _teal.withOpacity(0.8));

    // Outer dashed orbit ring
    _dashedCircle(c, 140, 108, 95, _primary, 1, 4, 6);
  }

  void _drawShield(Canvas c, double x, double y) {
    // Shield outer shape
    final shieldPath = Path()
      ..moveTo(x + 22, y + 4)
      ..lineTo(x + 38, y + 10)
      ..lineTo(x + 38, y + 22)
      ..cubicTo(x + 38, y + 30, x + 22, y + 38, x + 22, y + 38)
      ..cubicTo(x + 22, y + 38, x + 6, y + 30, x + 6, y + 22)
      ..lineTo(x + 6, y + 10)
      ..close();
    c.drawPath(shieldPath, Paint()..color = _primary);

    // Shield inner shape
    final innerPath = Path()
      ..moveTo(x + 22, y + 10)
      ..lineTo(x + 32, y + 14)
      ..lineTo(x + 32, y + 23)
      ..cubicTo(x + 32, y + 28, x + 22, y + 33, x + 22, y + 33)
      ..cubicTo(x + 22, y + 33, x + 12, y + 28, x + 12, y + 23)
      ..lineTo(x + 12, y + 14)
      ..close();
    c.drawPath(innerPath, Paint()..color = _primaryDark);

    // Checkmark
    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final checkPath = Path()
      ..moveTo(x + 15, y + 22)
      ..lineTo(x + 19, y + 26)
      ..lineTo(x + 29, y + 16);
    c.drawPath(checkPath, checkPaint);
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
