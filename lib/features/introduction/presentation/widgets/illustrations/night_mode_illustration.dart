import 'package:flutter/material.dart';

/// Flat vector night mode / moon illustration for Slide 4.
class NightModeIllustration extends StatelessWidget {
  const NightModeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 240,
      child: CustomPaint(painter: _NightModePainter()),
    );
  }
}

class _NightModePainter extends CustomPainter {
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
      Paint()..color = _primaryDark.withOpacity(0.14),
    );

    // Background medallion
    c.drawCircle(const Offset(140, 108), 82, Paint()..color = _primaryContainer);
    c.drawCircle(
      const Offset(140, 108),
      82,
      Paint()
        ..color = const Color(0xFFC8F0D6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _dashedCircle(c, 140, 108, 66, const Color(0xFFC8F0D6), 1.5, 5, 4);

    // Moon (crescent) — large circle minus smaller offset circle
    _drawMoon(c, 140, 100, 48, 20);

    // Stars around moon
    _star(c, 188, 68, 6);
    _star(c, 200, 95, 4);
    _star(c, 178, 55, 3.5);
    _star(c, 215, 75, 3);
    _star(c, 164, 48, 5);

    // Phone outline showing dark mode
    _drawPhoneOutline(c, 96, 82);

    // Sparkles
    _star4(c, Paint()..color = _yellow, 228, 36, 8);
    _star4(c, Paint()..color = _yellow.withOpacity(0.8), 46, 58, 6);
    c.drawCircle(const Offset(50, 158), 5, Paint()..color = const Color(0xFFFF8A65).withOpacity(0.65));
    c.drawCircle(const Offset(242, 80), 4, Paint()..color = const Color(0xFF64B5F6).withOpacity(0.7));

    _cross(c, _yellow, 156, 22, 5, 2.2);
    _cross(c, _primary, 34, 126, 6, 2.5);

    _dashedCircle(c, 140, 108, 95, _primary, 1, 4, 6);
  }

  void _drawMoon(Canvas c, double cx, double cy, double r, double offsetX) {
    // Draw full circle first, then mask with background-colored circle to create crescent
    final moonPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    final maskPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx + offsetX, cy - 10), radius: r * 0.78));

    final combined = Path.combine(PathOperation.difference, moonPath, maskPath);
    c.drawPath(combined, Paint()..color = _primary);
  }

  void _star(Canvas c, double cx, double cy, double r) {
    final path = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r * 0.3, cy - r * 0.3)
      ..lineTo(cx + r, cy)
      ..lineTo(cx + r * 0.3, cy + r * 0.3)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r * 0.3, cy + r * 0.3)
      ..lineTo(cx - r, cy)
      ..lineTo(cx - r * 0.3, cy - r * 0.3)
      ..close();
    c.drawPath(path, Paint()..color = _primaryDark.withOpacity(0.6));
  }

  void _drawPhoneOutline(Canvas c, double x, double y) {
    // Small phone silhouette showing dark screen
    final paint = Paint()
      ..color = _primaryDark.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    c.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 44, 72), const Radius.circular(8)),
      paint,
    );
    // Dark screen
    c.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x + 4, y + 10, 36, 52), const Radius.circular(4)),
      Paint()..color = _primaryDark.withOpacity(0.15),
    );
    // Text lines on screen
    final linePaint = Paint()
      ..color = _primary.withOpacity(0.4)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    c.drawLine(Offset(x + 10, y + 22), Offset(x + 34, y + 22), linePaint);
    c.drawLine(Offset(x + 10, y + 30), Offset(x + 34, y + 30), linePaint);
    c.drawLine(Offset(x + 10, y + 38), Offset(x + 28, y + 38), linePaint);
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
