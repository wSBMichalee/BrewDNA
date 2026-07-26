import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/onboarding_cubit.dart';
import '../bloc/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentIndex == 0) {
      context.go('/onboarding/intro');
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
                // Header navigation (hidden on page 5)
                if (_currentIndex < 4)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSpacings.s16, vertical: AppSpacings.s16),
                    child: Row(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _previousPage,
                          child: const Icon(CupertinoIcons.back,
                              color: AppColors.label),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 24,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: index <= _currentIndex
                                      ? AppColors.accent
                                      : AppColors.separator,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance for centering
                      ],
                    ),
                  ),

                // Pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      context.read<OnboardingCubit>().setStep(index);
                    },
                    children: [
                      // Page 1
                      _buildQuestionPage(
                        step: 1,
                        title: 'Co powiesz na goryczkę?',
                        subtitle:
                            'Pomyśl o czystym lagerze kontra mocnym west-coast IPA.',
                        imageUrl:
                            'https://media.screensdesign.com/afprjsia/ef4321e8-c7db-4471-ba73-59f70ecf2758.png',
                        leftLabel: 'Łagodne',
                        rightLabel: 'Gorzkie',
                        value: state.bitterSweetValue,
                        onChanged: (v) => context
                            .read<OnboardingCubit>()
                            .updateBitterSweet(v),
                        buttonText: 'Następne pytanie',
                        onNext: _nextPage,
                      ),
                      // Page 2
                      _buildQuestionPage(
                        step: 2,
                        title: 'Jak lubisz swoje piwo?',
                        subtitle:
                            'Lekkie i orzeźwiające, czy mocne i rozgrzewające?',
                        imageUrl:
                            'https://media.screensdesign.com/gasset/e280ab6f53ad40c79d472cafd60b9b97_screen_image_beer_droplet_icon_4ed73202b0.png',
                        leftLabel: 'Lekkie',
                        rightLabel: 'Mocne',
                        value: state.lightStrongValue,
                        onChanged: (v) => context
                            .read<OnboardingCubit>()
                            .updateLightStrong(v),
                        buttonText: 'Następne pytanie',
                        onNext: _nextPage,
                      ),
                      // Page 3
                      _buildQuestionPage(
                        step: 3,
                        title: 'Owocowe czy wytrawne?',
                        subtitle:
                            'Pomyśl o soczystym NEIPA kontra klasycznym, wytrawnym pilznerze.',
                        imageUrl:
                            'https://media.screensdesign.com/gasset/a7a8bfb2bd8545cabebaf5c6701900e5_screen_image_citrus_icon_74e19ea847.png',
                        leftLabel: 'Owocowe',
                        rightLabel: 'Wytrawne',
                        value: state.dryFruityValue,
                        onChanged: (v) => context
                            .read<OnboardingCubit>()
                            .updateDryFruity(v),
                        buttonText: 'Następne pytanie',
                        onNext: _nextPage,
                      ),
                      // Page 4
                      _buildQuestionPage(
                        step: 4,
                        title: 'A może coś słodowego?',
                        subtitle: 'Chrupiące i suche, czy słodowe i pełne?',
                        imageUrl:
                            'https://media.screensdesign.com/gasset/2481ee217f3f42989f7afa0f818186ed_screen_image_malt_icon_4562e687ca.png',
                        leftLabel: 'Orzeźwiające',
                        rightLabel: 'Słodowe',
                        value: state.crispMaltyValue,
                        onChanged: (v) => context
                            .read<OnboardingCubit>()
                            .updateCrispMalty(v),
                        buttonText: 'Zobacz mój profil',
                        onNext: _nextPage,
                      ),
                      // Page 5: Result
                      _buildResultPage(context, state),
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

  Widget _buildQuestionPage({
    required int step,
    required String title,
    required String subtitle,
    required String imageUrl,
    required String leftLabel,
    required String rightLabel,
    required double value,
    required ValueChanged<double> onChanged,
    required String buttonText,
    required VoidCallback onNext,
  }) {
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
            title,
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
                  value: value,
                  min: 0,
                  max: 100,
                  activeColor: AppColors.accent,
                  onChanged: onChanged,
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
            text: buttonText,
            onPressed: onNext,
          ),
          SizedBox(height: AppSpacings.s16),
        ],
      ),
    );
  }

  Widget _buildResultPage(BuildContext context, OnboardingState state) {
    final styleName = context.read<OnboardingCubit>().getRecommendedStyle();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Badge
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.accentTint,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(CupertinoIcons.checkmark_alt,
                  color: AppColors.accent, size: 32),
            ),
          ),
          SizedBox(height: AppSpacings.s24),
          Text(
            'Świetnie!',
            style: AppTypography.title2.copyWith(fontSize: 28),
          ),
          SizedBox(height: AppSpacings.s12),
          Text(
            'Na podstawie Twoich odpowiedzi prawdopodobnie polubisz',
            style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacings.s32),

          // Result Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: AppSpacings.s32, horizontal: AppSpacings.s24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.accentTint,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://media.screensdesign.com/gasset/e82346341291427ab997b8edb1aa3252_screen_image_ne_ipa_visual_8f69909d1e.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacings.s24),
                Text(
                  styleName,
                  style: AppTypography.title2.copyWith(color: AppColors.accent),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacings.s8),
                Text(
                  'SOCZYSTE, OWOCOWE, Z NUTĄ CYTRUSÓW',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.labelSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacings.s32),

          Text(
            'Twoje DNA piwne jest unikalne. Odkryliśmy Twój idealny punkt startowy.',
            style: AppTypography.body.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.labelSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AppButton(
            text: 'Załóż konto, by zapisać profil',
            onPressed: () => context.go('/auth/start'),
          ),
          SizedBox(height: AppSpacings.s16),
        ],
      ),
    );
  }
}
