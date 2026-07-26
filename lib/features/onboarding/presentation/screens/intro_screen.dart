import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_icons.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: 'https://media.screensdesign.com/afprjsia/d68ae3d9-58f5-4438-9f60-9b67a71e5c34.png',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: AppColors.accentTint),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.accentTint,
                    child: const Center(
                      child: Icon(Icons.local_drink, color: AppColors.accent, size: 64),
                    ),
                  ),
                ),
                // Gradient to fade into background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 120,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0.0),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Foreground Content
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55 - 32, // Overlaps the image slightly
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // Icon Box Overlapping
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: CustomPaint(
                          painter: BottlePainter(color: AppColors.accent),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s24),
                  
                  // Header
                  Text(
                    'BrewDNA',
                    style: AppTypography.largeTitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacings.s8),
                  
                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s32),
                    child: Text(
                      'Twój osobisty przewodnik po piwie',
                      style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: AppSpacings.s32),
                  
                  // Features list
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s32),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          icon: CupertinoIcons.viewfinder,
                          title: 'Inteligentne skanowanie etykiet',
                          description: 'Błyskawicznie rozpoznawaj piwa dzięki AI.',
                        ),
                        SizedBox(height: AppSpacings.s24),
                        _buildFeatureItem(
                          customIcon: SizedBox(
                            width: 20,
                            height: 20,
                            child: CustomPaint(
                              painter: DnaHelixPainter(color: AppColors.accent),
                            ),
                          ),
                          title: 'Dopasowanie smaku',
                          description: 'Znajdź piwa idealnie dopasowane do Twojego profilu.',
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                    child: AppButton(
                      text: 'Odkryj swój gust',
                      onPressed: () => context.go('/onboarding/quiz'),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s8),
                  TextButton(
                    onPressed: () => context.go('/auth/start'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.label,
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.s12, horizontal: AppSpacings.s24),
                    ),
                    child: Text(
                      'Zaloguj się',
                      style: AppTypography.body.copyWith(
                        color: AppColors.label,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + AppSpacings.s16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    IconData? icon,
    Widget? customIcon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.accentTint,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: customIcon ?? Icon(icon!, color: AppColors.accent, size: 20),
          ),
        ),
        SizedBox(width: AppSpacings.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.headline.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTypography.caption.copyWith(
                  color: AppColors.labelSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
