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
  const MainShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/main/history')) return 0;
    if (location.startsWith('/main/map')) return 1;
    if (location.startsWith('/main/discover')) return 2;
    if (location.startsWith('/main/profile')) return 3;
    return 0;
  }

  void _navigate(BuildContext context, int i) {
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
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    return Scaffold(
      extendBody: true,
      body: Stack(alignment: Alignment.bottomCenter, children: [child]),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16.w,
            0,
            16.w,
            MediaQuery.of(context).padding.bottom,
          ),
          child: NativeGlassNavBar(
            currentIndex: currentIndex,
            onTap: (index) => _navigate(context, index),
            tabs: [
              NativeGlassNavBarItem(label: 'Historia', symbol: 'clock.fill'),
              NativeGlassNavBarItem(label: 'Mapa', symbol: 'map.fill'),
              NativeGlassNavBarItem(label: 'Odkryj', symbol: 'sparkles'),
              NativeGlassNavBarItem(
                label: 'Profil',
                symbol: 'person.crop.circle.fill',
              ),
            ],
            tintColor: AppColors.accent,
            actionButton: TabBarActionButton(
              symbol: 'camera.fill',
              onTap: () {
                HapticFeedback.selectionClick();
                context.go('/main/scan');
              },
            ),
            fallback: ClipRRect(
              borderRadius: BorderRadius.circular(32.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  height: 56, // roughly native height
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(32.r),
                    border: Border.all(
                      color: AppColors.black.withValues(alpha: 0.06),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: List.generate(4, (i) {
                      final isActive = currentIndex == i;
                      const icons = [
                        CupertinoIcons.clock_fill,
                        CupertinoIcons.map_fill,
                        CupertinoIcons.sparkles,
                        CupertinoIcons.person_solid,
                      ];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _navigate(context, i),
                          behavior: HitTestBehavior.opaque,
                          child: Center(
                            child: Icon(
                              icons[i],
                              color: isActive
                                  ? AppColors.accent
                                  : AppColors.labelSecondary.withValues(
                                      alpha: 0.4,
                                    ),
                              size: 24.r,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
