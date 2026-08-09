import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Wkrótce dostępne'),
        content: Text('Funkcja "$feature" będzie dostępna w nadchodzącej aktualizacji.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Wylogowanie'),
        content: const Text('Czy na pewno chcesz się wylogować z aplikacji BrewDNA?'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(ctx).pop();
              await context.read<AuthCubit>().signOut();
              if (context.mounted) {
                context.go('/');
              }
            },
            child: const Text('Wyloguj się'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Anuluj'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: AppColors.separator.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Icon(
              CupertinoIcons.back,
              color: AppColors.label,
              size: 24,
            ),
          ),
        ),
        middle: Text(
          'Ustawienia',
          style: AppTypography.headline.copyWith(
            color: AppColors.label,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacings.s20,
            vertical: AppSpacings.s24,
          ),
          children: [
            // Sekcja: Konto i Preferencje
            _buildSectionHeader('KONTO I PREFERENCJE'),
            SizedBox(height: AppSpacings.s8),
            _buildGroupCard([
              _buildSettingTile(
                icon: CupertinoIcons.bell,
                iconColor: AppColors.accent,
                title: 'Powiadomienia',
                trailingText: 'Włączone',
                onTap: () => _showComingSoon(context, 'Powiadomienia'),
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: CupertinoIcons.lock,
                iconColor: AppColors.accent,
                title: 'Prywatność',
                trailingText: 'Profil publiczny',
                onTap: () => _showComingSoon(context, 'Prywatność'),
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: CupertinoIcons.globe,
                iconColor: AppColors.accent,
                title: 'Język',
                trailingText: 'Polski (PL)',
                onTap: () => _showComingSoon(context, 'Zmiana języka'),
              ),
            ]),

            SizedBox(height: AppSpacings.s32),

            // Sekcja: Aplikacja
            _buildSectionHeader('O APLIKACJI'),
            SizedBox(height: AppSpacings.s8),
            _buildGroupCard([
              _buildSettingTile(
                icon: CupertinoIcons.info,
                iconColor: AppColors.labelSecondary,
                title: 'Wersja aplikacji',
                trailingText: '1.0.0 (Build 42)',
                showChevron: false,
                onTap: null,
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: CupertinoIcons.doc_text,
                iconColor: AppColors.labelSecondary,
                title: 'Regulamin usługi',
                onTap: () => _showComingSoon(context, 'Regulamin usługi'),
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: CupertinoIcons.shield,
                iconColor: AppColors.labelSecondary,
                title: 'Polityka prywatności',
                onTap: () => _showComingSoon(context, 'Polityka prywatności'),
              ),
            ]),

            SizedBox(height: AppSpacings.s32),

            // Sekcja: Strefa konta
            _buildGroupCard([
              CupertinoButton(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacings.s16,
                  vertical: AppSpacings.s16,
                ),
                onPressed: () => _confirmSignOut(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.square_arrow_right,
                      color: CupertinoColors.destructiveRed,
                      size: 20,
                    ),
                    SizedBox(width: AppSpacings.s8),
                    Text(
                      'Wyloguj się z konta',
                      style: AppTypography.subhead.copyWith(
                        color: CupertinoColors.destructiveRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ]),

            SizedBox(height: AppSpacings.s24),
            Center(
              child: Text(
                'BrewDNA © 2026. Made with passion for craft beer.',
                style: AppTypography.caption.copyWith(
                  color: AppColors.labelMuted,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s8),
      child: Text(
        title,
        style: AppTypography.caption.copyWith(
          color: AppColors.labelSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: AppColors.separator.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailingText,
    bool showChevron = true,
    VoidCallback? onTap,
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
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailingText != null) ...[
            Text(
              trailingText,
              style: AppTypography.caption.copyWith(
                color: AppColors.labelSecondary,
                fontSize: 13,
              ),
            ),
            SizedBox(width: AppSpacings.s8),
          ],
          if (showChevron)
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.labelMuted,
            ),
        ],
      ),
    );
  }
}
