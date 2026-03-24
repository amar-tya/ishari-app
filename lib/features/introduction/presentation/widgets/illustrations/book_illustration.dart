import 'package:flutter/material.dart';

/// Flat vector book illustration for Slide 1 (Baca Shalawat).
/// Faithfully recreates the SVG from the design mockup.
class BookIllustration extends StatelessWidget {
  const BookIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 240,
      child: CustomPaint(painter: _BookPainter()),
    );
  }
}

class _BookPainter extends CustomPainter {
  static const _primary = Color(0xFF51C878);
  static const _primaryContainer = Color(0xFFE8F8EE);
  static const _teal = Color(0xFFB2DFDB);
  static const _yellow = Color(0xFFFFD54F);
  static const _orange = Color(0xFFFF8A65);
  static const _blue = Color(0xFF64B5F6);
  static const _pageBorder = Color(0xFFC8E6C9);

  @override
  void paint(Canvas canvas, Size size) {
    // Scale factor (viewBox 300x240)
    final sx = size.width / 300;
    final sy = size.height / 240;

    void sc(Canvas c, void Function(Canvas c) fn) {
      c.save();
      c.scale(sx, sy);
      fn(c);
      c.restore();
    }

    sc(canvas, (c) {
      _drawShadow(c);
      _drawLeftPage(c);
      _drawRightPage(c);
      _drawSpine(c);
      _drawTopBinding(c);
      _drawLeftPageLines(c);
      _drawRightPageLines(c);
      _drawSparkles(c);
    });
  }

  void _drawShadow(Canvas c) {
    final paint = Paint()
      ..color = const Color(0xFF3DAF5E).withOpacity(0.12)
      ..style = PaintingStyle.fill;
    c.drawOval(const Rect.fromLTWH(60, 208, 180, 24), paint);
  }

