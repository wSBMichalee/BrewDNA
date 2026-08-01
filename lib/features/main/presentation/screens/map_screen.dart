import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';

const Map<String, String> _countryToCode = {
  // Nazwy mockowane (z MockBeerRepository)
  'Polska': 'pl',
  'Poland': 'pl',
  'Niemcy': 'de',
  'Germany': 'de',
  'Belgia': 'be',
  'Belgium': 'be',
  'Czechy': 'cz',
  'Czech Republic': 'cz',
  'Wielka Brytania': 'gb',
  'United Kingdom': 'gb',
  'United States': 'us',

  // Realne dane z bazy z tabeli breweries (seed.sql)
  'PL': 'pl',
  'UK': 'gb',
  'USA': 'us',
  'DK': 'dk',
  'SE': 'se',
  'IE': 'ie',
  'BE': 'be',
};

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BeerCubit>()..loadHistory(),
      child: BlocBuilder<BeerCubit, BeerState>(
        builder: (context, state) {
          final int uniqueCountries = state.maybeWhen(
            loaded: (history, _, __, ___, ____, _____, ______) =>
                history.map((b) => b.country).toSet().length,
            orElse: () => 0,
          );
          final int percent = (uniqueCountries / 195 * 100).floor();

          final Map<String, Color> mapColors = {};
          state.maybeWhen(
            loaded: (history, _, __, ___, ____, _____, ______) {
              for (final b in history) {
                final code = _countryToCode[b.country];
                if (code != null) {
                  mapColors[code] = AppColors.accent;
                }
              }
            },
            orElse: () {},
          );

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              bottom: false,
              child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacings.s24),
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context)!.mapTitle, style: AppTypography.largeTitle),
                      const SizedBox(height: 8),
                      // Actual count of unique countries from user data
                      Text(
                        AppLocalizations.of(context)!.mapCountriesDiscovered(uniqueCountries),
                        style: AppTypography.subhead.copyWith(
                          color: AppColors.labelSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Map Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                  child: Container(
                    height: 260,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Interactive World Map
                        Positioned.fill(
                          child: RepaintBoundary(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SimpleMap(
                                instructions: SMapWorld.instructions,
                                defaultColor: AppColors.separator.withValues(alpha: 0.3),
                                colors: mapColors,
                                callback: (id, name, tapDetails) {
                                  debugPrint("Tapped country: $id, $name");
                                },
                              ),
                            ),
                          ),
                        ),
                        // Badge
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  CupertinoIcons.globe,
                                  color: AppColors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                // Actual percentage based on discovered countries
                                Text(
                                  AppLocalizations.of(context)!.mapPercentDiscovered(percent),
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacings.s32)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                  child: Text(AppLocalizations.of(context)!.mapRecentlyDiscovered, style: AppTypography.title2),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacings.s16)),

              // History List from Cubit state
              Builder(
                builder: (context) {
                  return state.maybeWhen(
                    loading: () => SliverToBoxAdapter(
                      child: Shimmer.fromColors(
                        baseColor: AppColors.separator,
                        highlightColor: AppColors.background,
                        child: Column(
                          children: List.generate(
                            3,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacings.s24,
                                vertical: 8,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        height: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Container(
                                      width: 60,
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                      loaded: (history, recommendations, _, __, beerOfTheDay, selectedBeer, matchedBeers) {
                      if (history.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacings.s24),
                            child: Text(
                              AppLocalizations.of(context)!.mapEmptyState,
                              style: AppTypography.body.copyWith(
                                color: AppColors.labelSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      // For UI purposes, let's map history to some dummy countries if we don't have country in Beer entity
                      // Assuming we fake countries based on index or just list them.
                      // The mock expects "Czechy, Niemcy, Belgia".
                      final dummyCountries = [
                        {'name': AppLocalizations.of(context)!.mapDummyCzech, 'flag': '🇨🇿', 'count': AppLocalizations.of(context)!.mapDummyCzechCount},
                        {'name': AppLocalizations.of(context)!.mapDummyGermany, 'flag': '🇩🇪', 'count': AppLocalizations.of(context)!.mapDummyGermanyCount},
                        {'name': AppLocalizations.of(context)!.mapDummyBelgium, 'flag': '🇧🇪', 'count': AppLocalizations.of(context)!.mapDummyBelgiumCount},
                      ];

                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index >= dummyCountries.length) return null;
                          final country = dummyCountries[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacings.s24,
                              vertical: 8,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    country['flag']!,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      country['name']!,
                                      style: AppTypography.headline,
                                    ),
                                  ),
                                  Text(
                                    country['count']!,
                                    style: AppTypography.subhead.copyWith(
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, childCount: dummyCountries.length),
                      );
                    },
                    orElse: () =>
                        const SliverToBoxAdapter(child: SizedBox.shrink()),
                  );
                },
              ),

              SliverToBoxAdapter(
                child: const SizedBox(height: 120), // Padding for tab bar
              ),
            ],
          ),
        ),
          ); // end of Scaffold
        },
      ),
    );
  }
}
