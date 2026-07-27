import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_segmented_control.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/domain/entities/beer.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _segmentedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BeerCubit>()..loadHistory(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
                child: AppSegmentedControl(
                  items: const {0: 'Oceny', 1: 'Wishlista', 2: 'Piwniczka', 3: 'Historia'},
                  groupValue: _segmentedIndex,
                  onValueChanged: (val) => setState(() => _segmentedIndex = val as int),
                ),
              ),
              Expanded(
                child: BlocBuilder<BeerCubit, BeerState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => Center(child: CupertinoActivityIndicator()),
                      error: (msg) => Center(child: Text(msg, style: AppTypography.body.copyWith(color: Colors.red))),
                      loaded: (history, _, __, ___) {
                        if (history.isEmpty) {
                          return Center(child: Text('Brak danych', style: AppTypography.body));
                        }
                        
                        return ListView.builder(
                          padding: EdgeInsets.only(
                            left: AppSpacings.s24,
                            right: AppSpacings.s24,
                            bottom: 120, // Tab bar padding
                          ),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final beer = history[index];
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
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(CupertinoIcons.star_fill, size: 14, color: AppColors.gold),
                                                SizedBox(width: 4),
                                                Text(beer.rating.toString(), style: AppTypography.caption),
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
                        );
                      },
                      orElse: () => SizedBox.shrink(),
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
