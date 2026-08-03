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

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  late final BeerCubit _beerCubit;
  late final AnimationController _staggerController;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _beerCubit = getIt<BeerCubit>();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    // Nie ładuj danych jeśli cubit jest już w stanie loaded z danymi
    // (powrót na ekran z innej zakładki, back z detail, itp.)
    _beerCubit.state.maybeWhen(
      loaded: (history, recommendations, topCountries, topRatedBeers, beerOfTheDay, _, matchedBeers) {
        _hasAnimated = true;
        _staggerController.value = 1.0;
        if (recommendations.isEmpty && topRatedBeers.isEmpty && beerOfTheDay == null) {
          _beerCubit.loadDiscoverData();
        }
      },
      orElse: () {
        _beerCubit.loadDiscoverData();
      },
    );
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

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
    return BlocProvider.value(
      value: _beerCubit,
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
                  // Uruchom animację tylko raz przy pierwszym załadowaniu danych
                  if (!_hasAnimated &&
                      (recommendations.isNotEmpty ||
                          topRatedBeers.isNotEmpty ||
                          beerOfTheDay != null)) {
                    _hasAnimated = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _staggerController.forward();
                      }
                    });
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        _StaggeredAnimatedItem(
                          animation: _staggerController,
                          index: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                            style: AppTypography.pageHeadline,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
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
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacings.s24),

                        // Beer of the day
                        if (beerOfTheDay != null)
                          _StaggeredAnimatedItem(
                            animation: _staggerController,
                            index: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacings.s24,
                              ),
                              child: _InteractiveCard(
                                onTap: () =>
                                    context.push('/main/beer/${beerOfTheDay.id}'),
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
                                      // Image / Rich placeholder
                                      Positioned.fill(
                                        child: _BeerImageOrPlaceholder(
                                          imageUrl: beerOfTheDay.imageUrl,
                                          style: beerOfTheDay.style,
                                          isLarge: true,
                                        ),
                                      ),
                                      // Gradient overlay for readability
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: const Alignment(0, 0.2),
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
                                              padding: const EdgeInsets.symmetric(
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
                          ),

                        SizedBox(height: AppSpacings.s48),

                        // Recommendations
                        _StaggeredAnimatedItem(
                          animation: _staggerController,
                          index: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacings.s24,
                                  ),
                                  itemCount: recommendations.length,
                                  itemBuilder: (context, index) {
                                    final recommendation = recommendations[index];
                                    return _InteractiveCard(
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
                                                alpha: 0.08,
                                              ),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.03,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: _BeerImageOrPlaceholder(
                                                imageUrl: recommendation.imageUrl,
                                                style: recommendation.style,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(12),
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
                            ],
                          ),
                        ),

                        // Top Countries Section
                        SizedBox(height: AppSpacings.s48),
                        _StaggeredAnimatedItem(
                          animation: _staggerController,
                          index: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                                child: Text(
                                  AppLocalizations.of(context)!.discoverTopCountries,
                                  style: AppTypography.title2,
                                ),
                              ),
                              SizedBox(height: AppSpacings.s16),
                              SizedBox(
                                height: 136,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                                  itemCount: topCountries.length,
                                  itemBuilder: (context, index) {
                                    final country = topCountries[index];
                                    return _InteractiveCard(
                                      onTap: () {},
                                      child: Container(
                                        width: 120,
                                        margin: EdgeInsets.only(right: AppSpacings.s16),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.card,
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.06),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              country['flag'] as String,
                                              style: const TextStyle(fontSize: 32),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              country['name'] as String,
                                              style: AppTypography.subhead,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 4),
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
                            ],
                          ),
                        ),

                        // Top Rated Beers Section
                        SizedBox(height: AppSpacings.s48),
                        _StaggeredAnimatedItem(
                          animation: _staggerController,
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
                                    return _InteractiveCard(
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
                                              child: _BeerImageOrPlaceholder(
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
                        ),

                        // Matched to DNA Section
                        if (matchedBeers.isNotEmpty) ...[
                          SizedBox(height: AppSpacings.s48),
                          _StaggeredAnimatedItem(
                            animation: _staggerController,
                            index: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      final matchPercent = _beerCubit.getMatchPercentage(beer.id);
                                      return _InteractiveCard(
                                        onTap: () => context.push('/main/beer/${beer.id}'),
                                        child: Container(
                                          width: 160,
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
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Expanded(
                                                    child: _BeerImageOrPlaceholder(
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
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.accent,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    '$matchPercent% dopasowania',
                                                    style: AppTypography.caption.copyWith(
                                                      color: AppColors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
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

/// Helper tematyczny mapujący styl piwa na odpowiednią ikonę i gradient.
class _BeerStyleTheme {
  final IconData icon;
  final List<Color> gradientColors;
  final Color iconColor;

  const _BeerStyleTheme({
    required this.icon,
    required this.gradientColors,
    required this.iconColor,
  });

  static _BeerStyleTheme fromStyle(String? styleName) {
    final s = (styleName ?? '').toLowerCase();
    if (s.contains('ipa') || s.contains('pale') || s.contains('hazy') || s.contains('hop')) {
      return const _BeerStyleTheme(
        icon: CupertinoIcons.sparkles,
        gradientColors: [Color(0xFF162B0E), Color(0xFF38571E), Color(0xFF8F6315)],
        iconColor: Color(0xFFF9E8A2),
      );
    } else if (s.contains('lager') || s.contains('pils')) {
      return const _BeerStyleTheme(
        icon: CupertinoIcons.sun_max_fill,
        gradientColors: [Color(0xFF4A3405), Color(0xFF9E6E10), Color(0xFFD49A24)],
        iconColor: Color(0xFFFFF7D6),
      );
    } else if (s.contains('stout')) {
      return const _BeerStyleTheme(
        icon: CupertinoIcons.moon_stars_fill,
        gradientColors: [Color(0xFF0D0603), Color(0xFF1E0E06), Color(0xFF3B1E0C)],
        iconColor: Color(0xFFE8BA87),
      );
    } else if (s.contains('porter')) {
      return const _BeerStyleTheme(
        icon: CupertinoIcons.moon_fill,
        gradientColors: [Color(0xFF180A04), Color(0xFF30180A), Color(0xFF572F15)],
        iconColor: Color(0xFFF0CCA0),
      );
    } else if (s.contains('weizen') || s.contains('wheat') || s.contains('pszen')) {
      return const _BeerStyleTheme(
        icon: CupertinoIcons.wind,
        gradientColors: [Color(0xFF45300B), Color(0xFF8C6618), Color(0xFFC99832)],
        iconColor: Color(0xFFFFFBE8),
      );
    } else if (s.contains('sour') || s.contains('kwas') || s.contains('gose') || s.contains('lambic')) {
      return const _BeerStyleTheme(
        icon: CupertinoIcons.drop_triangle_fill,
        gradientColors: [Color(0xFF2E0A2B), Color(0xFF5C1A57), Color(0xFF993D90)],
        iconColor: Color(0xFFFFD4F5),
      );
    } else if (s.contains('amber') || s.contains('belgian') || s.contains('ale') || s.contains('bock') || s.contains('koźlak')) {
      return const _BeerStyleTheme(
        icon: CupertinoIcons.flame_fill,
        gradientColors: [Color(0xFF381205), Color(0xFF6E250A), Color(0xFFB85918)],
        iconColor: Color(0xFFFFDFB8),
      );
    } else {
      return const _BeerStyleTheme(
        icon: CupertinoIcons.drop,
        gradientColors: [Color(0xFF261508), Color(0xFF4A2A10), Color(0xFF8A551E)],
        iconColor: Color(0xFFFBE4A8),
      );
    }
  }
}

/// Dynamiczny placeholder z gradientem i ikoną dopasowaną do stylu piwa.
class _BeerStylePlaceholder extends StatelessWidget {
  final String style;
  final bool isLarge;

  const _BeerStylePlaceholder({
    required this.style,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _BeerStyleTheme.fromStyle(style);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.gradientColors,
        ),
      ),
      child: Center(
        child: Container(
          width: isLarge ? 64 : 40,
          height: isLarge ? 64 : 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.25),
            border: Border.all(
              color: theme.iconColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Icon(
            theme.icon,
            size: isLarge ? 32 : 20,
            color: theme.iconColor,
          ),
        ),
      ),
    );
  }
}

/// Inteligentny widget obrazka: jeśli URL jest placeholderem/404, natychmiast
/// renderuje _BeerStylePlaceholder bez wykonywania niepotrzebnych requestów HTTP.
class _BeerImageOrPlaceholder extends StatelessWidget {
  final String imageUrl;
  final String style;
  final bool isLarge;

  const _BeerImageOrPlaceholder({
    required this.imageUrl,
    required this.style,
    this.isLarge = false,
  });

  bool get _hasRealImage {
    if (imageUrl.isEmpty) return false;
    if (imageUrl.contains('image-placeholder') ||
        imageUrl.contains('placeholder') ||
        imageUrl.contains('screensdesign.com')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasRealImage) {
      return _BeerStylePlaceholder(
        style: style,
        isLarge: isLarge,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.separator,
        highlightColor: AppColors.background,
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, url, error) => _BeerStylePlaceholder(
        style: style,
        isLarge: isLarge,
      ),
    );
  }
}

/// Wrapper dodający fizyczny efekt dotyku (scale-down do 0.97x) przy naciśnięciu.
class _InteractiveCard extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _InteractiveCard({
    required this.onTap,
    required this.child,
  });

  @override
  State<_InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<_InteractiveCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// Wrapper dodający kaskadowy fade-in + slide-up (20px) przy pierwszym załadowaniu.
/// Używa znormalizowanego przeliczenia postępu bez tworzenia obiektów CurvedAnimation/Interval na klatkę,
/// co gwarantuje pełną widoczność (opacity: 1.0) dla każdego indeksu niezależnie od liczby elementów.
class _StaggeredAnimatedItem extends StatelessWidget {
  final Animation<double> animation;
  final int index;
  final Widget child;

  const _StaggeredAnimatedItem({
    required this.animation,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.1).clamp(0.0, 0.5);
    final end = (start + 0.5).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, animChild) {
        final progress = animation.value;
        final t = end > start
            ? ((progress - start) / (end - start)).clamp(0.0, 1.0)
            : 1.0;
        final curveValue = Curves.easeOutCubic.transform(t);

        return Opacity(
          opacity: curveValue,
          child: Transform.translate(
            offset: Offset(0, (1.0 - curveValue) * 20.0),
            child: animChild,
          ),
        );
      },
      child: child,
    );
  }
}
