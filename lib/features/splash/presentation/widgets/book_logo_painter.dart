import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Circular green book logo with music notes.
/// Matches the splash screen mockup design.
class BookLogoWidget extends StatelessWidget {
  const BookLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: CustomPaint(painter: _BookLogoPainter()),
    );
  }
}

class _BookLogoPainter extends CustomPainter {
  static const _primary = Color(0xFF51C878);
  static const _primaryDark = Color(0xFF3DA85F);
  static const _pageLeft = Color(0xFFECFDF5);

  @override
  void paint(Canvas canvas, Size size) {
    // Viewport is 130×130 — scale to actual canvas size.
    final sx = size.width / 130;
    final sy = size.height / 130;
    canvas
      ..save()
      ..scale(sx, sy);
    _draw(canvas);
    canvas.restore();
  }

  void _draw(Canvas canvas) {
    _drawShadow(canvas);
    _drawBackground(canvas);
    _drawInnerRing(canvas);
    _drawLeftPage(canvas);
    _drawLeftPageLines(canvas);
    _drawRightPage(canvas);
    _drawRightPageLines(canvas);
    _drawMusicNotes(canvas);
    _drawSpine(canvas);
    _drawCoverArc(canvas);
    _drawBindingArc(canvas);
  }

  // ── Background & ring ──────────────────────────────────────────────────

  void _drawShadow(Canvas canvas) {
    canvas.drawCircle(
      const Offset(65, 71),
      58,
      Paint()
        ..color = _primaryDark.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  void _drawBackground(Canvas canvas) {
    const rect = Rect.fromLTWH(7, 7, 116, 116);
    final shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [_primary, _primaryDark],
    ).createShader(rect);
    canvas.drawCircle(
      const Offset(65, 65),
      58,
      Paint()..shader = shader,
    );
  }

  void _drawInnerRing(Canvas canvas) {
    canvas.drawCircle(
      const Offset(65, 65),
      52,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  // ── Book pages ─────────────────────────────────────────────────────────

  void _drawLeftPage(Canvas canvas) {
    final path = Path()
      ..moveTo(22, 82)
      ..lineTo(22, 42)
      ..quadraticBezierTo(22, 34, 30, 32)
      ..quadraticBezierTo(44, 29, 60, 32)
      ..lineTo(60, 88)
      ..quadraticBezierTo(44, 85, 30, 88)
      ..quadraticBezierTo(22, 88, 22, 82)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = _pageLeft
        ..style = PaintingStyle.fill,
    );
  }

  void _drawLeftPageLines(Canvas canvas) {
    const lines = [
      [30.0, 42.0, 55.0, 42.0, 0.50],
      [30.0, 50.0, 55.0, 50.0, 0.40],
      [30.0, 58.0, 55.0, 58.0, 0.35],
      [30.0, 66.0, 50.0, 66.0, 0.30],
      [30.0, 74.0, 55.0, 74.0, 0.25],
    ];
    for (final l in lines) {
      canvas.drawLine(
        Offset(l[0], l[1]),
        Offset(l[2], l[3]),
        Paint()
          ..color = _primary.withValues(alpha: l[4])
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawRightPage(Canvas canvas) {
    final path = Path()
      ..moveTo(108, 82)
      ..lineTo(108, 42)
      ..quadraticBezierTo(108, 34, 100, 32)
      ..quadraticBezierTo(86, 29, 70, 32)
      ..lineTo(70, 88)
      ..quadraticBezierTo(86, 85, 100, 88)
      ..quadraticBezierTo(108, 88, 108, 82)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  void _drawRightPageLines(Canvas canvas) {
    const lines = [
      [75.0, 42.0, 100.0, 42.0, 0.10],
      [75.0, 50.0, 100.0, 50.0, 0.08],
      [75.0, 58.0, 100.0, 58.0, 0.08],
      [75.0, 66.0, 95.0, 66.0, 0.07],
    ];
    for (final l in lines) {
      canvas.drawLine(
        Offset(l[0], l[1]),
        Offset(l[2], l[3]),
        Paint()
          ..color = Colors.black.withValues(alpha: l[4])
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  // ── Music notes ────────────────────────────────────────────────────────

  void _drawMusicNotes(Canvas canvas) {
    _drawNote(canvas, 94, 75, 5, 3.5, 98.5, 72.5, 98.5, 60, _primary, 1);
    _drawNote(
      canvas,
      85,
      78,
      4,
      2.8,
      89,
      75.8,
      89,
      65,
      _primaryDark,
      0.75,
    );
  }

  void _drawNote(
    Canvas canvas,
    double hx,
    double hy,
    double rx,
    double ry,
    double stemX1,
    double stemY1,
    double stemX2,
    double stemY2,
    Color color,
    double opacity,
  ) {
    final fillPaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final flag = Path()
      ..moveTo(stemX2, stemY2)
      ..quadraticBezierTo(
        stemX2 + 8,
        stemY2 + 2,
        stemX2 + 6,
        stemY2 + 8,
      );

    // Note head (rotated -12°) → stem → flag arc
    canvas
      ..save()
      ..translate(hx, hy)
      ..rotate(-12 * math.pi / 180)
      ..drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: rx * 2,
          height: ry * 2,
        ),
        fillPaint,
      )
      ..restore()
      ..drawLine(Offset(stemX1, stemY1), Offset(stemX2, stemY2), strokePaint)
      ..drawPath(flag, strokePaint);
  }

  // ── Spine & binding ────────────────────────────────────────────────────

  void _drawSpine(Canvas canvas) {
    final path = Path()
      ..moveTo(65, 30)
      ..cubicTo(63, 50, 63, 70, 65, 90);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawCoverArc(Canvas canvas) {
    final path = Path()
      ..moveTo(30, 32)
      ..quadraticBezierTo(44, 27, 65, 30)
      ..quadraticBezierTo(86, 27, 100, 32);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawBindingArc(Canvas canvas) {
    final path = Path()
      ..moveTo(22, 84)
      ..quadraticBezierTo(44, 90, 65, 88)
      ..quadraticBezierTo(86, 90, 108, 84);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
