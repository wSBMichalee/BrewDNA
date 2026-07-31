import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_icons.dart';

class AuthStartScreen extends StatelessWidget {
  const AuthStartScreen({super.key});

  void _showComingSoon(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.authStartComingSoonTitle),
        content: Text(
          AppLocalizations.of(context)!.authStartComingSoonContent,
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)!.authStartComingSoonOk),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacings.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                AppLocalizations.of(context)!.authStartTitle,
                style: AppTypography.largeTitle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacings.s48),

              // Apple Button Mock
              CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 14),
                color: AppColors.black,
                borderRadius: BorderRadius.circular(12),
                onPressed: () => _showComingSoon(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(24, 24),
                      painter: AppleLogoPainter(color: AppColors.white),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context)!.authStartApple,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacings.s16),

              // Google Button Mock
              CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 14),
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                onPressed: () => _showComingSoon(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Placeholder for Google icon, using a generic icon for now
                    const Icon(CupertinoIcons.globe, color: Colors.black87, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.authStartGoogle,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacings.s32),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.separator)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s16),
                    child: Text(
                      AppLocalizations.of(context)!.authStartOr,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.labelSecondary,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.separator)),
                ],
              ),
              SizedBox(height: AppSpacings.s32),

              // Email Button
              AppButton(
                text: AppLocalizations.of(context)!.authStartEmail,
                isPrimary: false,
                onPressed: () => context.go('/auth/email'),
              ),

              const Spacer(),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.authStartAlreadyHaveAccount,
                    style: const TextStyle(color: AppColors.labelSecondary),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/auth/login'),
                    child: Text(
                      AppLocalizations.of(context)!.authStartLogin,
                      style: AppTypography.body.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
