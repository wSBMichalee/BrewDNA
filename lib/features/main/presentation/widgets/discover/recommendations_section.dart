import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/beer_style_placeholder.dart';
import '../../../../beer/domain/entities/beer.dart';
import 'discover_shared.dart';

class RecommendationsSection extends StatelessWidget {
  final List<Beer> recommendations;
  final Animation<double> animation;

  const RecommendationsSection({
    super.key,
    required this.recommendations,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return StaggeredAnimatedItem(
      animation: animation,
      index: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.discoverRecommendedTitle,
                    style: AppTypography.title2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.discoverSeeAll,
                  style: AppTypography.subhead.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacings.s16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final recommendation = recommendations[index];
                return InteractiveCard(
                  onTap: () => context.push('/main/beer/${recommendation.id}'),
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
                            imageUrl: recommendation.imageUrl,
                            style: recommendation.style,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: AppColors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recommendation.name,
                                style: AppTypography.subhead,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                recommendation.brewery,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.labelSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
