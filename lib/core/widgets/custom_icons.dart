import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

class BeerMugPainter extends CustomPainter {
  final Color color;
  BeerMugPainter({this.color = AppColors.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Mug body
    final rect = Rect.fromLTRB(
      size.width * 0.2, size.height * 0.3,
      size.width * 0.7, size.height * 0.9
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.1));
    canvas.drawRRect(rrect, paint);

    // Handle
    final handlePath = Path()
      ..moveTo(size.width * 0.7, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.95, size.height * 0.45, size.width * 0.95, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.95, size.height * 0.75, size.width * 0.7, size.height * 0.75);
    canvas.drawPath(handlePath, paint);

    // Foam
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.25), size.width * 0.15, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.2), size.width * 0.18, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.25), size.width * 0.15, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FruitBranchPainter extends CustomPainter {
  final Color color;
  FruitBranchPainter({this.color = AppColors.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Branch
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width * 0.8, size.height * 0.2);
    canvas.drawPath(path, paint);

    // Leaves
    final leaf1 = Path()
      ..moveTo(size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.4, size.width * 0.4, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.3, size.width * 0.5, size.height * 0.5);
    canvas.drawPath(leaf1, fillPaint);

    // Fruit (berries)
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.6), size.width * 0.12, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.5), size.width * 0.1, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WheatEarPainter extends CustomPainter {
  final Color color;
  WheatEarPainter({this.color = AppColors.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Stem
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.9), Offset(size.width * 0.5, size.height * 0.1), paint);

    // Grains
    void drawGrain(double y, double dx) {
      final path = Path()
        ..moveTo(size.width * 0.5, size.height * y)
        ..quadraticBezierTo(size.width * (0.5 + dx), size.height * (y - 0.1), size.width * (0.5 + dx * 0.5), size.height * (y - 0.2))
        ..quadraticBezierTo(size.width * 0.5, size.height * (y - 0.15), size.width * 0.5, size.height * y);
      canvas.drawPath(path, fillPaint);
    }

    drawGrain(0.8, 0.3);
    drawGrain(0.7, -0.3);
    drawGrain(0.6, 0.3);
    drawGrain(0.5, -0.3);
    drawGrain(0.4, 0.3);
    drawGrain(0.3, -0.3);
    
    // Top grain
    final topPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.55, size.height * 0.1, size.width * 0.5, size.height * 0.05)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.1, size.width * 0.5, size.height * 0.2);
    canvas.drawPath(topPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
