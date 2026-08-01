import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hop_iq/l10n/app_localizations.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/onboarding_cubit.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/quiz_question_page.dart';
import '../widgets/chip_selection_page.dart';
import 'interstitial_fact_page.dart';
import 'experience_level_page.dart';
import 'analyzing_page.dart';
import 'hook_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OnboardingView();
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
    if (_currentIndex < 8) {
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

  int get _activeIndicatorStep {
    if (_currentIndex <= 2) return _currentIndex;
    if (_currentIndex == 3) return 2; // Interstitial Fact Page shares step 3
    if (_currentIndex >= 4 && _currentIndex <= 6) return _currentIndex - 1;
    return 5;
  }

  bool get _showTopBar => _currentIndex < 7; // Hide on Analyzing and Hook

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                // Header navigation (hidden on Analyzing and Result)
                if (_showTopBar)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacings.s16,
                      vertical: AppSpacings.s16,
                    ),
                    child: Row(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _previousPage,
                          child: const Icon(
                            CupertinoIcons.back,
                            color: AppColors.label,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 24,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: index <= _activeIndicatorStep
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
                      // Page 0: Q1
                      QuizQuestionPage(
                        step: 1,
                        question: AppLocalizations.of(context)!.onboardingQ1Title,
                        subtitle: AppLocalizations.of(context)!.onboardingQ1Subtitle,
                        imageUrl:
                            'https://media.screensdesign.com/afprjsia/ef4321e8-c7db-4471-ba73-59f70ecf2758.png',
                        leftLabel: AppLocalizations.of(context)!.onboardingQ1Left,
                        rightLabel: AppLocalizations.of(context)!.onboardingQ1Right,
                        sliderValue: state.bitterSweetValue,
                        onSliderChanged: (v) => context
                            .read<OnboardingCubit>()
                            .updateBitterSweet(v),
                        buttonLabel: AppLocalizations.of(context)!.onboardingNextQuestionButton,
                        onNext: _nextPage,
                      ),
                      // Page 1: Q2
                      QuizQuestionPage(
                        step: 2,
                        question: AppLocalizations.of(context)!.onboardingQ2Title,
                        subtitle: AppLocalizations.of(context)!.onboardingQ2Subtitle,
                        imageUrl:
                            'https://media.screensdesign.com/afprjsia/d68ae3d9-58f5-4438-9f60-9b67a71e5c34.png',
                        imageUrlEnd:
                            'https://images.pexels.com/photos/1089930/pexels-photo-1089930.jpeg',
                        leftLabel: AppLocalizations.of(context)!.onboardingQ2Left,
                        rightLabel: AppLocalizations.of(context)!.onboardingQ2Right,
                        sliderValue: state.lightStrongValue,
                        onSliderChanged: (v) => context
                            .read<OnboardingCubit>()
                            .updateLightStrong(v),
                        buttonLabel: AppLocalizations.of(context)!.onboardingNextQuestionButton,
                        onNext: _nextPage,
                      ),
                      // Page 2: Q3
                      QuizQuestionPage(
                        step: 3,
                        question: AppLocalizations.of(context)!.onboardingQ3Title,
                        subtitle: AppLocalizations.of(context)!.onboardingQ3Subtitle,
                        imageUrl:
                            'https://media.screensdesign.com/gasset/a7a8bfb2bd8545cabebaf5c6701900e5_screen_image_citrus_icon_74e19ea847.png',
                        imageUrlEnd:
                            'https://media.screensdesign.com/gasset/e82346341291427ab997b8edb1aa3252_screen_image_ne_ipa_visual_8f69909d1e.png',
                        leftLabel: AppLocalizations.of(context)!.onboardingQ3Left,
                        rightLabel: AppLocalizations.of(context)!.onboardingQ3Right,
                        sliderValue: state.dryFruityValue,
                        onSliderChanged: (v) =>
                            context.read<OnboardingCubit>().updateDryFruity(v),
                        buttonLabel: AppLocalizations.of(context)!.onboardingNextQuestionButton,
                        onNext: _nextPage,
                      ),
                      // Page 3: Interstitial
                      InterstitialFactPage(
                        onNext: _nextPage,
                        dryFruityValue: state.dryFruityValue,
                      ),
                      // Page 4: Styles
                      state.isStylesLoading
                          ? Shimmer.fromColors(
                              baseColor: AppColors.separator,
                              highlightColor: AppColors.background,
                              child: ChipSelectionPage(
                                step: 4,
                                totalSteps: 6,
                                question: AppLocalizations.of(context)!.onboardingQ5Title,
                                subtitle: AppLocalizations.of(context)!.onboardingQ5Subtitle,
                                options: const ['IPA', 'Lager', 'Weizen', 'Stout', 'Sour', 'Belgijskie'],
                                selectedValues: const {},
                                onToggle: (_) {},
                                onNext: () {},
                              ),
                            )
                          : ChipSelectionPage(
                              step: 4,
                              totalSteps: 6,
                              question: AppLocalizations.of(context)!.onboardingQ5Title,
                              subtitle: AppLocalizations.of(context)!.onboardingQ5Subtitle,
                              options: state.availableStyles,
                              selectedValues: state.selectedStyles,
                              onToggle: (v) =>
                                  context.read<OnboardingCubit>().toggleStyle(v),
                              onNext: _nextPage,
                            ),
                      // Page 5: Countries
                      ChipSelectionPage(
                        step: 5,
                        totalSteps: 6,
                        question: AppLocalizations.of(context)!.onboardingQ6Title,
                        subtitle: AppLocalizations.of(context)!.onboardingQ6Subtitle,
                        options: const [
                          'Polska 🇵🇱',
                          'Belgia 🇧🇪',
                          'Niemcy 🇩🇪',
                          'Czechy 🇨🇿',
                          'USA 🇺🇸',
                          'Wielka Brytania 🇬🇧',
                          'Irlandia 🇮🇪',
                          'Hiszpania 🇪🇸',
                          'Włochy 🇮🇹',
                          'Holandia 🇳🇱',
                          'Austria 🇦🇹',
                          'Francja 🇫🇷',
                          'Dania 🇩🇰',
                          'Szwajcaria 🇨🇭',
                          'Meksyk 🇲🇽',
                          'Brazylia 🇧🇷',
                          'Kanada 🇨🇦',
                          'Japonia 🇯🇵',
                          'Chiny 🇨🇳',
                          'Korea Południowa 🇰🇷',
                          'Australia 🇦🇺',
                          'RPA 🇿🇦',
                        ],
                        selectedValues: state.selectedCountries,
                        onToggle: (v) =>
                            context.read<OnboardingCubit>().toggleCountry(v),
                        onNext: _nextPage,
                      ),
                      // Page 6: Experience Level
                      ExperienceLevelPage(
                        step: 6,
                        totalSteps: 6,
                        selectedLevel: state.experienceLevel,
                        onSelect: (v) => context
                            .read<OnboardingCubit>()
                            .setExperienceLevel(v),
                        onNext: _nextPage,
                      ),
                      // Page 8: Analyzing Loading
                      AnalyzingPage(
                        onComplete: _nextPage,
                        dryFruityValue: state.dryFruityValue,
                      ),
                      // Page 9: Hook Result
                      const HookScreen(),
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
}
