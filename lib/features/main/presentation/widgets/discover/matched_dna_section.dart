import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/beer_style_placeholder.dart';
import '../../../../../core/widgets/star_rating.dart';
import '../../../../beer/domain/entities/beer.dart';
import '../../../../beer/presentation/bloc/beer_cubit.dart';
import 'discover_shared.dart';

class MatchedDnaSection extends StatelessWidget {
  final List<Beer> matchedBeers;
  final Animation<double> animation;
  final BeerCubit beerCubit;

  const MatchedDnaSection({
    super.key,
    required this.matchedBeers,
    required this.animation,
    required this.beerCubit,
  });

  @override
  Widget build(BuildContext context) {
    if (matchedBeers.isEmpty) return const SizedBox.shrink();

    return StaggeredAnimatedItem(
      animation: animation,
      index: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
            child: Text(
              AppLocalizations.of(context)!.discoverMatchedDna,
              style: AppTypography.title2,
            ),
          ),
          SizedBox(height: AppSpacings.s16),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              itemCount: matchedBeers.length > 8 ? 8 : matchedBeers.length,
              itemBuilder: (context, index) {
                final beer = matchedBeers[index];
                final matchPercent = beerCubit.getMatchPercentage(beer.id);
                return InteractiveCard(
                  onTap: () => context.push('/main/beer/${beer.id}'),
                  child: Container(
                    width: 160,
                    margin: EdgeInsets.only(right: AppSpacings.s16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: BeerImageOrPlaceholder(
                                imageUrl: beer.imageUrl,
                                style: beer.style,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              color: AppColors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    beer.name,
                                    style: AppTypography.subhead,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    beer.brewery,
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.labelSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  StarRating(
                                    rating: beer.rating,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$matchPercent% dopasowania',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
