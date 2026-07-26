import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt<BeerCubit>()
            ..loadBeerOfTheDay()
            ..loadRecommendations(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<BeerCubit, BeerState>(
            builder: (context, beerState) {
              return beerState.maybeWhen(
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (msg) => Center(child: Text(msg, style: AppTypography.body.copyWith(color: Colors.red))),
                loaded: (history, recommendations, beerOfTheDay, _) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, authState) {
                                    final name = authState.name;
                                    return Text(
                                      'Cześć, ${name.isNotEmpty ? name : 'Michał'}',
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
                                  border: Border.all(color: AppColors.separator),
                                ),
                                child: const Icon(CupertinoIcons.search, color: AppColors.black, size: 20),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                          child: Text(
                            'Oto piwa, które mogą Ci podejść',
                            style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                          ),
                        ),
                        SizedBox(height: AppSpacings.s24),
                        
                        // Beer of the day
                        if (beerOfTheDay != null)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                            child: GestureDetector(
                              onTap: () => context.push('/main/beer/${beerOfTheDay.id}'),
                              child: Container(
                                height: 420,
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
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
                                        imageUrl: 'https://images.unsplash.com/photo-1575037614876-c38556f86523?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(color: AppColors.accentTint),
                                        errorWidget: (context, url, error) => Container(color: AppColors.accentTint, child: const Icon(CupertinoIcons.drop, color: AppColors.accent)),
                                      ),
                                    ),
                                    // Gradient
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: const Alignment(0, 0.2), // Gradient ends slightly below center
                                            colors: [
                                              AppColors.black.withValues(alpha: 0.9),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.accent,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              'PIWO DNIA',
                                              style: AppTypography.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            beerOfTheDay.name,
                                            style: AppTypography.largeTitle.copyWith(color: AppColors.white, fontSize: 36),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${beerOfTheDay.brewery} • ${beerOfTheDay.style}',
                                            style: AppTypography.subhead.copyWith(color: AppColors.white.withValues(alpha: 0.8)),
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
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Polecane dla Ciebie', style: AppTypography.title2),
                              Text('Zobacz wszystkie', style: AppTypography.subhead.copyWith(color: AppColors.accent)),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacings.s16),
                        
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                            itemCount: recommendations.length,
                            itemBuilder: (context, index) {
                              final recommendation = recommendations[index];
                              return GestureDetector(
                                onTap: () => context.push('/main/beer/${recommendation.id}'),
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
                                          // Placeholder images for recommendations
                                          imageUrl: index % 2 == 0 
                                              ? 'https://images.unsplash.com/photo-1566633806327-68e152aaf26d?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80'
                                              : 'https://images.unsplash.com/photo-1582220107107-590dc8b0fad3?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(color: AppColors.accentTint),
                                          errorWidget: (context, url, error) => Container(color: AppColors.accentTint, child: const Icon(CupertinoIcons.drop, color: AppColors.accent)),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        color: AppColors.white,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                              style: AppTypography.caption.copyWith(color: AppColors.labelSecondary),
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
