import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BeerCubit>()..loadHistory(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacings.s24),
                  child: Column(
                    children: [
                      Text('Mapa świata', style: AppTypography.largeTitle),
                      const SizedBox(height: 8),
                      // TODO: Get actual count of unique countries from user data
                      Text('12 z 195 krajów odkrytych', style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary)),
                    ],
                  ),
                ),
              ),
              
              // Map Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                  child: Container(
                    height: 260,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Map Image Placeholder
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: 'https://media.screensdesign.com/afprjsia/b9d750c3-f6ef-466d-aba7-c452e804f85e.png', // A generic map graphic URL as placeholder, or we can use local asset if available
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) => Container(
                              color: Color(0xFFF5F5F5),
                              child: Icon(CupertinoIcons.map, size: 64, color: AppColors.separator),
                            ),
                          ),
                        ),
                        // Badge
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(CupertinoIcons.globe, color: AppColors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '6% ODKRYTE',
                                  style: AppTypography.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SliverToBoxAdapter(
                child: SizedBox(height: AppSpacings.s32),
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                  child: Text('Ostatnio odkryte', style: AppTypography.title2),
                ),
              ),
              
              SliverToBoxAdapter(
                child: SizedBox(height: AppSpacings.s16),
              ),
              
              // History List from Cubit
              BlocBuilder<BeerCubit, BeerState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () => const SliverToBoxAdapter(child: Center(child: CupertinoActivityIndicator())),
                    loaded: (history, _, __, ___) {
                      if (history.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacings.s24),
                            child: Text('Brak odkrytych piw.', style: AppTypography.body.copyWith(color: AppColors.labelSecondary), textAlign: TextAlign.center),
                          ),
                        );
                      }
                      
                      // For UI purposes, let's map history to some dummy countries if we don't have country in Beer entity
                      // Assuming we fake countries based on index or just list them.
                      // The mock expects "Czechy, Niemcy, Belgia".
                      final dummyCountries = [
                        {'name': 'Czechy', 'flag': '🇨🇿', 'count': '12 piw'},
                        {'name': 'Niemcy', 'flag': '🇩🇪', 'count': '8 piw'},
                        {'name': 'Belgia', 'flag': '🇧🇪', 'count': '5 piw'},
                      ];
                      
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= dummyCountries.length) return null;
                            final country = dummyCountries[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: 8),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Text(country['flag']!, style: const TextStyle(fontSize: 24)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(country['name']!, style: AppTypography.headline),
                                    ),
                                    Text(country['count']!, style: AppTypography.subhead.copyWith(color: AppColors.accent)),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: dummyCountries.length,
                        ),
                      );
                    },
                    orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  );
                },
              ),
              
              SliverToBoxAdapter(
                child: const SizedBox(height: 120), // Padding for tab bar
              ),
            ],
          ),
        ),
      ),
    );
  }
}
