import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/taste_slider.dart';
import '../../../../core/widgets/custom_icons.dart';
import '../bloc/onboarding_cubit.dart';
import '../bloc/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<OnboardingCubit>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _nextPage(BuildContext context) {
    if (_currentIndex < 3) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/onboarding/hook');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? AppColors.accent
                              : AppColors.separator,
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildQuestion(
                        context: context,
                        iconWidget: Icon(CupertinoIcons.drop_fill, size: 56, color: AppColors.accent),
                        title: 'Jakie piwa wolisz?',
                        subtitle: 'Pomoże nam to określić moc i ciężar polecanych piw.',
                        leftLabel: 'Lekkie',
                        rightLabel: 'Mocne',
                        value: state.lightStrongValue,
                        onChanged: (v) => context.read<OnboardingCubit>().updateLightStrong(v),
                      ),
                      _buildQuestion(
                        context: context,
                        iconWidget: Icon(CupertinoIcons.leaf_arrow_circlepath, size: 56, color: AppColors.accent),
                        title: 'Co powiesz na goryczkę?',
                        subtitle: 'Nie ma złych odpowiedzi, to pomoże nam Cię lepiej poznać.',
                        leftLabel: 'Słodkie',
                        rightLabel: 'Gorzkie',
                        value: state.bitterSweetValue,
                        onChanged: (v) => context.read<OnboardingCubit>().updateBitterSweet(v),
                      ),
                      _buildQuestion(
                        context: context,
                        iconWidget: SizedBox(
                          width: 56,
                          height: 56,
                          child: CustomPaint(painter: FruitBranchPainter(color: AppColors.accent)),
                        ),
                        title: 'Smaki owocowe czy wytrawne?',
                        subtitle: 'Wpływa to na dobór chmieli i dodatków w rekomendacjach.',
                        leftLabel: 'Owocowe',
                        rightLabel: 'Wytrawne',
                        value: state.dryFruityValue,
                        onChanged: (v) => context.read<OnboardingCubit>().updateDryFruity(v),
                      ),
                      _buildQuestion(
                        context: context,
                        iconWidget: SizedBox(
                          width: 56,
                          height: 56,
                          child: CustomPaint(painter: WheatEarPainter(color: AppColors.accent)),
                        ),
                        title: 'A może coś słodowego?',
                        subtitle: 'Baza słodowa potrafi całkowicie odmienić smak piwa.',
                        leftLabel: 'Chrupkie',
                        rightLabel: 'Słodowe',
                        value: state.crispMaltyValue,
                        onChanged: (v) => context.read<OnboardingCubit>().updateCrispMalty(v),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuestion({
    required BuildContext context,
    required Widget iconWidget,
    required String title,
    required String subtitle,
    required String leftLabel,
    required String rightLabel,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.all(AppSpacings.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Push everything to the upper part (approx upper 50%)
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.accentTint,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: iconWidget),
                ),
                SizedBox(height: AppSpacings.s32),
                Text(title, style: AppTypography.title2, textAlign: TextAlign.center),
                SizedBox(height: AppSpacings.s8),
                Text(subtitle, style: AppTypography.body.copyWith(color: AppColors.labelSecondary), textAlign: TextAlign.center),
                SizedBox(height: AppSpacings.s48),
                TasteSlider(
                  leftLabel: leftLabel,
                  rightLabel: rightLabel,
                  value: value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Dalej',
                  onPressed: () => _nextPage(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
