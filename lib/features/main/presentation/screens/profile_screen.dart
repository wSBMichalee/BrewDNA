import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profil', style: AppTypography.largeTitle),
                    Icon(CupertinoIcons.settings, color: AppColors.labelSecondary),
                  ],
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.separator,
                      child: Icon(CupertinoIcons.person_solid, size: 40, color: AppColors.labelSecondary),
                    ),
                    SizedBox(width: AppSpacings.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Michał', style: AppTypography.title1),
                          Text('Początkujący sensoryk', style: AppTypography.subhead),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: AppSpacings.s32),
              
              // Stats
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('42', 'Piwa'),
                    Container(width: 1, height: 40, color: AppColors.separator),
                    _buildStat('15', 'Stylów'),
                    Container(width: 1, height: 40, color: AppColors.separator),
                    _buildStat('3', 'Kraje'),
                  ],
                ),
              ),
              
              SizedBox(height: AppSpacings.s32),
              
              // Premium banner
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Container(
                  padding: EdgeInsets.all(AppSpacings.s16),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.1),
                    border: Border.all(color: AppColors.gold),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.sparkles, color: AppColors.gold, size: 32),
                      SizedBox(width: AppSpacings.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('HopIQ Premium', style: AppTypography.subhead),
                            Text('Odblokuj pełny potencjał', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary)),
                          ],
                        ),
                      ),
                      AppButton(
                        text: 'Sprawdź',
                        isPrimary: true,
                        onPressed: () => context.push('/paywall'),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: AppSpacings.s32),
              
              // BeerDNA
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Text('Twoje BeerDNA', style: AppTypography.title2),
              ),
              SizedBox(height: AppSpacings.s16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Text(
                  'Na podstawie Twoich ocen, jesteś zdecydowanym fanem mocnej goryczki i cytrusowych aromatów. Najlepiej oceniasz piwa w stylu New England IPA.',
                  style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTypography.title1.copyWith(color: AppColors.accent)),
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.labelSecondary)),
      ],
    );
  }
}
