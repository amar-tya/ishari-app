import 'package:flutter/material.dart';

/// Flat vector bookmark illustration for Slide 3 (Simpan Favorit).
class BookmarkIllustration extends StatelessWidget {
  const BookmarkIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 240,
      child: CustomPaint(painter: _BookmarkPainter()),
    );
  }
}

class _BookmarkPainter extends CustomPainter {
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

    // Three bookmark tabs
    _bookmark(c, 102, 58, 36, 80, _teal);
    _bookmark(c, 128, 50, 36, 88, _primaryDark);
    _bookmark(c, 154, 58, 36, 80, _primary);

    // Heart on main bookmark
    _heart(c, 172, 118);

    // Star on left bookmark
    _star(c, 120, 90);

    // Sparkles
    _star4(c, Paint()..color = _yellow, 228, 36, 8);
    _star4(c, Paint()..color = _yellow.withOpacity(0.8), 46, 58, 6);
    c.drawCircle(const Offset(50, 158), 5, Paint()..color = const Color(0xFFFF8A65).withOpacity(0.65));
    c.drawCircle(const Offset(242, 80), 4, Paint()..color = const Color(0xFF64B5F6).withOpacity(0.7));

    _cross(c, _yellow, 156, 22, 5, 2.2);
    _cross(c, _primary, 34, 126, 6, 2.5);

    _dashedCircle(c, 140, 108, 95, _primary, 1, 4, 6);
  }

  void _bookmark(Canvas c, double x, double y, double w, double h, Color color) {
    final path = Path()
      ..moveTo(x, y)
      ..lineTo(x + w, y)
      ..lineTo(x + w, y + h)
      ..lineTo(x + w / 2, y + h - 14)
      ..lineTo(x, y + h)
      ..close();
    c.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
  }

  void _heart(Canvas c, double cx, double cy) {
    final paint = Paint()..color = Colors.white.withOpacity(0.9);
    final path = Path()
      ..moveTo(cx, cy + 8)
      ..cubicTo(cx - 12, cy - 2, cx - 20, cy + 4, cx - 12, cy + 14)
      ..lineTo(cx, cy + 22)
      ..lineTo(cx + 12, cy + 14)
      ..cubicTo(cx + 20, cy + 4, cx + 12, cy - 2, cx, cy + 8)
      ..close();
    c.drawPath(path, paint);
  }

  void _star(Canvas c, double cx, double cy) {
    final path = Path()
      ..moveTo(cx, cy - 8)
      ..lineTo(cx + 2, cy - 3)
      ..lineTo(cx + 7, cy - 3)
      ..lineTo(cx + 3, cy + 1)
      ..lineTo(cx + 5, cy + 6)
      ..lineTo(cx, cy + 3)
      ..lineTo(cx - 5, cy + 6)
      ..lineTo(cx - 3, cy + 1)
      ..lineTo(cx - 7, cy - 3)
      ..lineTo(cx - 2, cy - 3)
      ..close();
    c.drawPath(path, Paint()..color = Colors.white.withOpacity(0.8));
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
