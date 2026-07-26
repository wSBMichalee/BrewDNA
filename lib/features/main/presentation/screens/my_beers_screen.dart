import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_segmented_control.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/domain/entities/beer.dart';
import '../../../beer/domain/entities/checkin_record.dart';
import '../../../beer/domain/entities/rated_beer_record.dart';
import '../../../beer/domain/entities/cellar_record.dart';
import '../../../beer/presentation/bloc/my_beers_cubit.dart';
import '../../../beer/presentation/bloc/my_beers_state.dart';

class MyBeersScreen extends StatefulWidget {
  const MyBeersScreen({super.key});

  @override
  State<MyBeersScreen> createState() => _MyBeersScreenState();
}

class _MyBeersScreenState extends State<MyBeersScreen> {
  int _segmentedIndex = 0; // 0: Oceny, 1: Wishlista, 2: Piwniczka, 3: Historia

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pl');
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd MMM', 'pl');
    return formatter.format(date).toUpperCase();
  }

  String _getMonthYear(DateTime date) {
    final formatter = DateFormat('MMMM yyyy', 'pl');
    return formatter.format(date).toUpperCase();
  }

  Widget _buildBeerImage(String url) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: url.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, _) => const Center(child: CupertinoActivityIndicator()),
              errorWidget: (context, _, __) => const Icon(CupertinoIcons.photo, color: AppColors.labelSecondary),
            )
          : const Icon(CupertinoIcons.photo, color: AppColors.labelSecondary),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.s24),
        child: Text(
          message,
          style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(
              i <= rating ? CupertinoIcons.star_fill : (i - 0.5 <= rating ? CupertinoIcons.star_lefthalf_fill : CupertinoIcons.star),
              size: 14,
              color: AppColors.gold,
            ),
          ),
      ],
    );
  }

  Widget _buildListRow({
    required Beer beer,
    required Widget subtitle,
    Widget? thirdLine,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacings.s16),
      child: AppCard(
        padding: EdgeInsets.all(AppSpacings.s16),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap ?? () => context.push('/main/beer/${beer.id}'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBeerImage(beer.imageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(beer.name, style: AppTypography.title3),
                    const SizedBox(height: 4),
                    subtitle,
                    if (thirdLine != null) ...[
                      const SizedBox(height: 8),
                      thirdLine,
                    ]
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 16),
                trailing,
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatings(List<RatedBeerRecord> ratings) {
    if (ratings.isEmpty) return _buildEmptyState('Nie oceniłeś jeszcze żadnego piwa.');
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 120, top: 16),
      itemCount: ratings.length,
      itemBuilder: (context, index) {
        final record = ratings[index];
        final beer = record.beer;
        return _buildListRow(
          beer: beer,
          subtitle: Row(
            children: [
              const Icon(CupertinoIcons.location_solid, size: 12, color: AppColors.accent),
              const SizedBox(width: 4),
              Expanded(child: Text('${beer.brewery} • ${beer.country}', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          thirdLine: _buildRatingStars(record.rating.toDouble()),
          trailing: const Icon(CupertinoIcons.chevron_right, color: AppColors.separator, size: 20),
        );
      },
    );
  }

  Widget _buildWishlist(List<Beer> wishlist) {
    if (wishlist.isEmpty) return _buildEmptyState('Twoja wishlista jest pusta.');
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 120, top: 16),
      itemCount: wishlist.length,
      itemBuilder: (context, index) {
        final beer = wishlist[index];
        return _buildListRow(
          beer: beer,
          subtitle: Row(
            children: [
              const Icon(CupertinoIcons.location_solid, size: 12, color: AppColors.accent),
              const SizedBox(width: 4),
              Expanded(child: Text('${beer.brewery} • ${beer.country}', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          trailing: const Icon(CupertinoIcons.bookmark_fill, color: AppColors.accent, size: 24),
        );
      },
    );
  }

  Widget _buildCellar(List<CellarRecord> cellar) {
    if (cellar.isEmpty) return _buildEmptyState('Twoja piwniczka jest pusta.');
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 120, top: 16),
      itemCount: cellar.length,
      itemBuilder: (context, index) {
        final record = cellar[index];
        final beer = record.beer;
        return _buildListRow(
          beer: beer,
          subtitle: Row(
            children: [
              const Icon(CupertinoIcons.location_solid, size: 12, color: AppColors.accent),
              const SizedBox(width: 4),
              Expanded(child: Text('${beer.brewery} • ${beer.country}', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.accent),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'x${record.quantity}',
              style: AppTypography.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistory(List<CheckinRecord> history) {
    if (history.isEmpty) return _buildEmptyState('Historia degustacji jest pusta.');

    final Map<String, List<CheckinRecord>> grouped = {};
    for (final record in history) {
      final month = _getMonthYear(record.checkinDate);
      grouped.putIfAbsent(month, () => []).add(record);
    }

    final keys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 120, top: 16),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final month = keys[index];
        final records = grouped[month]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 16),
              child: Text(month, style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary, letterSpacing: 1.2)),
            ),
            ...records.map((record) {
              final beer = record.beer;
              // Ideally we'd join ratings to get the user's rating for this checkin, but we use the global rating here for fallback
              // or just don't show stars if we can't join it. According to the design it shows stars.
              return _buildListRow(
                beer: beer,
                subtitle: Row(
                  children: [
                    const Icon(CupertinoIcons.location_solid, size: 12, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Expanded(child: Text(record.locationCity, style: AppTypography.caption.copyWith(color: AppColors.labelSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                thirdLine: _buildRatingStars(beer.rating), // fallback to beer rating
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.accent),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _formatDate(record.checkinDate),
                    style: AppTypography.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyBeersCubit>()..loadAll(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(left: AppSpacings.s24, right: AppSpacings.s24, top: AppSpacings.s24, bottom: AppSpacings.s16),
                child: Text('Moje piwa', style: AppTypography.largeTitle),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: AppSegmentedControl(
                  items: const {0: 'Oceny', 1: 'Wishlista', 2: 'Piwniczka', 3: 'Historia'},
                  groupValue: _segmentedIndex,
                  onValueChanged: (val) => setState(() => _segmentedIndex = val as int),
                ),
              ),
              Expanded(
                child: BlocBuilder<MyBeersCubit, MyBeersState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const Center(child: CupertinoActivityIndicator()),
                      error: (msg) => Center(child: Text(msg, style: AppTypography.body.copyWith(color: AppColors.error))),
                      loaded: (ratings, wishlist, cellar, history) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                          child: IndexedStack(
                            index: _segmentedIndex,
                            children: [
                              _buildRatings(ratings),
                              _buildWishlist(wishlist),
                              _buildCellar(cellar),
                              _buildHistory(history),
                            ],
                          ),
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
}
