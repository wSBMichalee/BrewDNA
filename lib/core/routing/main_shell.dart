import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      minimizeBehavior: TabBarMinimizeBehavior.never,
      body: Stack(alignment: Alignment.bottomCenter, children: [navigationShell]),
      bottomNavigationBar: AdaptiveBottomNavigationBar(
        useNativeBottomBar: true,
        selectedIndex: currentIndex,
        selectedItemColor: AppColors.accent,
        onTap: (index) {
          if (index == 4) {
            HapticFeedback.selectionClick();
            context.go('/main/scan');
            return;
          }
          HapticFeedback.selectionClick();
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
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
            isSearch: true,
          ),
        ],
      ),
    );
  }
}

