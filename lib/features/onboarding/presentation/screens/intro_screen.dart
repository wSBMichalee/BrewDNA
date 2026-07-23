import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_icons.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacings.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Text('HopIQ', style: AppTypography.largeTitle, textAlign: TextAlign.center),
              SizedBox(height: AppSpacings.s12),
              Text(
                'Twój osobisty przewodnik po piwie',
                style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 64.0.h),
              Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: CustomPaint(
                    painter: BeerMugPainter(color: AppColors.accent),
                  ),
                ),
              ),
              Spacer(),
              AppButton(
                text: 'Zacznijmy',
                onPressed: () => context.go('/onboarding/quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
