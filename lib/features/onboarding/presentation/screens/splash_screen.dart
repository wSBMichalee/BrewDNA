import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _waveController;

  late Animation<double> _outlineOpacity;
  late Animation<double> _fillHeight;
  late Animation<double> _elasticSettle;
  late Animation<double> _fadeTransition;
  late Animation<double> _shineSweep;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    _mainController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2900),
    );

    _outlineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _fillHeight = Tween<double>(begin: 0, end: 1.05).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.13, 0.69, curve: Curves.easeInOut),
      ),
    );

    _elasticSettle = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.69, 0.82, curve: Curves.elasticOut),
      ),
    );

    _shineSweep = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.70, 0.90, curve: Curves.easeInOut),
      ),
    );

    _fadeTransition = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.89, 1.0, curve: Curves.easeOut),
      ),
    );

    _mainController.forward().then((_) async {
      if (mounted) {
        // Trigger a fresh session check
        await context.read<AuthCubit>().checkSession();
        
        if (!mounted) return;
        final isAuthenticated = context.read<AuthCubit>().state.isAuthenticated;
        
        if (isAuthenticated) {
          context.go('/main/discover');
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
                          'BrewDNA',
                          style: AppTypography.largeTitle.copyWith(
                            fontSize: 64,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = AppColors.accentTint.withValues(
                                alpha: 0.3,
                              ),
                          ),
                        ),
                      ),
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [AppColors.accentDeep, AppColors.accent],
                          ).createShader(bounds);
                        },
                        child: AnimatedBuilder(
                          animation: _waveController,
                          builder: (context, child) {
                            return ClipPath(
                              clipper: _LiquidClipper(
                                fillPercent:
                                    _fillHeight.value -
                                    (_elasticSettle.value * 0.05),
                                wavePhase: _waveController.value * 2 * math.pi,
                              ),
                              child: Stack(
                                children: [
                                  Text(
                                    'BrewDNA',
                                    style: AppTypography.largeTitle.copyWith(
                                      fontSize: 64,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: _BubblesPainter(
                                        fillPercent: _fillHeight.value,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Shine Sweep Layer
                      AnimatedBuilder(
                        animation: _shineSweep,
                        builder: (context, child) {
                          if (_shineSweep.value <= -1.0 || _shineSweep.value >= 2.0) {
                            return const SizedBox.shrink();
                          }
                          return ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment(-1.5 + _shineSweep.value, -1.0),
                                end: Alignment(0.5 + _shineSweep.value, 1.0),
                                colors: [
                                  Colors.transparent,
                                  AppColors.white.withValues(alpha: 0.6),
                                  Colors.transparent,
                                ],
                                stops: const [0.4, 0.5, 0.6],
                              ).createShader(bounds);
                            },
                            child: Text(
                              'BrewDNA',
                              style: AppTypography.largeTitle.copyWith(
                                fontSize: 64,
                                color: AppColors.white,
                              ),
                            ),
                          );
                        },
                      ),
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
      final wave =
          math.sin((i / size.width * 2 * math.pi) + wavePhase) * waveHeight;
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
  final double fillPercent;

  _BubblesPainter({required this.fillPercent});

  @override
  void paint(Canvas canvas, Size size) {
    if (fillPercent <= 0.0 || fillPercent >= 1.0) return;

    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Use a fixed random seed for consistent bubble positions
    final random = math.Random(123);
    final int bubbleCount = 8;
    
    for (int i = 0; i < bubbleCount; i++) {
      final startX = random.nextDouble() * size.width;
      final speed = 0.5 + random.nextDouble() * 1.5; 
      final spawnTime = random.nextDouble() * 0.7; // Spawns when fill is between 0 and 0.7
      
      if (fillPercent > spawnTime) {
        final lifeTime = (fillPercent - spawnTime) * speed;
        final waveHeight = size.height * (1.0 - fillPercent);
        
        // Starts below wave, moves up
        final currentY = waveHeight + 20 - (lifeTime * size.height * 0.8);
        final wobble = math.sin(lifeTime * math.pi * 6 + i) * 4;
        final currentX = startX + wobble;
        
        // Fade out
        final opacity = (1.0 - lifeTime * 1.5).clamp(0.0, 0.6);
        
        if (opacity > 0 && currentY > 0) {
          paint.color = AppColors.white.withValues(alpha: opacity);
          final radius = 2.0 + random.nextDouble() * 4.0;
          canvas.drawCircle(Offset(currentX, currentY), radius, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_BubblesPainter oldDelegate) => oldDelegate.fillPercent != fillPercent;
}
