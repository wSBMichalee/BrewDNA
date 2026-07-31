import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../bloc/beer_cubit.dart';
import '../bloc/beer_state.dart';
import '../bloc/rating_cubit.dart';
import '../bloc/rating_state.dart';
import 'rate_beer_screen.dart'; // We will create this next

class BeerDetailsScreen extends StatefulWidget {
  final String id;
  const BeerDetailsScreen({super.key, required this.id});

  @override
  State<BeerDetailsScreen> createState() => _BeerDetailsScreenState();
}

class _BeerDetailsScreenState extends State<BeerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BeerCubit>()..loadBeerById(widget.id),
        ),
        BlocProvider(
          create: (context) => getIt<RatingCubit>()..loadBeerRatings(widget.id),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<BeerCubit, BeerState>(
          builder: (context, beerState) {
            return beerState.maybeWhen(
              loading: () => _buildSkeleton(),
              error: (msg) => Center(
                child: Text(
                  msg,
                  style: AppTypography.body.copyWith(color: Colors.red),
                ),
              ),
                loaded: (history, recommendations, _, __, beerOfTheDay, selectedBeer, matchedBeers) {
                if (selectedBeer == null) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.beerDetailsEmpty, style: AppTypography.body),
                  );
                }
                final beer = selectedBeer;

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 450,
                      pinned: true,
                      backgroundColor: AppColors.background,
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: AppColors.black.withValues(
                            alpha: 0.3,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: AppColors.white,
                            ),
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/main/discover');
                              }
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.black.withValues(
                              alpha: 0.3,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                CupertinoIcons.share,
                                color: AppColors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.black.withValues(
                              alpha: 0.3,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                CupertinoIcons.bookmark,
                                color: AppColors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: beer.imageUrl.isNotEmpty
                                  ? beer.imageUrl
                                  : 'https://media.screensdesign.com/afprjsia/3cefb0eb-c967-466d-88f5-373b5f92debb.png', // Temporary placeholder matching reference
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: AppColors.separator,
                                highlightColor: AppColors.background,
                                child: Container(color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.card,
                                child: const Center(
                                  child: Icon(
                                    CupertinoIcons.photo,
                                    size: 100,
                                    color: AppColors.separator,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.transparent,
                                    AppColors.background.withValues(alpha: 0.8),
                                    AppColors.background,
                                  ],
                                  stops: const [0.6, 0.9, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        transform: Matrix4.translationValues(0, -32, 0),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacings.s24,
                            vertical: AppSpacings.s32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Badges
                              Row(
                                children: [
                                  _buildBadge(
                                    CupertinoIcons.circle_fill,
                                    AppLocalizations.of(context)!.beerDetailsTopStyle,
                                    AppColors.accent,
                                  ),
                                  SizedBox(width: AppSpacings.s8),
                                  _buildBadge(
                                    CupertinoIcons.circle_fill,
                                    AppLocalizations.of(context)!.beerDetailsTopCountry,
                                    Colors.blue,
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacings.s16),

                              Text(beer.name, style: AppTypography.largeTitle),
                              SizedBox(height: AppSpacings.s8),
                              Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.beerDetailsStyleCountry(beer.style, beer.country),
                                    style: AppTypography.title2.copyWith(
                                      color: AppColors.labelSecondary,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: AppSpacings.s24),
                              const Divider(color: AppColors.separator),
                              SizedBox(height: AppSpacings.s24),

                              // Rating Section
                              BlocBuilder<RatingCubit, RatingState>(
                                builder: (context, ratingState) {
                                  return ratingState.maybeWhen(
                                    loaded: (histogram, reviews, userRating) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              _buildPillButton(
                                                icon: CupertinoIcons.star,
                                                label: AppLocalizations.of(context)!.beerDetailsRate,
                                                onTap: () => _showRateBeerSheet(
                                                  context,
                                                  beer.id,
                                                  beer.name,
                                                  beer.brewery,
                                                  beer.imageUrl,
                                                ),
                                              ),
                                              SizedBox(width: AppSpacings.s8),
                                              _buildPillButton(
                                                icon: CupertinoIcons.ellipsis,
                                                onTap: () {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        AppLocalizations.of(context)!.beerDetailsMoreOptions,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const Spacer(),
                                              if (userRating != null)
                                                _buildPillButton(
                                                  avatarUrl:
                                                      'https://media.screensdesign.com/gasset/b187515082164f9b884126bfdbaf486c_screen_image_michal_c009d732c4.png',
                                                  label:
                                                      AppLocalizations.of(context)!.beerDetailsRated(userRating.toDouble().toString()),
                                                  highlightLabel: true,
                                                  onTap: () =>
                                                      _showRateBeerSheet(
                                                        context,
                                                        beer.id,
                                                        beer.name,
                                                        beer.brewery,
                                                        beer.imageUrl,
                                                      ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: AppSpacings.s32),
                                          Text(
                                            beer.name,
                                            style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              height: 1.1,
                                            ),
                                          ),
                                          SizedBox(height: AppSpacings.s8),
                                          Text(
                                            AppLocalizations.of(context)!.beerDetailsStyleCountry(beer.style, beer.country),
                                            style: AppTypography.title2
                                                .copyWith(
                                                  color:
                                                      AppColors.labelSecondary,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),

                                          SizedBox(height: AppSpacings.s32),
                                          Text(
                                            AppLocalizations.of(context)!.beerDetailsInsightsTitle,
                                            style: AppTypography.title2,
                                          ),
                                          SizedBox(height: AppSpacings.s4),
                                          Text(
                                            AppLocalizations.of(context)!.beerDetailsInsightsSubtitle,
                                            style: AppTypography.body.copyWith(
                                              color: AppColors.labelSecondary,
                                            ),
                                          ),
                                          SizedBox(height: AppSpacings.s16),

                                          Container(
                                            padding: EdgeInsets.all(
                                              AppSpacings.s16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              border: Border.all(
                                                color: AppColors.separator
                                                    .withValues(alpha: 0.5),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: AppColors
                                                      .gold
                                                      .withValues(alpha: 0.2),
                                                  radius: 24,
                                                  child: Icon(
                                                    CupertinoIcons.drop_fill,
                                                    color: AppColors.gold,
                                                  ), // Zastępcza ikona szklanki
                                                ),
                                                SizedBox(
                                                  width: AppSpacings.s16,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        beer.style,
                                                        style: AppTypography
                                                            .subhead
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      Text(
                                                        AppLocalizations.of(context)!.beerDetailsStyleMatch,
                                                        style: AppTypography
                                                            .caption
                                                            .copyWith(
                                                              color: AppColors
                                                                  .labelSecondary,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    orElse: () => Shimmer.fromColors(
                                      baseColor: AppColors.separator,
                                      highlightColor: AppColors.background,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                width: 50,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 32),
                                          Container(
                                            width: 200,
                                            height: 40,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: 150,
                                            height: 24,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 32),
                                          Container(
                                            width: 120,
                                            height: 24,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            width: 180,
                                            height: 16,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.separator),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPillButton({
    IconData? icon,
    String? avatarUrl,
    String? label,
    bool highlightLabel = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.separator.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.gold),
              if (label != null) const SizedBox(width: 8),
            ],
            if (avatarUrl != null) ...[
              CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              if (label != null) const SizedBox(width: 8),
            ],
            if (label != null)
              Text(
                label,
                style: AppTypography.subhead.copyWith(
                  fontWeight: FontWeight.bold,
                  color: highlightLabel ? AppColors.gold : AppColors.label,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showRateBeerSheet(
    BuildContext parentContext,
    String beerId,
    String beerName,
    String breweryName,
    String imageUrl,
  ) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: parentContext.read<RatingCubit>(),
        child: RateBeerScreen(
          beerId: beerId,
          beerName: beerName,
          breweryName: breweryName,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.separator,
      highlightColor: AppColors.background,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              transform: Matrix4.translationValues(0, -32, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacings.s24,
                  vertical: AppSpacings.s32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 120,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(width: 200, height: 24, color: Colors.white),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 50,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Container(width: 250, height: 40, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 200, height: 24, color: Colors.white),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
