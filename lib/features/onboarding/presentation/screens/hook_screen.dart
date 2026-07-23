import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/onboarding_cubit.dart';
import '../bloc/onboarding_state.dart';

class HookScreen extends StatelessWidget {
  HookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final style = context.read<OnboardingCubit>().getRecommendedStyle();
        
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpacings.s24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.accentTint,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(CupertinoIcons.sparkles, size: 64, color: AppColors.accent),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s48),
                  Text(
                    'Na podstawie Twoich odpowiedzi prawdopodobnie polubisz:',
                    style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacings.s12),
                  Text(
                    style,
                    style: AppTypography.largeTitle.copyWith(color: AppColors.accent),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacings.s24),
                  Text(
                    'Załóż konto, abyśmy mogli dopracować Twój profil BeerDNA i polecać konkretne piwa.',
                    style: AppTypography.subhead,
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Zarejestruj się',
                      onPressed: () => context.go('/auth/start'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
