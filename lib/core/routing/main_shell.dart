import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';
import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine the current index from the route location
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0; // Default to History
    
    if (location.startsWith('/main/history')) {
      currentIndex = 0;
    } else if (location.startsWith('/main/map')) {
      currentIndex = 1;
    } else if (location.startsWith('/main/discover')) {
      currentIndex = 2;
    } else if (location.startsWith('/main/profile')) {
      currentIndex = 3;
    }
    
    // We keep Scan separate from currentIndex to not affect the bar selection

    return Scaffold(
      extendBody: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          child,
        ],
      ),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: NativeGlassNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          HapticFeedback.selectionClick();
          switch (index) {
            case 0:
              context.go('/main/history');
              break;
            case 1:
              context.go('/main/map');
              break;
            case 2:
              context.go('/main/discover');
              break;
            case 3:
              context.go('/main/profile');
              break;
          }
        },
        tabs: [
          NativeGlassNavBarItem(label: 'Historia', symbol: 'clock.fill'),
          NativeGlassNavBarItem(label: 'Mapa', symbol: 'map.fill'),
          NativeGlassNavBarItem(label: 'Odkryj', symbol: 'sparkles'),
          NativeGlassNavBarItem(label: 'Profil', symbol: 'person.crop.circle.fill'),
        ],
        tintColor: AppColors.accent,
        fallback: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 8.w, 24.h + MediaQuery.of(context).padding.bottom),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(
                    color: AppColors.black.withOpacity(0.06),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.4),
                      blurRadius: 30.r,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: List.generate(4, (i) {
                    final isActive = currentIndex == i;
                    IconData icon;
                    switch (i) {
                      case 0:
                        icon = CupertinoIcons.clock_fill;
                        break;
                      case 1:
                        icon = CupertinoIcons.map_fill;
                        break;
                      case 2:
                        icon = CupertinoIcons.sparkles;
                        break;
                      case 3:
                        icon = CupertinoIcons.person_solid;
                        break;
                      default:
                        icon = CupertinoIcons.circle;
                    }
                    
                    return Expanded(
                      flex: 1,
                      child: _buildFallbackTabItem(context, i, icon, isActive),
                    );
                  }),
                ), // 1. Row
              ), // 2. Container
            ), // 3. BackdropFilter
          ), // 4. ClipRRect
        ), // 5. Padding
      ), // 6. NativeGlassNavBar
    ), // 7. Expanded
    Padding(
      padding: EdgeInsets.only(right: 16.w, bottom: 24.h + MediaQuery.of(context).padding.bottom),
      child: GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            context.go('/main/scan');
          },
          child: Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 12.r,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              CupertinoIcons.camera_fill,
              color: AppColors.white,
              size: 28.w,
          ),
        ),
      ),
    ),
  ],
),
      ),
    );
  }

  Widget _buildFallbackTabItem(BuildContext context, int i, IconData icon, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          switch (i) {
            case 0:
              context.go('/main/history');
              break;
            case 1:
              context.go('/main/map');
              break;
            case 2:
              context.go('/main/discover');
              break;
            case 3:
              context.go('/main/profile');
              break;
          }
        },
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 60.h,
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.accent.withOpacity(0.12)
                    : AppColors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                icon,
                size: 24.r,
                color: isActive
                    ? AppColors.accent
                    : AppColors.labelSecondary.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
