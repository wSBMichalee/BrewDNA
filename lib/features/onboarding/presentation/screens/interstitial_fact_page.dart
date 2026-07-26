import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

class InterstitialFactPage extends StatelessWidget {
  final VoidCallback onNext;

  const InterstitialFactPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.accentTint,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🍺', style: TextStyle(fontSize: 32)),
            ),
          ),
          SizedBox(height: AppSpacings.s24),
          Text(
            'Twój profil smakowy zaczyna nabierać kształtu',
            style: AppTypography.title2.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacings.s32),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacings.s24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'CZY WIESZ, ŻE?',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: AppSpacings.s16),
                Text(
                  'Chmiel należy do tej samej rodziny roślin co konopie — to dlatego niektóre piwa mają tak wyraziste, ziołowe aromaty.',
                  style: AppTypography.body,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
          AppButton(
            text: 'Dalej',
            onPressed: onNext,
          ),
          SizedBox(height: AppSpacings.s16),
        ],
      ),
    );
  }
}
