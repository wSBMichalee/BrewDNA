import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/presentation/bloc/scan_cubit.dart';
import '../../../beer/presentation/bloc/scan_state.dart';
import 'scan_result_sheet.dart';

class ScanningAnalyzingScreen extends StatefulWidget {
  final Uint8List imageBytes;
  
  const ScanningAnalyzingScreen({super.key, required this.imageBytes});

  @override
  State<ScanningAnalyzingScreen> createState() => _ScanningAnalyzingScreenState();
}

class _ScanningAnalyzingScreenState extends State<ScanningAnalyzingScreen> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late final AnimationController _labelsController;
  late final Animation<double> _label1Animation;
  late final Animation<double> _label2Animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _labelsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    
    _label1Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 10),
    ]).animate(CurvedAnimation(parent: _labelsController, curve: const Interval(0.0, 0.5)));
    
    _label2Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 10),
    ]).animate(CurvedAnimation(parent: _labelsController, curve: const Interval(0.5, 1.0)));

    context.read<ScanCubit>().analyzeImage(widget.imageBytes);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _labelsController.dispose();
    super.dispose();
  }

  void _showResultSheet(BuildContext context, beer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScanResultSheet(beer: beer),
    ).then((_) {
      // If sheet dismissed without navigation, pop back to camera
      if (mounted && GoRouterState.of(context).uri.toString().contains('/scanning')) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocConsumer<ScanCubit, ScanState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (beer) {
              _animationController.stop();
              _showResultSheet(context, beer);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.memory(
                  widget.imageBytes,
                  fit: BoxFit.cover,
                  color: AppColors.black.withValues(alpha: 0.5),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              
              state.maybeWhen(
                error: (msg) => _buildErrorState(context, msg),
                orElse: () => _buildAnalyzingState(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnalyzingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250,
            height: 350,
            child: Stack(
              children: [
                // Container border
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                // Scanning Line
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      top: 350 * _animation.value,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                // Floating Label 1
                Positioned(
                  top: 60,
                  right: -40,
                  child: FadeTransition(
                    opacity: _label1Animation,
                    child: _buildFloatingLabel(CupertinoIcons.drop_fill, 'ANALIZA KOLORU...'),
                  ),
                ),
                
                // Floating Label 2
                Positioned(
                  bottom: 80,
                  right: -80,
                  child: FadeTransition(
                    opacity: _label2Animation,
                    child: _buildFloatingLabel(CupertinoIcons.circle_fill, 'ROZPOZNAWANIE ETYKIETY...', iconSize: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(0),
              const SizedBox(width: 4),
              _buildDot(1),
              const SizedBox(width: 4),
              _buildDot(2),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Analizujemy Twoje piwo...',
            style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _labelsController,
      builder: (context, child) {
        final phase = (_labelsController.value * 3).floor();
        final isActive = phase == index || phase > index;
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : AppColors.separator.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildFloatingLabel(IconData icon, String text, {double iconSize = 14}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: iconSize),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorState(BuildContext context, String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle_fill, color: Colors.orange, size: 64),
              const SizedBox(height: 16),
              Text(
                'Nie udało się rozpoznać piwa',
                style: AppTypography.title2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                msg,
                style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () => context.pop(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
