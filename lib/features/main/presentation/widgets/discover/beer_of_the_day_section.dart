import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/beer_style_placeholder.dart';
import '../../../../beer/domain/entities/beer.dart';
import 'discover_shared.dart';

class BeerOfTheDaySection extends StatelessWidget {
  final Beer beer;
  final Animation<double> animation;

  const BeerOfTheDaySection({
    super.key,
    required this.beer,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredAnimatedItem(
      animation: animation,
      index: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacings.s24,
        ),
        child: InteractiveCard(
          onTap: () => context.push('/main/beer/${beer.id}'),
          child: Container(
            height: 420,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: BeerImageOrPlaceholder(
                    imageUrl: beer.imageUrl,
                    style: beer.style,
                    isLarge: true,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: const Alignment(0, 0.2),
                        colors: [
                          AppColors.black.withValues(alpha: 0.9),
                          AppColors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.discoverBeerOfTheDayLabel,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        beer.name,
                        style: AppTypography.largeTitle.copyWith(
                          color: AppColors.white,
                          fontSize: 36,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${beer.brewery} • ${beer.style}',
                        style: AppTypography.subhead.copyWith(
                          color: AppColors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
