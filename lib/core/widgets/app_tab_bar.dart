import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

class AppTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  AppTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // Liquid Glass Background
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.7),
                border: Border(
                  top: BorderSide(
                    color: AppColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTabItem(icon: CupertinoIcons.book, label: 'Historia', index: 0),
                    _buildTabItem(icon: CupertinoIcons.map, label: 'Mapa', index: 1),
                    SizedBox(width: 64), // Space for floating scan button
                    _buildTabItem(icon: CupertinoIcons.compass, label: 'Odkryj', index: 3),
                    _buildTabItem(icon: CupertinoIcons.person, label: 'Profil', index: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Floating Scan Button (Index 2)
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 20,
          child: GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                CupertinoIcons.camera_fill,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem({required IconData icon, required String label, required int index}) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.accent : AppColors.labelSecondary;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
