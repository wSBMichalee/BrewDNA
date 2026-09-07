import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/beer_style_placeholder.dart';
import '../../../../../core/widgets/star_rating.dart';
import '../../../../beer/domain/entities/beer.dart';
import 'discover_shared.dart';

class TopRatedBeersSection extends StatelessWidget {
  final List<Beer> topRatedBeers;
  final Animation<double> animation;

  const TopRatedBeersSection({
    super.key,
    required this.topRatedBeers,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    if (topRatedBeers.isEmpty) return const SizedBox.shrink();

    return StaggeredAnimatedItem(
      animation: animation,
      index: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
            child: Text(
              AppLocalizations.of(context)!.discoverTopRated,
              style: AppTypography.title2,
            ),
          ),
          SizedBox(height: AppSpacings.s16),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              itemCount: topRatedBeers.length,
              itemBuilder: (context, index) {
                final beer = topRatedBeers[index];
                return InteractiveCard(
                  onTap: () => context.push('/main/beer/${beer.id}'),
                  child: Container(
                    width: 150,
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
                    child: Column(
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
