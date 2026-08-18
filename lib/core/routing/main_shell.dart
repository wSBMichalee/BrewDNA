import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
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

    return AdaptiveScaffold(
      body: Stack(alignment: Alignment.bottomCenter, children: [child]),
      bottomNavigationBar: AdaptiveBottomNavigationBar(
        useNativeBottomBar: true,
        selectedIndex: currentIndex,
        selectedItemColor: AppColors.accent,
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
        items: [
          AdaptiveNavigationDestination(
            label: l10n.tabDiscover,
            icon: 'sparkles',
          ),
          AdaptiveNavigationDestination(
            label: l10n.tabMap,
            icon: 'map.fill',
          ),
          AdaptiveNavigationDestination(
            label: l10n.tabHistory,
            icon: 'mug.fill',
          ),
          AdaptiveNavigationDestination(
            label: l10n.tabProfile,
            icon: 'person.crop.circle.fill',
          ),
          AdaptiveNavigationDestination(
            label: l10n.tabScan,
            icon: 'camera.fill',
          ),
        ],
      ),
    );
  }
}

