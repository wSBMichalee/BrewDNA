import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


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
    if (_currentIndex < 9) {
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
    if (_currentIndex <= 3) return _currentIndex;
    if (_currentIndex == 4) return 3; // Interstitial Fact Page shares step 4
    if (_currentIndex >= 5 && _currentIndex <= 7) return _currentIndex - 1;
    return 6;
  }

  bool get _showTopBar => _currentIndex < 8; // Hide on Analyzing and Hook

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
                            children: List.generate(7, (index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
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
                        question: 'Co powiesz na goryczkę?',
                        subtitle: 'Pomyśl o czystym lagerze kontra mocnym west-coast IPA.',
                        imageUrl: 'https://media.screensdesign.com/afprjsia/ef4321e8-c7db-4471-ba73-59f70ecf2758.png',
                        leftLabel: 'Łagodne',
                        rightLabel: 'Gorzkie',
                        sliderValue: state.bitterSweetValue,
                        onSliderChanged: (v) => context.read<OnboardingCubit>().updateBitterSweet(v),
                        buttonLabel: 'Następne pytanie',
                        onNext: _nextPage,
                      ),
                      // Page 1: Q2
                      QuizQuestionPage(
                        step: 2,
                        question: 'Jak lubisz swoje piwo?',
                        subtitle: 'Lekkie i orzeźwiające, czy mocne i rozgrzewające?',
                        imageUrl: 'https://media.screensdesign.com/gasset/e280ab6f53ad40c79d472cafd60b9b97_screen_image_beer_droplet_icon_4ed73202b0.png',
                        leftLabel: 'Lekkie',
                        rightLabel: 'Mocne',
                        sliderValue: state.lightStrongValue,
                        onSliderChanged: (v) => context.read<OnboardingCubit>().updateLightStrong(v),
                        buttonLabel: 'Następne pytanie',
                        onNext: _nextPage,
                      ),
                      // Page 2: Q3
                      QuizQuestionPage(
                        step: 3,
                        question: 'Owocowe czy wytrawne?',
                        subtitle: 'Pomyśl o soczystym NEIPA kontra klasycznym, wytrawnym pilznerze.',
                        imageUrl: 'https://media.screensdesign.com/gasset/a7a8bfb2bd8545cabebaf5c6701900e5_screen_image_citrus_icon_74e19ea847.png',
                        leftLabel: 'Owocowe',
                        rightLabel: 'Wytrawne',
                        sliderValue: state.dryFruityValue,
                        onSliderChanged: (v) => context.read<OnboardingCubit>().updateDryFruity(v),
                        buttonLabel: 'Następne pytanie',
                        onNext: _nextPage,
                      ),
                      // Page 3: Q4
                      QuizQuestionPage(
                        step: 4,
                        question: 'A może coś słodowego?',
                        subtitle: 'Chrupiące i suche, czy słodowe i pełne?',
                        imageUrl: 'https://media.screensdesign.com/gasset/2481ee217f3f42989f7afa0f818186ed_screen_image_malt_icon_4562e687ca.png',
                        leftLabel: 'Orzeźwiające',
                        rightLabel: 'Słodowe',
                        sliderValue: state.crispMaltyValue,
                        onSliderChanged: (v) => context.read<OnboardingCubit>().updateCrispMalty(v),
                        buttonLabel: 'Dalej',
                        onNext: _nextPage,
                      ),
                      // Page 4: Interstitial
                      InterstitialFactPage(
                        onNext: _nextPage,
                      ),
                      // Page 5: Styles
                      ChipSelectionPage(
                        step: 5,
                        totalSteps: 7,
                        question: 'Jakie style już znasz i lubisz?',
                        subtitle: 'Wybierz tyle, ile chcesz — to pomoże nam Cię lepiej poznać.',
                        options: const ['IPA', 'Lager', 'Weizen', 'Stout', 'Sour', 'Belgijskie', 'Porter', 'Pils'],
                        selectedValues: state.selectedStyles,
                        onToggle: (v) => context.read<OnboardingCubit>().toggleStyle(v),
                        onNext: _nextPage,
                      ),
                      // Page 6: Countries
                      ChipSelectionPage(
                        step: 6,
                        totalSteps: 7,
                        question: 'Skąd najchętniej sięgasz po piwo?',
                        subtitle: 'Wybierz swoje ulubione kraje piwne.',
                        options: const [
                          'Polska 🇵🇱', 'Belgia 🇧🇪', 'Niemcy 🇩🇪', 'Czechy 🇨🇿', 'USA 🇺🇸',
                          'Wielka Brytania 🇬🇧', 'Irlandia 🇮🇪', 'Hiszpania 🇪🇸', 'Włochy 🇮🇹',
                          'Holandia 🇳🇱', 'Austria 🇦🇹', 'Francja 🇫🇷', 'Dania 🇩🇰', 'Szwajcaria 🇨🇭',
                          'Meksyk 🇲🇽', 'Brazylia 🇧🇷', 'Kanada 🇨🇦', 'Japonia 🇯🇵', 'Chiny 🇨🇳',
                          'Korea Południowa 🇰🇷', 'Australia 🇦🇺', 'RPA 🇿🇦'
                        ],
                        selectedValues: state.selectedCountries,
                        onToggle: (v) => context.read<OnboardingCubit>().toggleCountry(v),
                        onNext: _nextPage,
                      ),
                      // Page 7: Experience Level
                      ExperienceLevelPage(
                        step: 7,
                        totalSteps: 7,
                        selectedLevel: state.experienceLevel,
                        onSelect: (v) => context.read<OnboardingCubit>().setExperienceLevel(v),
                        onNext: _nextPage,
                      ),
                      // Page 8: Analyzing Loading
                      AnalyzingPage(
                        onComplete: _nextPage,
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
