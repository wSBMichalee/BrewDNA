import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/core/theme/app_theme.dart';
import 'package:hop_iq/core/widgets/app_button.dart';

class PaywallBenefitsScreen extends StatelessWidget {
  const PaywallBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Dark amber gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black,
                  AppColors.accentDeep.withValues(alpha: 0.3),
                  AppColors.black,
                ],
              ),
            ),
          ),
          // Subtle glow
          Positioned(
            top: 50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.2),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(AppSpacings.s8),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(CupertinoIcons.xmark, color: AppColors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacings.s16),
                  Text(
                    'Odkryj korzyści Premium',
                    style: AppTypography.brandDisplay.copyWith(color: AppColors.white),
                  ),
                  SizedBox(height: AppSpacings.s32),
                  
                  // Glassmorphism card for benefits
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: EdgeInsets.all(AppSpacings.s24),
                        decoration: BoxDecoration(
                          color: AppColors.darkCard.withValues(alpha: 0.65), // Ciemne szkło
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildBenefitRow('Podsumowania AI piwa', isNew: true),
                            _buildBenefitRow('Szybki skaner porównawczy'),
                            _buildBenefitRow('Skaner karty piw'),
                            _buildBenefitRow('Inteligentniejsze Przygody Piwne'),
                            _buildBenefitRow('Ulepszenia Piwniczki', isLast: true),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Toggle placeholder
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Rocznie',
                              textAlign: TextAlign.center,
                              style: AppTypography.subhead.copyWith(
                                color: AppColors.background,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Miesięcznie',
                              textAlign: TextAlign.center,
                              style: AppTypography.subhead.copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: AppSpacings.s24),
                  
                  AppButton(
                    text: 'Zacznij Premium (199,99 zł / rok)',
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String title, {bool isNew = false, bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacings.s16),
      child: Row(
        children: [
          Icon(CupertinoIcons.check_mark_circled_solid, color: AppColors.accent),
          SizedBox(width: AppSpacings.s12),
          Expanded(
            child: Text(
              title,
              style: AppTypography.body.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isNew)
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s8, vertical: AppSpacings.s4),
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Nowość',
                style: AppTypography.caption.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
