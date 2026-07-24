import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/domain/entities/beer.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BeerCubit>()
        ..loadBeerOfTheDay()
        ..loadRecommendations(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<BeerCubit, BeerState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => Center(child: CupertinoActivityIndicator()),
                error: (msg) => Center(child: Text(msg, style: AppTypography.body.copyWith(color: Colors.red))),
                loaded: (history, recommendations, beerOfTheDay, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
                          child: Text('Odkryj', style: AppTypography.largeTitle),
                        ),
                        
                        // Beer of the day
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                          child: Text('Piwo dnia', style: AppTypography.title2),
                        ),
                        SizedBox(height: AppSpacings.s16),
                        if (beerOfTheDay != null)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                            child: GestureDetector(
                              onTap: () => context.push('/main/beer/${beerOfTheDay.id}'),
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage('https://images.unsplash.com/photo-1575037614876-c38556f86523?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [AppColors.black.withValues(alpha: 0.8), AppColors.transparent],
                                    ),
                                  ),
                                  padding: EdgeInsets.all(AppSpacings.s16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(beerOfTheDay.name, style: AppTypography.title2.copyWith(color: AppColors.white)),
                                      Text('${beerOfTheDay.brewery} • ${beerOfTheDay.style}', style: AppTypography.caption.copyWith(color: AppColors.white.withValues(alpha: 0.70))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        
                        SizedBox(height: AppSpacings.s32),
                        
                        // Recommendations
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                          child: Text('Dla Ciebie', style: AppTypography.title2),
                        ),
                        SizedBox(height: AppSpacings.s16),
                        
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                          itemCount: recommendations.length,
                          itemBuilder: (context, index) {
                            final recommendation = recommendations[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: AppSpacings.s16),
                              child: AppCard(
                                padding: EdgeInsets.all(AppSpacings.s16),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => context.push('/main/beer/${recommendation.id}'),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: AppColors.separator,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(CupertinoIcons.photo, color: AppColors.labelSecondary),
                                      ),
                                      SizedBox(width: AppSpacings.s16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(recommendation.name, style: AppTypography.subhead),
                                            SizedBox(height: 2),
                                            Text('${recommendation.brewery} • ${recommendation.style}', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary)),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(CupertinoIcons.star_fill, size: 14, color: AppColors.gold),
                                                SizedBox(width: 4),
                                                Text(recommendation.rating.toString(), style: AppTypography.caption),
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
                        ),
                      ],
                    ),
                  );
                },
                orElse: () => SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
    );
  }
}
