import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.separator,
      highlightColor: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.s24,
                vertical: AppSpacings.s16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              child: Container(
                width: 200,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: AppSpacings.s24),

            // Beer of the day
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              child: Container(
                height: 420,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),

            SizedBox(height: AppSpacings.s48),

            // Recommendations Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacings.s16),

            // Recommendations List
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: EdgeInsets.only(right: AppSpacings.s16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt<BeerCubit>()
            ..loadBeerOfTheDay()
            ..loadDiscoverData(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<BeerCubit, BeerState>(
            builder: (context, beerState) {
              return beerState.maybeWhen(
                loading: () => _buildSkeleton(),
                error: (msg) => Center(
                  child: Text(
                    msg,
                    style: AppTypography.body.copyWith(color: Colors.red),
                  ),
                ),
                loaded: (history, recommendations, topCountries, topRatedBeers, beerOfTheDay, _, matchedBeers) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacings.s24,
                            vertical: AppSpacings.s16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    final name =
                                        Supabase
                                                .instance
                                                .client
                                                .auth
                                                .currentUser
                                                ?.userMetadata?['name']
                                            as String? ??
                                        '';
                                    return Text(
                                      '${AppLocalizations.of(context)!.discoverGreetingHello}${name.isNotEmpty ? name : AppLocalizations.of(context)!.discoverGreetingDefaultName}',
                                      style: AppTypography.largeTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.separator,
                                  ),
                                ),
                                child: const Icon(
                                  CupertinoIcons.search,
                                  color: AppColors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacings.s24,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.discoverSubtitle,
                            style: AppTypography.body.copyWith(
                              color: AppColors.labelSecondary,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacings.s24),

                        // Beer of the day
                        if (beerOfTheDay != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacings.s24,
                            ),
                            child: GestureDetector(
                              onTap: () =>
                                  context.push('/main/beer/${beerOfTheDay.id}'),
                              child: Container(
                                height: 420,
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            beerOfTheDay.imageUrl.isNotEmpty
                                            ? beerOfTheDay.imageUrl
                                            : 'https://media.screensdesign.com/image-placeholder.jpg',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                              baseColor: AppColors.separator,
                                              highlightColor:
                                                  AppColors.background,
                                              child: Container(
                                                color: Colors.white,
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              color: AppColors.accentTint,
                                              child: const Icon(
                                                CupertinoIcons.drop,
                                                color: AppColors.accent,
                                              ),
                                            ),
                                      ),
                                    ),
                                    // Gradient
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: const Alignment(
                                              0,
                                              0.2,
                                            ), // Gradient ends slightly below center
                                            colors: [
                                              AppColors.black.withValues(
                                                alpha: 0.9,
                                              ),
                                              AppColors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Content
                                    Positioned(
                                      bottom: 24,
                                      left: 24,
                                      right: 24,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.accent,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!.discoverBeerOfTheDayLabel,
                                              style: AppTypography.caption
                                                  .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            beerOfTheDay.name,
                                            style: AppTypography.largeTitle
                                                .copyWith(
                                                  color: AppColors.white,
                                                  fontSize: 36,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${beerOfTheDay.brewery} • ${beerOfTheDay.style}',
                                            style: AppTypography.subhead
                                                .copyWith(
                                                  color: AppColors.white
                                                      .withValues(alpha: 0.8),
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

                        SizedBox(height: AppSpacings.s48),

                        // Recommendations
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacings.s24,
                          ),
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
                              SizedBox(width: 8),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacings.s24,
                            ),
                            itemCount: recommendations.length,
                            itemBuilder: (context, index) {
                              final recommendation = recommendations[index];
                              return GestureDetector(
                                onTap: () => context.push(
                                  '/main/beer/${recommendation.id}',
                                ),
                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.only(
                                    right: AppSpacings.s16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              recommendation.imageUrl.isNotEmpty
                                              ? recommendation.imageUrl
                                              : 'https://media.screensdesign.com/image-placeholder.jpg',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                baseColor: AppColors.separator,
                                                highlightColor:
                                                    AppColors.background,
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                color: AppColors.accentTint,
                                                child: const Icon(
                                                  CupertinoIcons.drop,
                                                  color: AppColors.accent,
                                                ),
                                              ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        color: AppColors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              style: AppTypography.caption
                                                  .copyWith(
                                                    color: AppColors
                                                        .labelSecondary,
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

                        // Top Countries Section
                        SizedBox(height: AppSpacings.s48),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                          child: Text(
                            AppLocalizations.of(context)!.discoverTopCountries,
                            style: AppTypography.title2,
                          ),
                        ),
                        SizedBox(height: AppSpacings.s16),
                        SizedBox(
                          height: 136, // Increased to fix overflow
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                            itemCount: topCountries.length,
                            itemBuilder: (context, index) {
                              final country = topCountries[index];
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 120,
                                  margin: EdgeInsets.only(right: AppSpacings.s16),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        country['flag'] as String,
                                        style: TextStyle(fontSize: 32),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        country['name'] as String,
                                        style: AppTypography.subhead,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        AppLocalizations.of(context)!.beersCount(country['count'] as int),
                                        style: AppTypography.caption.copyWith(color: AppColors.labelSecondary),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Top Rated Beers Section
                        SizedBox(height: AppSpacings.s48),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                          child: Text(
                            AppLocalizations.of(context)!.discoverTopRated,
                            style: AppTypography.title2,
                          ),
                        ),
                        SizedBox(height: AppSpacings.s16),
                        SizedBox(
                          height: 240, // Taller to fit stars
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                            itemCount: topRatedBeers.length,
                            itemBuilder: (context, index) {
                              final beer = topRatedBeers[index];
                              return GestureDetector(
                                onTap: () => context.push('/main/beer/${beer.id}'),
                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.only(right: AppSpacings.s16),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: CachedNetworkImage(
                                          imageUrl: beer.imageUrl.isNotEmpty
                                              ? beer.imageUrl
                                              : 'https://media.screensdesign.com/image-placeholder.jpg',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Shimmer.fromColors(
                                            baseColor: AppColors.separator,
                                            highlightColor: AppColors.background,
                                            child: Container(color: Colors.white),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            color: AppColors.accentTint,
                                            child: const Icon(
                                              CupertinoIcons.drop,
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(12),
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

                        // Matched to DNA Section
                        if (matchedBeers.isNotEmpty) ...[
                          SizedBox(height: AppSpacings.s48),
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
                                final matchPercent = context.read<BeerCubit>().calculateMatchPercentage(beer);
                                return GestureDetector(
                                  onTap: () => context.push('/main/beer/${beer.id}'),
                                  child: Container(
                                    width: 160, // Slightly wider for the badge
                                    margin: EdgeInsets.only(right: AppSpacings.s16),
                                    decoration: BoxDecoration(
                                      color: AppColors.card,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
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
                                              child: CachedNetworkImage(
                                                imageUrl: beer.imageUrl.isNotEmpty
                                                    ? beer.imageUrl
                                                    : 'https://media.screensdesign.com/image-placeholder.jpg',
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Shimmer.fromColors(
                                                  baseColor: AppColors.separator,
                                                  highlightColor: AppColors.background,
                                                  child: Container(color: Colors.white),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  color: AppColors.accentTint,
                                                  child: const Icon(
                                                    CupertinoIcons.drop,
                                                    color: AppColors.accent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(12),
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
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.accent,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '$matchPercent% dopasowania',
                                              style: AppTypography.caption.copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10, // Small enough to fit
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
                      ],
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
    );
  }
}
