import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../../../core/widgets/taste_slider.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/beer.dart';
import '../../domain/repositories/i_beer_repository.dart';

class BeerDetailsScreen extends StatefulWidget {
  final String id;
  BeerDetailsScreen({super.key, required this.id});

  @override
  State<BeerDetailsScreen> createState() => _BeerDetailsScreenState();
}

class _BeerDetailsScreenState extends State<BeerDetailsScreen> {
  late Future<Beer> _beerFuture;

  @override
  void initState() {
    super.initState();
    // For now we just get a mock beer regardless of ID
    _beerFuture = getIt<IBeerRepository>().getBeerOfTheDay().then((res) => res.fold((l) => throw l, (r) => r));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<Beer>(
        future: _beerFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CupertinoActivityIndicator());
          final beer = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.background,
                leading: IconButton(
                  icon: Icon(CupertinoIcons.back, color: AppColors.white),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/main/discover');
                    }
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: AppColors.card,
                        child: Center(child: Icon(CupertinoIcons.photo, size: 100, color: AppColors.separator)),
                      ),
                      // Gradient for readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.black.withOpacity(0.6), AppColors.transparent, AppColors.background],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(AppSpacings.s24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(beer.name, style: AppTypography.largeTitle),
                    SizedBox(height: AppSpacings.s4),
                    Text('${beer.brewery} • ${beer.style}', style: AppTypography.title2.copyWith(color: AppColors.labelSecondary, fontWeight: FontWeight.normal)),
                    SizedBox(height: AppSpacings.s16),
                    Row(
                      children: [
                        StarRating(rating: beer.rating),
                        SizedBox(width: AppSpacings.s8),
                        Text(beer.rating.toString(), style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                        Spacer(),
                        Text('${beer.abv}% ABV', style: AppTypography.body),
                      ],
                    ),
                    SizedBox(height: AppSpacings.s48),
                    Text('Profil Smakowy', style: AppTypography.title2),
                    SizedBox(height: AppSpacings.s24),
                    _buildReadonlySlider('Lekkie', 'Mocne', beer.lightStrong),
                    SizedBox(height: AppSpacings.s16),
                    _buildReadonlySlider('Słodkie', 'Gorzkie', beer.bitterSweet),
                    SizedBox(height: AppSpacings.s16),
                    _buildReadonlySlider('Owocowe', 'Wytrawne', beer.dryFruity),
                    SizedBox(height: AppSpacings.s16),
                    _buildReadonlySlider('Chrupkie', 'Słodowe', beer.crispMalty),
                    SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReadonlySlider(String left, String right, double value) {
    return AbsorbPointer( // Makes it read-only
      child: TasteSlider(
        leftLabel: left,
        rightLabel: right,
        value: value,
        onChanged: (v) {},
      ),
    );
  }
}
