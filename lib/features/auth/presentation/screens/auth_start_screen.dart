
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

class AuthStartScreen extends StatelessWidget {
  const AuthStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Hero Graphic with Gradient
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://media.screensdesign.com/gasset/04578a9f0f674e60beaacfb3c2de1cfc_screen_image_success_hero_image_395e267d88.jpg',
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0.0),
                          AppColors.background,
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.authStartTitle,
                    style: AppTypography.brandDisplay.copyWith(color: AppColors.label),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacings.s48),
                  
                  // Apple Button
                  SignInWithAppleButton(
                    onPressed: () async {
                      try {
                        await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.apple);
                      } catch (e) {
                        debugPrint('Apple sign in error: $e');
                      }
                    },
                    style: SignInWithAppleButtonStyle.black,
                    height: 56,
                    borderRadius: BorderRadius.all(Radius.circular(AppRadius.button)),
                  ),
                  SizedBox(height: AppSpacings.s16),
                  
                  // Google Button
                  SizedBox(
                    height: 56,
                    child: SignInButton(
                      Buttons.google,
                      text: AppLocalizations.of(context)!.authStartGoogle,
                      onPressed: () async {
                        try {
                          await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
                        } catch (e) {
                          debugPrint('Google sign in error: $e');
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
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
                      const SizedBox(width: 4),
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
                  SizedBox(height: AppSpacings.s32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
