import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/main/discover')) return 0;
    if (location.startsWith('/main/map')) return 1;
    if (location.startsWith('/main/history')) return 2;
    if (location.startsWith('/main/profile')) return 3;
    if (location.startsWith('/main/scan')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: Stack(alignment: Alignment.bottomCenter, children: [child]),
      bottomNavigationBar: NativeGlassNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          HapticFeedback.selectionClick();
          switch (index) {
            case 0:
              context.go('/main/discover');
              break;
            case 1:
              context.go('/main/map');
              break;
            case 2:
              context.go('/main/history');
              break;
            case 3:
              context.go('/main/profile');
              break;
            case 4:
              context.go('/main/scan');
              break;
          }
        },
        tabs: [
          NativeGlassNavBarItem(
            label: l10n.tabDiscover,
            symbol: 'sparkles',
          ),
          NativeGlassNavBarItem(
            label: l10n.tabMap,
            symbol: 'map.fill',
          ),
          NativeGlassNavBarItem(
            label: l10n.tabHistory,
            symbol: 'mug.fill',
          ),
          NativeGlassNavBarItem(
            label: l10n.tabProfile,
            symbol: 'person.crop.circle.fill',
          ),
          NativeGlassNavBarItem(
            label: l10n.tabScan,
            symbol: 'camera.fill',
          ),
        ],
        tintColor: AppColors.accent,
      ),
    );
  }
}

