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

class _ScanningAnalyzingScreenState extends State<ScanningAnalyzingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.1, end: 0.9).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Start analysis
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanCubit>().analyzeImage(widget.imageBytes);
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
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
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Analizujemy Twoje piwo...',
            style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          const CupertinoActivityIndicator(color: AppColors.accent),
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
