import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _waveController;

  late Animation<double> _outlineOpacity;
  late Animation<double> _fillHeight;
  late Animation<double> _elasticSettle;
  late Animation<double> _bubblesOpacity;
  late Animation<double> _fadeTransition;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    
    _mainController = AnimationController(vsync: this, duration: Duration(milliseconds: 2900));

    _outlineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainController, curve: Interval(0.0, 0.2, curve: Curves.easeIn)),
    );

    _fillHeight = Tween<double>(begin: 0, end: 0.45).animate(
      CurvedAnimation(parent: _mainController, curve: Interval(0.13, 0.69, curve: Curves.easeInOut)),
    );

    _elasticSettle = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainController, curve: Interval(0.69, 0.82, curve: Curves.elasticOut)),
    );

    _bubblesOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: 50),
    ]).animate(CurvedAnimation(parent: _mainController, curve: Interval(0.55, 0.75)));

    _fadeTransition = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _mainController, curve: Interval(0.89, 1.0, curve: Curves.easeOut)),
    );

    _mainController.forward().then((_) {
      if (mounted) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          context.go('/main/scan');
        } else {
          context.go('/onboarding/intro');
        }
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeTransition.value,
            child: Stack(
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                  Opacity(
                    opacity: _outlineOpacity.value,
                    child: Text(
                      'HopIQ',
                      style: AppTypography.largeTitle.copyWith(
                        fontSize: 64,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = AppColors.labelSecondary.withOpacity(0.3),
                      ),
                    ),
                  ),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [AppColors.accent, AppColors.accent],
                      ).createShader(bounds);
                    },
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return ClipPath(
                          clipper: _LiquidClipper(
                            fillPercent: _fillHeight.value - (_elasticSettle.value * 0.05),
                            wavePhase: _waveController.value * 2 * math.pi,
                          ),
                          child: Stack(
                            children: [
                              Text(
                                'HopIQ',
                                style: AppTypography.largeTitle.copyWith(
                                  fontSize: 64,
                                  color: AppColors.white,
                                ),
                              ),
                              if (_bubblesOpacity.value > 0)
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: _bubblesOpacity.value,
                                    child: CustomPaint(
                                      painter: _BubblesPainter(
                                        progress: _mainController.value,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: AppSpacings.s48 + MediaQuery.of(context).padding.bottom,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(false),
                  SizedBox(width: AppSpacings.s8),
                  _buildDot(true),
                  SizedBox(width: AppSpacings.s8),
                  _buildDot(true),
                ],
              ),
            ),
          ],
        ),
      );
    },
  ),
);
}

Widget _buildDot(bool faded) {
  return Container(
    width: 6,
    height: 6,
    decoration: BoxDecoration(
      color: faded ? AppColors.accent.withValues(alpha: 0.3) : AppColors.accent,
      shape: BoxShape.circle,
    ),
  );
}
}

class _LiquidClipper extends CustomClipper<Path> {
  final double fillPercent;
  final double wavePhase;

  _LiquidClipper({required this.fillPercent, required this.wavePhase});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (fillPercent <= 0.0) return path;

    final waveHeight = size.height * 0.05;
    final baseHeight = size.height * (1 - fillPercent);

    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);

    for (double i = 0; i <= size.width; i++) {
      final wave = math.sin((i / size.width * 2 * math.pi) + wavePhase) * waveHeight;
      path.lineTo(i, baseHeight + wave);
    }

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_LiquidClipper oldClipper) => true;
}

class _BubblesPainter extends CustomPainter {
  final double progress;

  _BubblesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentTint
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    
    for (int i = 0; i < 6; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = size.height * 0.8 + random.nextDouble() * 20;
      final endY = size.height * 0.2;
      
      double localProgress = ((progress - 0.55) / 0.2).clamp(0.0, 1.0);
      final currentY = startY - ((startY - endY) * localProgress);
      final currentX = startX + math.sin(localProgress * math.pi * 2 + i) * 5;
      
      canvas.drawCircle(Offset(currentX, currentY), 2.0 + random.nextDouble() * 3, paint);
    }
  }

  @override
  bool shouldRepaint(_BubblesPainter oldDelegate) => oldDelegate.progress != progress;
}
