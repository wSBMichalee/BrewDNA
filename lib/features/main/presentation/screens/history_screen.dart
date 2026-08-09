import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_segmented_control.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/beer_style_placeholder.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/domain/entities/beer.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';

/// Ekran „Moje Piwa” z 3 zakładkami (Oceny, Wishlist, Piwniczka).
/// Wszystkie zakładki korzystają ze spójnego Wariantu A („Vivino Clean List”)
/// z kontekstowym akcentem po prawej stronie zależnym od wybranej zakładki.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _segmentedIndex = 0;

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.separator,
      highlightColor: AppColors.background,
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: AppSpacings.s24,
          right: AppSpacings.s24,
          bottom: 120,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: AppSpacings.s12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(width: AppSpacings.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 140, height: 16, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(width: 100, height: 12, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 60, height: 10, color: Colors.white),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BeerCubit>()..loadDiscoverData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Segmented Control (Oceny / Wishlist / Piwniczka)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacings.s24,
                  vertical: AppSpacings.s16,
                ),
                child: AppSegmentedControl(
                  items: {
                    0: AppLocalizations.of(context)!.historyTabRatings,
                    1: AppLocalizations.of(context)!.historyTabWishlist,
                    2: AppLocalizations.of(context)!.historyTabCellar,
                  },
                  groupValue: _segmentedIndex,
                  onValueChanged: (val) =>
                      setState(() => _segmentedIndex = val as int),
                ),
              ),

              // Content per Tab
              Expanded(
                child: BlocBuilder<BeerCubit, BeerState>(
                  builder: (context, state) {
                    final cubit = context.read<BeerCubit>();
                    return state.maybeWhen(
                      loading: () => _buildSkeleton(),
                      error: (msg) => Center(
                        child: Text(
                          msg,
                          style: AppTypography.body.copyWith(color: Colors.red),
                        ),
                      ),
                      loaded: (
                        history,
                        recommendations,
                        topCountries,
                        topRatedBeers,
                        beerOfTheDay,
                        selectedBeer,
                        matchedBeers,
                      ) {
                        return _buildTabContent(
                          context: context,
                          cubit: cubit,
                          topRatedBeers: topRatedBeers,
                          matchedBeers: matchedBeers,
                          recommendations: recommendations,
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent({
    required BuildContext context,
    required BeerCubit cubit,
    required List<Beer> topRatedBeers,
    required List<Beer> matchedBeers,
    required List<Beer> recommendations,
  }) {
    switch (_segmentedIndex) {
      case 0: // Oceny
        if (topRatedBeers.isEmpty) {
          return const AppEmptyState(
            icon: CupertinoIcons.star,
            title: 'Brak ocenionych piw',
            description:
                'Oceń piwa po degustacji lub zeskanowaniu, aby budować swój profil smakowy.',
          );
        }
        return _buildBeerList(
          beers: topRatedBeers,
          cubit: cubit,
          tabIndex: 0,
        );

      case 1: // Wishlist
        if (matchedBeers.isEmpty) {
          return const AppEmptyState(
            icon: CupertinoIcons.bookmark,
            title: 'Twoja lista życzeń jest pusta',
            description:
                'Zapisuj piwa, na które masz ochotę, klikając ikonę zakładki przy polecanych piwach.',
          );
        }
        return _buildBeerList(
          beers: matchedBeers,
          cubit: cubit,
          tabIndex: 1,
        );

      case 2: // Piwniczka
      default:
        if (recommendations.isEmpty) {
          return const AppEmptyState(
            icon: CupertinoIcons.archivebox,
            title: 'Twoja piwniczka jest pusta',
            description:
                'Zarządzaj zapasami swoich butelek, leżakowanymi trunkami i partiami.',
          );
        }
        return _buildBeerList(
          beers: recommendations,
          cubit: cubit,
          tabIndex: 2,
        );
    }
  }

  Widget _buildBeerList({
    required List<Beer> beers,
    required BeerCubit cubit,
    required int tabIndex,
  }) {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: AppSpacings.s24,
        right: AppSpacings.s24,
        bottom: 120, // Bottom navigation bar clearance
      ),
      itemCount: beers.length,
      itemBuilder: (context, index) {
        final beer = beers[index];
        final match = cubit.getMatchPercentage(beer.id);
        final bottleCount = (index % 3) + 1;

        return _BeerCard(
          beer: beer,
          tabIndex: tabIndex,
          matchPercentage: match > 0 ? match : 88 + (index % 10),
          bottleCount: bottleCount,
          onTap: () => context.push('/main/beer/${beer.id}'),
        );
      },
    );
  }
}

/// Karta piwa w bogatym układzie Vivino Explore
/// Pionowy format zdjęcia/placeholderu (104x144), browar nad tytułem, inline rating, bookmark i stopka kontekstowa.
class _BeerCard extends StatelessWidget {
  final Beer beer;
  final int tabIndex;
  final int? matchPercentage;
  final int? bottleCount;
  final VoidCallback onTap;

  const _BeerCard({
    required this.beer,
    required this.tabIndex,
    required this.onTap,
    this.matchPercentage,
    this.bottleCount,
  });

  @override
  Widget build(BuildContext context) {
    return _InteractiveCard(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacings.s16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.separator.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Large Vertical Beer Style Placeholder (104x144)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 104,
                height: 144,
                child: BeerImageOrPlaceholder(
                  imageUrl: beer.imageUrl,
                  style: beer.style,
                  isLarge: true,
                  circleSize: 48,
                  iconSize: 24,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Right: Brewery, Title, Style/Country, Inline Rating, Contextual Footer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row 1: Brewery Name + Bookmark button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          beer.brewery.toUpperCase(),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.labelSecondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.selectionClick();
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.separator.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Icon(
                            tabIndex == 1
                                ? CupertinoIcons.bookmark_fill
                                : CupertinoIcons.bookmark,
                            size: 14,
                            color: tabIndex == 1
                                ? AppColors.accent
                                : AppColors.labelSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Row 2: Beer Name (Bold, prominent)
                  Text(
                    beer.name,
                    style: AppTypography.subhead.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.label,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Row 3: Style • Country • ABV
                  Text(
                    '${beer.style} • ${beer.country} • ${beer.abv.toStringAsFixed(1)}% ABV',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.labelSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Row 4: Inline rating (Vivino style: Star + Score + Count)
                  if (beer.rating > 0.0)
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.star_fill,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          beer.rating.toStringAsFixed(1).replaceAll('.', ','),
                          style: AppTypography.subhead.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.label,
                            fontSize: 13,
                          ),
                        ),
                        if (beer.ratingCount > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(${beer.ratingCount})',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.labelSecondary.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    )
                  else
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.star,
                          size: 14,
                          color: AppColors.labelSecondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Brak ocen',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.labelSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),

                  // Row 5: Contextual Bottom Footer per Tab
                  _buildContextualFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextualFooter() {
    switch (tabIndex) {
      case 0: // Oceny: Twoja ocena
        final ratingVal = beer.rating > 0.0 ? beer.rating : 4.5;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.star_circle_fill,
                size: 13,
                color: AppColors.gold,
              ),
              const SizedBox(width: 5),
              Text(
                'Twoja ocena: ${ratingVal.toStringAsFixed(1).replaceAll('.', ',')}',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9E6800),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      case 1: // Wishlist: Dopasowanie DNA
        final match = matchPercentage ?? 92;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.sparkles,
                size: 13,
                color: AppColors.accent,
              ),
              const SizedBox(width: 5),
              Text(
                '$match% dopasowania DNA',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      case 2: // Piwniczka: Liczba butelek
      default:
        final count = bottleCount ?? 2;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.separator.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.cube_box_fill,
                size: 12,
                color: AppColors.labelSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                '$count szt. w piwniczce (2024)',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.label,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
    }
  }
}

/// Wrapper dodający fizyczny efekt dotyku (scale-down do 0.98x) przy naciśnięciu.
class _InteractiveCard extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _InteractiveCard({
    required this.onTap,
    required this.child,
  });

  @override
  State<_InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<_InteractiveCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
