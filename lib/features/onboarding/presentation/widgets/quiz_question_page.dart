import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

class QuizQuestionPage extends StatelessWidget {
  final int step;
  final String question;
  final String subtitle;
  final String imageUrl;
  final String leftLabel;
  final String rightLabel;
  final String buttonLabel;
  final double sliderValue;
  final ValueChanged<double> onSliderChanged;
  final VoidCallback onNext;

  const QuizQuestionPage({
    super.key,
    required this.step,
    required this.question,
    required this.subtitle,
    required this.imageUrl,
    required this.leftLabel,
    required this.rightLabel,
    required this.buttonLabel,
    required this.sliderValue,
    required this.onSliderChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        children: [
          SizedBox(height: AppSpacings.s32),
          Text(
            'STEP $step OF 4',
            style: AppTypography.caption.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: AppSpacings.s16),
          Text(
            question,
            style: AppTypography.title2.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacings.s12),
          Text(
            subtitle,
            style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          // Image box
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 140,
                height: 140,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const Spacer(),
          // Custom Slider replacing the previous approach
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CupertinoSlider(
                  value: sliderValue,
                  min: 0,
                  max: 100,
                  activeColor: AppColors.accent,
                  onChanged: onSliderChanged,
                ),
              ),
              SizedBox(height: AppSpacings.s8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leftLabel.toUpperCase(),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.labelSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    rightLabel.toUpperCase(),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.labelSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacings.s48),
          AppButton(
            text: buttonLabel,
            onPressed: onNext,
          ),
          SizedBox(height: AppSpacings.s16),
        ],
      ),
    );
  }
}