  void _drawLeftPage(Canvas c) {
    final path = Path()
      ..moveTo(148, 48)
      ..cubicTo(130, 50, 80, 55, 52, 70)
      ..lineTo(52, 190)
      ..cubicTo(80, 178, 130, 174, 148, 172)
      ..close();

    c.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    c.drawPath(
      path,
      Paint()
        ..color = _pageBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Left spine shadow
    final shadow = Path()
      ..moveTo(148, 48)
      ..cubicTo(142, 60, 140, 100, 140, 130)
      ..cubicTo(140, 158, 142, 172, 148, 172)
      ..close();
    c.drawPath(
      shadow,
      Paint()
        ..color = const Color(0xFFE0F2E9)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawRightPage(Canvas c) {
    final path = Path()
      ..moveTo(152, 48)
      ..cubicTo(170, 50, 220, 55, 248, 70)
      ..lineTo(248, 190)
      ..cubicTo(220, 178, 170, 174, 152, 172)
      ..close();

    c.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    c.drawPath(
      path,
      Paint()
        ..color = _pageBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Right spine shadow
    final shadow = Path()
      ..moveTo(152, 48)
      ..cubicTo(158, 60, 160, 100, 160, 130)
      ..cubicTo(160, 158, 158, 172, 152, 172)
      ..close();
    c.drawPath(
      shadow,
      Paint()
        ..color = const Color(0xFFE0F2E9)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawSpine(Canvas c) {
    // Center spine line
    final linePaint = Paint()
      ..color = _pageBorder
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    c.drawLine(const Offset(150, 48), const Offset(150, 172), linePaint);

    // Top binding arc
    final bindingPath = Path()
      ..moveTo(52, 70)
      ..cubicTo(90, 58, 130, 50, 148, 48)
      ..lineTo(152, 48)
      ..cubicTo(170, 50, 210, 58, 248, 70);
    c.drawPath(
      bindingPath,
      Paint()
        ..color = _primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawTopBinding(Canvas c) {}

  void _drawLeftPageLines(Canvas c) {
    final greenPaint = Paint()
      ..color = _primary
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final tealPaint = Paint()
      ..color = _teal
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Line 1
    _wavyLine(c, greenPaint, [
      68,
      95,
      78,
      90,
      92,
      98,
      102,
      93,
      112,
      88,
      122,
      95,
      132,
      91,
    ]);
    // Line 2
    _wavyLine(c, tealPaint, [
      70,
      112,
      82,
      107,
      96,
      115,
      108,
      110,
      118,
      105,
      128,
      112,
      138,
      108,
    ]);
    // Line 3
    _wavyLine(c, greenPaint, [
      68,
      129,
      80,
      124,
      94,
      132,
      106,
      127,
      116,
      122,
      127,
      129,
      136,
      126,
    ]);
    // Line 4
    _shortLine(c, tealPaint, [72, 146, 82, 141, 94, 149, 108, 144]);

    // Dots
    _dot(c, 75, 162);
    _dot(c, 88, 162);
    _dot(c, 101, 162);
  }

  void _drawRightPageLines(Canvas c) {
    final greenPaint = Paint()
      ..color = _primary
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final tealPaint = Paint()
      ..color = _teal
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    _wavyLine(c, greenPaint, [
      168,
      95,
      178,
      90,
      192,
      98,
      202,
      93,
      212,
      88,
      222,
      95,
      232,
      91,
    ]);
    _wavyLine(c, tealPaint, [
      165,
      112,
      177,
      107,
      191,
      115,
      203,
      110,
      213,
      105,
      223,
      112,
      235,
      108,
    ]);
    _wavyLine(c, greenPaint, [
      168,
      129,
      180,
      124,
      194,
      132,
      206,
      127,
      216,
      122,
      227,
      129,
      234,
      126,
    ]);
    _shortLine(c, tealPaint, [170, 146, 180, 141, 196, 149, 210, 144]);

    _dot(c, 175, 162);
    _dot(c, 188, 162);
    _dot(c, 201, 162);

    // Medallion on right page
    c.drawCircle(
      const Offset(210, 160),
      12,
      Paint()
        ..color = _primaryContainer
        ..style = PaintingStyle.fill,
    );
    c.drawCircle(
      const Offset(210, 160),
      12,
      Paint()
        ..color = _primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // Star in medallion
    _drawStar(c, 210, 160);
  }

  void _wavyLine(Canvas c, Paint paint, List<double> pts) {
    final path = Path()..moveTo(pts[0], pts[1]);
    for (var i = 2; i < pts.length - 2; i += 4) {
      path.quadraticBezierTo(pts[i], pts[i + 1], pts[i + 2], pts[i + 3]);
    }
    c.drawPath(path, paint);
  }

  void _shortLine(Canvas c, Paint paint, List<double> pts) {
    final path = Path()..moveTo(pts[0], pts[1]);
    for (var i = 2; i < pts.length - 2; i += 4) {
      path.quadraticBezierTo(pts[i], pts[i + 1], pts[i + 2], pts[i + 3]);
    }
    c.drawPath(path, paint);
  }

  void _dot(Canvas c, double x, double y) {
    c.drawCircle(
      Offset(x, y),
      2.5,
      Paint()
        ..color = _primaryContainer
        ..style = PaintingStyle.fill,
    );
    c.drawCircle(
      Offset(x, y),
      2.5,
      Paint()
        ..color = _primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawStar(Canvas c, double cx, double cy) {
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
    c.drawPath(
      path,
      Paint()
        ..color = _primary.withOpacity(0.6)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawSparkles(Canvas c) {
    final yellowPaint = Paint()
      ..color = _yellow
      ..style = PaintingStyle.fill;
    final linePaintYellow = Paint()
      ..color = _yellow
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final linePaintGreen = Paint()
      ..color = _primary
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Star top-left
    _star4(c, yellowPaint, 32, 52, 8);
    // Star top-right
    _star4(c, yellowPaint, 268, 44, 6.5);
    // Small star upper-right
    _star4(
      c,
      Paint()
        ..color = _yellow.withOpacity(0.7)
        ..style = PaintingStyle.fill,
      256,
      80,
      5,
    );

    // Dot sparkles
    c.drawCircle(
      const Offset(44, 82),
      4,
      Paint()
        ..color = _yellow.withOpacity(0.8)
        ..style = PaintingStyle.fill,
    );
    c.drawCircle(
      const Offset(260, 108),
      3,
      Paint()
        ..color = _orange.withOpacity(0.7)
        ..style = PaintingStyle.fill,
    );
    c.drawCircle(
      const Offset(38, 140),
      3,
      Paint()
        ..color = _blue.withOpacity(0.6)
        ..style = PaintingStyle.fill,
    );

    // Cross sparkle top-center-left
    c.drawLine(const Offset(90, 28), const Offset(90, 38), linePaintYellow);
    c.drawLine(const Offset(85, 33), const Offset(95, 33), linePaintYellow);
    // Cross sparkle top-right
    c.drawLine(const Offset(220, 22), const Offset(220, 30), linePaintGreen);
    c.drawLine(const Offset(216, 26), const Offset(224, 26), linePaintGreen);

    // Dashed circle decorations
    _dashedCircle(c, 262, 134, 8, const Color(0xFF51C878), 1.5, 3, 3);
    _dashedCircle(c, 36, 110, 6, _teal, 1.5, 2.5, 2.5);
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

  void _dashedCircle(
    Canvas c,
    double cx,
    double cy,
    double r,
    Color color,
    double strokeWidth,
    double dashLen,
    double gapLen,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    final pathMetrics = path.computeMetrics().first;
    var distance = 0.0;
    final dashPath = Path();
    while (distance < pathMetrics.length) {
      dashPath.addPath(
        pathMetrics.extractPath(distance, distance + dashLen),
        Offset.zero,
      );
      distance += dashLen + gapLen;
    }
    c.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
