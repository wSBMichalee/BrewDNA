import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class AuthEmailScreen extends StatefulWidget {
  const AuthEmailScreen({super.key});

  @override
  State<AuthEmailScreen> createState() => _AuthEmailScreenState();
}

class _AuthEmailScreenState extends State<AuthEmailScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpacings.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    onPressed: () => context.pop(),
                    child: const Icon(
                      CupertinoIcons.back,
                      color: AppColors.label,
                    ),
                  ),
                  SizedBox(height: AppSpacings.s24),
                  Text(AppLocalizations.of(context)!.emailTitle, style: AppTypography.title1),
                  SizedBox(height: AppSpacings.s12),
                  Text(
                    AppLocalizations.of(context)!.emailSubtitle,
                    style: AppTypography.body.copyWith(
                      color: AppColors.labelSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacings.s48),

                  // Image Card
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://media.screensdesign.com/gasset/446a88c2bc4346fc946cc0eba790b7cc_screen_image_email_card_image_ad69bca432.png',
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: AppColors.separator,
                            highlightColor: AppColors.background,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            CupertinoIcons.drop,
                            size: 64,
                            color: AppColors.accentTint,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s48),

                  TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      context.read<AuthCubit>().updateEmail(val);
                      context.read<AuthCubit>().checkEmailExists(val);
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.emailHint,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacings.s24,
                        vertical: AppSpacings.s16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        borderSide: const BorderSide(
                          color: AppColors.separator,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        borderSide: const BorderSide(
                          color: AppColors.separator,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        borderSide: const BorderSide(
                          color: AppColors.accent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  AppButton(
                    text: AppLocalizations.of(context)!.emailNext,
                    onPressed:
                        state.email.contains('@') && state.email.contains('.')
                        ? () => context.go('/auth/password')
                        : () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
