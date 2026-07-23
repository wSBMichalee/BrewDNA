import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/domain/entities/beer.dart';
import '../../../beer/domain/repositories/i_beer_repository.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late Future<Beer> _beerOfTheDayFuture;
  late Future<List<Beer>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    final repo = getIt<IBeerRepository>();
    _beerOfTheDayFuture = repo.getBeerOfTheDay().then((res) => res.fold((l) => throw l, (r) => r));
    _recommendationsFuture = repo.getRecommendations().then((res) => res.fold((l) => [], (r) => r));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
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
              FutureBuilder<Beer>(
                future: _beerOfTheDayFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CupertinoActivityIndicator());
                  final beer = snapshot.data!;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                    child: GestureDetector(
                      onTap: () => context.push('/main/beer/${beer.id}'),
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
                              colors: [AppColors.black.withOpacity(0.8), AppColors.transparent],
                            ),
                          ),
                          padding: EdgeInsets.all(AppSpacings.s16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(beer.name, style: AppTypography.title2.copyWith(color: AppColors.white)),
                              Text('${beer.brewery} • ${beer.style}', style: AppTypography.caption.copyWith(color: AppColors.white.withValues(alpha: 0.70))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: AppSpacings.s32),
              
              // Recommendations
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Text('Dla Ciebie', style: AppTypography.title2),
              ),
              SizedBox(height: AppSpacings.s16),
              
              FutureBuilder<List<Beer>>(
                future: _recommendationsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CupertinoActivityIndicator());
                  final beers = snapshot.data!;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                    itemCount: beers.length,
                    itemBuilder: (context, index) {
                      final beer = beers[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppSpacings.s16),
                        child: AppCard(
                          padding: EdgeInsets.all(AppSpacings.s16),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => context.push('/main/beer/${beer.id}'),
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
                                      Text(beer.name, style: AppTypography.subhead),
                                      SizedBox(height: 2),
                                      Text('${beer.brewery} • ${beer.style}', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
