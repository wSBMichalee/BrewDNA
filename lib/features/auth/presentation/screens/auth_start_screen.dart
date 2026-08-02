import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_cubit.dart';

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
                    style: AppTypography.pageHeadline,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacings.s48),
                  
                  // Apple Button
                  Builder(builder: (context) {
                    debugPrint('--- RENDERING NEW APP BUTTONS ON AUTH START SCREEN ---');
                    return AppButton(
                    text: AppLocalizations.of(context)!.authStartApple,
                    onPressed: () => context.read<AuthCubit>().signInWithApple(),
                    backgroundColor: AppColors.label,
                    textColor: AppColors.background,
                    icon: Icon(
                      Icons.apple,
                      color: AppColors.background,
                      size: 24,
                    ),
                  );
                  }),
                  SizedBox(height: AppSpacings.s16),
                  
                  // Google Button
                  AppButton(
                    text: AppLocalizations.of(context)!.authStartGoogle,
                    onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
                    backgroundColor: AppColors.background,
                    textColor: AppColors.label,
                    border: Border.all(color: AppColors.separator),
                    // Since CupertinoIcons doesn't have a Google logo, we can use an Image or just no icon. Wait! I will use a simple "G" text as icon for Google if there is no image. Or maybe use a raw Text widget as icon.
                    // Actually, since I don't know if google logo exists in assets, let's just make it without icon or with a generic icon. But wait, Google brand requires the "G".
                    // Let's use a Text icon.
                    icon: Text(
                      'G',
                      style: AppTypography.headline.copyWith(
                        color: AppColors.label,
                        fontWeight: FontWeight.bold,
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
                    onPressed: () => context.push('/auth/email_flow'),
                  ),
                  
                  const Spacer(),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.authStartAlreadyHaveAccount,
                        style: AppTypography.linkCaption,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => context.push('/auth/login'),
                        child: Text(
                          AppLocalizations.of(context)!.authStartLogin,
                          style: AppTypography.linkCaptionBold,
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
