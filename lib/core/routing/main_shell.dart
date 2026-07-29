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

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    const double kNavHeight = 49.0;

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
            2.h + MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(height: kNavHeight),
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
                      NativeGlassNavBarItem(
                        label: 'Historia',
                        symbol: 'clock.fill',
                      ),
                      NativeGlassNavBarItem(label: 'Mapa', symbol: 'map.fill'),
                      NativeGlassNavBarItem(
                        label: 'Odkryj',
                        symbol: 'sparkles',
                      ),
                      NativeGlassNavBarItem(
                        label: 'Profil',
                        symbol: 'person.crop.circle.fill',
                      ),
                    ],
                    tintColor: AppColors.accent,
                    fallback: ClipRRect(
                      borderRadius: BorderRadius.circular(32.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                        child: Container(
                          height: kNavHeight,
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
                                child: _buildFallbackTabItem(
                                  context,
                                  i,
                                  icon,
                                  isActive,
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
              SizedBox(width: 12.w),
              Transform.translate(
                offset: const Offset(0, -20),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go('/main/scan');
                  },
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(
                        width: kNavHeight,
                        height: kNavHeight,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.camera_fill,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackTabItem(
    BuildContext context,
    int i,
    IconData icon,
    bool isActive,
  ) {
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
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
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
