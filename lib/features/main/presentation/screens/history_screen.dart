import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_segmented_control.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

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
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacings.s16),
            child: AppCard(
              padding: EdgeInsets.all(AppSpacings.s16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: AppSpacings.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 150, height: 16, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(width: 100, height: 12, color: Colors.white),
                        const SizedBox(height: 12),
                        Container(width: 40, height: 14, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BeerCubit>()..loadHistory(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    3: AppLocalizations.of(context)!.historyTabHistory,
                  },
                  groupValue: _segmentedIndex,
                  onValueChanged: (val) =>
                      setState(() => _segmentedIndex = val as int),
                ),
              ),
              Expanded(
                child: BlocBuilder<BeerCubit, BeerState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => _buildSkeleton(),
                      error: (msg) => Center(
                        child: Text(
                          msg,
                          style: AppTypography.body.copyWith(color: Colors.red),
                        ),
                      ),
                      loaded: (history, recommendations, _, __, beerOfTheDay, selectedBeer, matchedBeers) {
                        if (history.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.historyEmptyState,
                              style: AppTypography.body,
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.only(
                            left: AppSpacings.s24,
                            right: AppSpacings.s24,
                            bottom: 120, // Tab bar padding
                          ),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final beer = history[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: AppSpacings.s16),
                              child: AppCard(
                                padding: EdgeInsets.all(AppSpacings.s16),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () =>
                                      context.push('/main/beer/${beer.id}'),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: AppColors.separator,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          CupertinoIcons.photo,
                                          color: AppColors.labelSecondary,
                                        ),
                                      ),
                                      SizedBox(width: AppSpacings.s16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              beer.name,
                                              style: AppTypography.subhead,
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              '${beer.brewery} • ${beer.style}',
                                              style: AppTypography.caption
                                                  .copyWith(
                                                    color: AppColors
                                                        .labelSecondary,
                                                  ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.star_fill,
                                                  size: 14,
                                                  color: AppColors.gold,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  beer.rating.toString(),
                                                  style: AppTypography.caption,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      orElse: () => SizedBox.shrink(),
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
}
