import 'package:flutter/material.dart';
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

class BottlePainter extends CustomPainter {
  final Color color;
  BottlePainter({this.color = AppColors.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Bottle body
    final bodyRect = Rect.fromLTRB(size.width * 0.25, size.height * 0.4, size.width * 0.75, size.height * 0.95);
    final bodyRRect = RRect.fromRectAndRadius(bodyRect, Radius.circular(size.width * 0.1));
    canvas.drawRRect(bodyRRect, paint);

    // Neck
    final neckPath = Path()
      ..moveTo(size.width * 0.4, size.height * 0.4)
      ..lineTo(size.width * 0.4, size.height * 0.15)
      ..lineTo(size.width * 0.6, size.height * 0.15)
      ..lineTo(size.width * 0.6, size.height * 0.4);
    canvas.drawPath(neckPath, paint);

    // Cap
    canvas.drawLine(Offset(size.width * 0.35, size.height * 0.1), Offset(size.width * 0.65, size.height * 0.1), paint);

    // Label
    canvas.drawLine(Offset(size.width * 0.4, size.height * 0.6), Offset(size.width * 0.6, size.height * 0.6), paint);
    canvas.drawLine(Offset(size.width * 0.4, size.height * 0.75), Offset(size.width * 0.6, size.height * 0.75), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DnaHelixPainter extends CustomPainter {
  final Color color;
  DnaHelixPainter({this.color = AppColors.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    // Helix strand 1
    final path1 = Path()
      ..moveTo(size.width * 0.2, size.height * 0.1)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.3, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.7, size.width * 0.8, size.height * 0.9);
      
    // Helix strand 2
    final path2 = Path()
      ..moveTo(size.width * 0.8, size.height * 0.1)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.3, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.7, size.width * 0.2, size.height * 0.9);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);

    // Crossbars
    canvas.drawLine(Offset(size.width * 0.35, size.height * 0.2), Offset(size.width * 0.65, size.height * 0.2), paint);
    canvas.drawLine(Offset(size.width * 0.45, size.height * 0.35), Offset(size.width * 0.55, size.height * 0.35), paint);
    canvas.drawLine(Offset(size.width * 0.45, size.height * 0.65), Offset(size.width * 0.55, size.height * 0.65), paint);
    canvas.drawLine(Offset(size.width * 0.35, size.height * 0.8), Offset(size.width * 0.65, size.height * 0.8), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppleLogoPainter extends CustomPainter {
  final Color color;
  AppleLogoPainter({this.color = AppColors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Body of the apple
    final appleBody = Path()
      ..moveTo(size.width * 0.5, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.2, size.width * 0.1, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.95, size.width * 0.45, size.height * 0.95)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.95, size.width * 0.5, size.height * 0.88)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.95, size.width * 0.55, size.height * 0.95)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.95, size.width * 0.9, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.2, size.width * 0.5, size.height * 0.25);

    final bite = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width * 0.95, size.height * 0.5), radius: size.width * 0.22));

    final finalApple = Path.combine(PathOperation.difference, appleBody, bite);
    canvas.drawPath(finalApple, paint);

    // Leaf
    final leaf = Path()
      ..moveTo(size.width * 0.55, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.2, size.width * 0.7, size.height * 0.02)
      ..quadraticBezierTo(size.width * 0.55, size.height * 0.02, size.width * 0.55, size.height * 0.2);
    
    canvas.drawPath(leaf, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
