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
import '../../../../core/widgets/beer_style_placeholder.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';
import '../../../../core/widgets/app_error_widget.dart';

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
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.card,
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
                  color: AppColors.card,
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
                  color: AppColors.card,
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
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.card,
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
                      color: AppColors.card,
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
                error: (msg) => AppErrorWidget(
                  message: msg,
                  isNoInternet: msg == 'NO_INTERNET',
                  onRetry: () => _beerCubit.loadDiscoverData(),
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
                                        child: BeerImageOrPlaceholder(
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
                                              child: BeerImageOrPlaceholder(
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
                                              child: BeerImageOrPlaceholder(
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
                                                    child: BeerImageOrPlaceholder(
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
