import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/beer_style_placeholder.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';

class ProfileHistorySection extends StatelessWidget {
  const ProfileHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeerCubit, BeerState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
            child: Shimmer.fromColors(
              baseColor: AppColors.separator,
              highlightColor: AppColors.background,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          error: (msg) => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
            child: Text(
              msg,
              style: AppTypography.caption.copyWith(color: Colors.red),
            ),
          ),
          loaded: (history, recommendations, cachedHistory, cachedRecs, beerOfTheDay, selectedBeer, matchedBeers) {
            if (history.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Container(
                  padding: EdgeInsets.all(AppSpacings.s20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.historyEmptyState,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.labelSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              itemCount: history.length > 5 ? 5 : history.length,
              itemBuilder: (context, index) {
                final beer = history[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacings.s12),
                  child: AppCard(
                    padding: EdgeInsets.all(AppSpacings.s16),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.push('/main/beer/${beer.id}'),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: BeerImageOrPlaceholder(
                                imageUrl: beer.imageUrl,
                                style: beer.style,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacings.s16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  beer.name,
                                  style: AppTypography.subhead.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${beer.brewery} • ${beer.style}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.labelSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.star_fill,
                                size: 14,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                beer.rating.toString(),
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }


}
