import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Static Map Placeholder
          Positioned.fill(
            child: Container(
              color: AppColors.card,
              child: Stack(
                children: [
                  Center(
                    child: Icon(CupertinoIcons.map_pin_ellipse, size: 120, color: AppColors.separator),
                  ),
                  // Mock Pins
                  Positioned(top: 200, left: 100, child: _buildPin()),
                  Positioned(top: 300, right: 150, child: _buildPin()),
                  Positioned(bottom: 250, left: 200, child: _buildPin()),
                ],
              ),
            ),
          ),
          
          // Header / Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSpacings.s24),
                  child: Row(
                    children: [
                      Text('Mapa Piw', style: AppTypography.largeTitle),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(AppSpacings.s24),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(color: AppColors.black.withValues(alpha: 0.12), blurRadius: 10, offset: Offset(0, -2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Ostatnio odkryte kraje', style: AppTypography.title2),
                      SizedBox(height: AppSpacings.s16),
                      _buildCountryItem('Niemcy', '12 piw'),
                      _buildCountryItem('Polska', '8 piw'),
                      _buildCountryItem('Czechy', '5 piw'),
                      SizedBox(height: 100), // Padding for tab bar
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPin() {
    return Icon(CupertinoIcons.location_solid, color: AppColors.accent, size: 32);
  }

  Widget _buildCountryItem(String country, String count) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacings.s8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(country, style: AppTypography.body),
          Text(count, style: AppTypography.caption.copyWith(color: AppColors.labelSecondary)),
        ],
      ),
    );
  }
}
