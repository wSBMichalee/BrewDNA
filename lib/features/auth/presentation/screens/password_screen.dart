import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class AuthPasswordScreen extends StatefulWidget {
  const AuthPasswordScreen({super.key});

  @override
  State<AuthPasswordScreen> createState() => _AuthPasswordScreenState();
}

class _AuthPasswordScreenState extends State<AuthPasswordScreen> {
  final _controller = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isValid = state.password.length >= 8;
        final title = state.isReturningUser ? 'Podaj hasło' : 'Ustaw hasło';
        
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
                    child: const Icon(CupertinoIcons.back, color: AppColors.label),
                  ),
                  SizedBox(height: AppSpacings.s24),
                  Text(title, style: AppTypography.title1),
                  SizedBox(height: AppSpacings.s12),
                  Text(
                    'Minimum 8 znaków.',
                    style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
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
                          imageUrl: 'https://media.screensdesign.com/gasset/f80559df338e476881bb1c0e745eb8a4_screen_image_password_card_image_f5537453ac.png',
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) => const Icon(CupertinoIcons.lock, size: 64, color: AppColors.accentTint),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s48),
                  
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    obscureText: _obscure,
                    onChanged: (val) => context.read<AuthCubit>().updatePassword(val),
                    decoration: InputDecoration(
                      hintText: 'Hasło',
                      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        borderSide: const BorderSide(color: AppColors.separator),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        borderSide: const BorderSide(color: AppColors.separator),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        borderSide: const BorderSide(color: AppColors.accent, width: 2),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: AppSpacings.s8),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(() => _obscure = !_obscure),
                          child: Text(
                            _obscure ? 'Pokaż' : 'Ukryj',
                            style: AppTypography.subhead.copyWith(
                              color: AppColors.accentDeep,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s16),
                  
                  // Inline validation
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.checkmark_alt_circle_fill,
                        color: isValid ? AppColors.accent : AppColors.separator,
                        size: 20,
                      ),
                      SizedBox(width: AppSpacings.s8),
                      Text(
                        'co najmniej 8 znaków',
                        style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  AppButton(
                    text: 'Dalej',
                    onPressed: isValid
                        ? () {
                            if (state.isReturningUser) {
                              context.go('/auth/welcome');
                            } else {
                              context.go('/auth/details');
                            }
                          }
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
