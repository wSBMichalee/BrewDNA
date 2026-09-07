import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../widgets/discover/discover_header.dart';
import '../widgets/discover/beer_of_the_day_section.dart';
import '../widgets/discover/recommendations_section.dart';
import '../widgets/discover/top_countries_section.dart';
import '../widgets/discover/top_rated_beers_section.dart';
import '../widgets/discover/matched_dna_section.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  late final BeerCubit _beerCubit;
  late final AnimationController _staggerController;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _beerCubit = getIt<BeerCubit>();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    // Nie ładuj danych jeśli cubit jest już w stanie loaded z danymi
    // (powrót na ekran z innej zakładki, back z detail, itp.)
    _beerCubit.state.maybeWhen(
      loaded: (history, recommendations, topCountries, topRatedBeers, beerOfTheDay, _, matchedBeers) {
        _hasAnimated = true;
        _staggerController.value = 1.0;
        if (recommendations.isEmpty && topRatedBeers.isEmpty && beerOfTheDay == null) {
          _beerCubit.loadDiscoverData();
        }
      },
      orElse: () {
        _beerCubit.loadDiscoverData();
      },
    );
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.separator,
      highlightColor: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.s24,
                vertical: AppSpacings.s16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.card,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              child: Container(
                width: 200,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: AppSpacings.s24),

            // Beer of the day
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              child: Container(
                height: 420,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),

            SizedBox(height: AppSpacings.s48),

            // Recommendations Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacings.s16),

            // Recommendations List
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: EdgeInsets.only(right: AppSpacings.s16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _beerCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<BeerCubit, BeerState>(
            builder: (context, beerState) {
              return beerState.maybeWhen(
                loading: () => _buildSkeleton(),
                error: (msg) => AppErrorWidget(
                  message: msg,
                  isNoInternet: msg == 'NO_INTERNET',
                  onRetry: () => _beerCubit.loadDiscoverData(),
                ),
                loaded: (history, recommendations, topCountries, topRatedBeers, beerOfTheDay, _, matchedBeers) {
                  // Uruchom animację tylko raz przy pierwszym załadowaniu danych
                  if (!_hasAnimated &&
                      (recommendations.isNotEmpty ||
                          topRatedBeers.isNotEmpty ||
                          beerOfTheDay != null)) {
                    _hasAnimated = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _staggerController.forward();
                      }
                    });
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DiscoverHeader(animation: _staggerController),
                        
                        if (beerOfTheDay != null) ...[
                          SizedBox(height: AppSpacings.s24),
                          BeerOfTheDaySection(
                            beer: beerOfTheDay,
                            animation: _staggerController,
                          ),
                        ],

                        if (recommendations.isNotEmpty) ...[
                          SizedBox(height: AppSpacings.s48),
                          RecommendationsSection(
                            recommendations: recommendations,
                            animation: _staggerController,
                          ),
                        ],

                        if (topCountries.isNotEmpty) ...[
                          SizedBox(height: AppSpacings.s48),
                          TopCountriesSection(
                            topCountries: topCountries,
                            animation: _staggerController,
                          ),
                        ],

                        if (topRatedBeers.isNotEmpty) ...[
                          SizedBox(height: AppSpacings.s48),
                          TopRatedBeersSection(
                            topRatedBeers: topRatedBeers,
                            animation: _staggerController,
                          ),
                        ],

                        if (matchedBeers.isNotEmpty) ...[
                          SizedBox(height: AppSpacings.s48),
                          MatchedDnaSection(
                            matchedBeers: matchedBeers,
                            animation: _staggerController,
                            beerCubit: _beerCubit,
                          ),
                        ],
                      ],
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
    );
  }
}
