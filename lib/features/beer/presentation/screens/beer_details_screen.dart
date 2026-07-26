import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../../../core/widgets/app_button.dart';
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
        BlocProvider(create: (context) => getIt<BeerCubit>()..loadBeerById(widget.id)),
        BlocProvider(create: (context) => getIt<RatingCubit>()..loadBeerRatings(widget.id)),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<BeerCubit, BeerState>(
          builder: (context, beerState) {
            return beerState.maybeWhen(
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (msg) => Center(child: Text(msg, style: AppTypography.body.copyWith(color: Colors.red))),
              loaded: (_, __, ___, selectedBeer) {
                if (selectedBeer == null) {
                  return Center(child: Text('Brak danych piwa', style: AppTypography.body));
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
                          backgroundColor: AppColors.black.withValues(alpha: 0.3),
                          child: IconButton(
                            icon: const Icon(CupertinoIcons.back, color: AppColors.white),
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
                            backgroundColor: AppColors.black.withValues(alpha: 0.3),
                            child: IconButton(
                              icon: const Icon(CupertinoIcons.share, color: AppColors.white),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.black.withValues(alpha: 0.3),
                            child: IconButton(
                              icon: const Icon(CupertinoIcons.bookmark, color: AppColors.white),
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
                              imageUrl: beer.imageUrl.isNotEmpty ? beer.imageUrl : 'https://media.screensdesign.com/afprjsia/3cefb0eb-c967-466d-88f5-373b5f92debb.png', // Temporary placeholder matching reference
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.card,
                                child: const Center(child: Icon(CupertinoIcons.photo, size: 100, color: AppColors.separator)),
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
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Badges
                              Row(
                                children: [
                                  _buildBadge(CupertinoIcons.circle_fill, 'TOP 2% W STYLU', AppColors.accent),
                                  SizedBox(width: AppSpacings.s8),
                                  _buildBadge(CupertinoIcons.circle_fill, 'TOP 1% W POLSCE', Colors.blue),
                                ],
                              ),
                              SizedBox(height: AppSpacings.s16),
                              
                              Text(beer.name, style: AppTypography.largeTitle),
                              SizedBox(height: AppSpacings.s8),
                              Text(
                                '${beer.brewery} · ${beer.country}\n${beer.style} · ${beer.abv}% ABV',
                                style: AppTypography.title2.copyWith(color: AppColors.labelSecondary, fontWeight: FontWeight.normal),
                              ),
                              
                              SizedBox(height: AppSpacings.s24),
                              const Divider(color: AppColors.separator),
                              SizedBox(height: AppSpacings.s24),
                              
                              // Rating Section
                              BlocBuilder<RatingCubit, RatingState>(
                                builder: (context, ratingState) {
                                  return ratingState.maybeWhen(
                                    loaded: (histogram, reviews, userRating) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Global Rating
                                          GestureDetector(
                                            onTap: () {
                                              context.push('/main/reviews', extra: {'beerId': beer.id, 'beerName': beer.name, 'histogram': histogram, 'reviews': reviews});
                                            },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(histogram.averageRating.toStringAsFixed(1), style: AppTypography.largeTitle),
                                                SizedBox(width: AppSpacings.s8),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    StarRating(rating: histogram.averageRating, size: 16),
                                                    SizedBox(height: 4),
                                                    Text('${histogram.totalCount} OCEN', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary, letterSpacing: 1.2)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // User Rating
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text('TWOJA OCENA', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary, letterSpacing: 1.2)),
                                              SizedBox(height: 4),
                                              StarRating(rating: userRating?.toDouble() ?? 0.0, size: 16),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    orElse: () => const Center(child: CupertinoActivityIndicator()),
                                  );
                                },
                              ),
                              
                              SizedBox(height: AppSpacings.s32),
                              
                              AppButton(
                                text: 'Oceń to piwo',
                                isPrimary: true,
                                onPressed: () {
                                  _showRateBeerSheet(context, beer.id, beer.name, beer.imageUrl);
                                },
                              ),
                              SizedBox(height: AppSpacings.s16),
                              AppButton(
                                text: 'Dodaj do piwniczki',
                                isPrimary: false,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('TODO: Dodano do piwniczki')),
                                  );
                                },
                              ),
                              
                              SizedBox(height: 100),
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
  
  void _showRateBeerSheet(BuildContext parentContext, String beerId, String beerName, String imageUrl) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: parentContext.read<RatingCubit>(),
        child: RateBeerScreen(beerId: beerId, beerName: beerName, imageUrl: imageUrl),
      ),
    );
  }
}
