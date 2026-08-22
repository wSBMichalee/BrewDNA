import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../paywall/domain/entities/subscription_plan.dart';

class ProfileMenuSection extends StatelessWidget {
  final VoidCallback onShareTap;
  final SubscriptionPlan currentSubscription;

  const ProfileMenuSection({
    super.key,
    required this.onShareTap,
    required this.currentSubscription,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu',
            style: AppTypography.title2,
          ),
          SizedBox(height: AppSpacings.s16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.separator.withValues(alpha: 0.6),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: CupertinoIcons.map_fill,
                  iconColor: AppColors.accent,
                  title: 'Mapa',
                  onTap: () => context.go('/main/map'),
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: CupertinoIcons.archivebox_fill,
                  iconColor: AppColors.accent,
                  title: 'Moje Piwa',
                  onTap: () => context.go('/main/history'),
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: CupertinoIcons.share,
                  iconColor: AppColors.accent,
                  title: 'Udostępnij profil',
                  onTap: onShareTap,
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: CupertinoIcons.star_fill,
                  iconColor: AppColors.accent,
                  title: 'Subskrypcja Premium',
                  badgeText: currentSubscription != SubscriptionPlan.free ? 'PRO' : null,
                  onTap: () => context.push(
                    '/paywall',
                    extra: {'isManageMode': true},
                  ),
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: CupertinoIcons.question_circle,
                  iconColor: AppColors.accent,
                  title: 'Pomoc i wsparcie',
                  onTap: () => context.push('/main/help_support'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacings.s16,
        vertical: AppSpacings.s12,
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          SizedBox(width: AppSpacings.s16),
          Expanded(
            child: Text(
              title,
              style: AppTypography.subhead.copyWith(
                color: AppColors.label,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (badgeText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.accentDeep],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const Icon(
            CupertinoIcons.chevron_right,
            color: AppColors.separator,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: AppColors.separator.withValues(alpha: 0.5),
      ),
    );
  }
}
