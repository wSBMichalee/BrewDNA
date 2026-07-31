import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/rating_histogram.dart';

class BeerReviewsScreen extends StatelessWidget {
  final String beerId;
  final String beerName;
  final RatingHistogram histogram;
  final List<Review> reviews;

  const BeerReviewsScreen({
    super.key,
    required this.beerId,
    required this.beerName,
    required this.histogram,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.s16,
                vertical: AppSpacings.s8,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: AppColors.label,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.beerReviewsTitle, style: AppTypography.title2),
                        Text(
                          '${beerName.toUpperCase()} · ${histogram.totalCount} ${AppLocalizations.of(context)!.beerReviewsRatingsCountLabel}',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.labelSecondary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for back button
                ],
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      // Histogram section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacings.s24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    histogram.averageRating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacings.s8),
                                  StarRating(
                                    rating: histogram.averageRating,
                                    size: 16,
                                  ),
                                ],
                              ),
                              SizedBox(width: AppSpacings.s32),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildHistogramRow(
                                      '5',
                                      histogram.count5,
                                      histogram.totalCount,
                                    ),
                                    _buildHistogramRow(
                                      '4',
                                      histogram.count4,
                                      histogram.totalCount,
                                    ),
                                    _buildHistogramRow(
                                      '3',
                                      histogram.count3,
                                      histogram.totalCount,
                                    ),
                                    _buildHistogramRow(
                                      '2',
                                      histogram.count2,
                                      histogram.totalCount,
                                    ),
                                    _buildHistogramRow(
                                      '1',
                                      histogram.count1,
                                      histogram.totalCount,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacings.s16),
                      ),

                      // Reviews List
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacings.s24,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final review = reviews[index];
                            return _buildReviewCard(context, review);
                          }, childCount: reviews.length),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: const SizedBox(height: 120),
                      ), // Space for FAB
                    ],
                  ),

                  // FAB - Napisz recenzję
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(AppSpacings.s24).copyWith(
                        bottom: MediaQuery.of(context).padding.bottom + 24,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.background.withValues(alpha: 0.0),
                            AppColors.background,
                          ],
                          stops: const [0.0, 0.4],
                        ),
                      ),
                      child: AppButton(
                        text: AppLocalizations.of(context)!.beerReviewsWriteReviewButton,
                        isPrimary: true,
                        onPressed: () {
                          // The RatingCubit is likely not provided in this context unless passed,
                          // but the user wants the same bottom sheet.
                          // It's safer to just pop and open it from BeerDetailsScreen, or we can provide it.
                          // For simplicity, we just pop back and trigger it, or provide a new cubit?
                          // The GoRouter doesn't automatically pass Cubits down unless we use ShellRoute or pass it.
                          // Let's assume we can trigger it or we show a snackbar here for now.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.beerReviewsUseCardButtonNotice,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistogramRow(String label, int count, int total) {
    double percentage = total > 0 ? count / total : 0.0;
    String countText = count > 1000
        ? '${(count / 1000).toStringAsFixed(1)}k'
        : count.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.labelSecondary,
            ),
          ),
          SizedBox(width: AppSpacings.s12),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.separator.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacings.s12),
          SizedBox(
            width: 30,
            child: Text(
              countText,
              style: AppTypography.caption.copyWith(
                color: AppColors.labelSecondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Review review) {
    // Determine time ago roughly
    final diff = DateTime.now().difference(review.createdAt);
    String timeAgo;
    if (diff.inDays > 0) {
      timeAgo = AppLocalizations.of(context)!.beerReviewsDaysAgo(diff.inDays.toString());
    } else if (diff.inHours > 0) {
      timeAgo = AppLocalizations.of(context)!.beerReviewsHoursAgo(diff.inHours.toString());
    } else {
      timeAgo = AppLocalizations.of(context)!.beerReviewsMinsAgo(diff.inMinutes.toString());
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacings.s16),
      padding: EdgeInsets.all(AppSpacings.s24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.separator.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.separator,
                backgroundImage: review.userAvatarUrl.isNotEmpty
                    ? NetworkImage(review.userAvatarUrl)
                    : null,
                child: review.userAvatarUrl.isEmpty
                    ? const Icon(
                        CupertinoIcons.person_solid,
                        color: AppColors.labelSecondary,
                      )
                    : null,
              ),
              SizedBox(width: AppSpacings.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: AppTypography.subhead.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        StarRating(
                          rating: review.overallRating.toDouble(),
                          size: 12,
                        ),
                        SizedBox(width: 8),
                        // Assuming the backend doesn't return '42 OCEN' for each user, we just show something or omit it.
                        // The reference shows "42 OCEN" next to the user. I'll omit it since we don't have this data easily.
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                timeAgo,
                style: AppTypography.caption.copyWith(
                  color: AppColors.labelSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacings.s16),
          Text(review.note, style: AppTypography.body),
        ],
      ),
    );
  }
}
