import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthState state) async {
    try {
      await context.read<AuthCubit>().signInWithEmail();
      if (mounted) {
        context.go('/auth/welcome');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Nieprawidłowy e-mail lub hasło.';
        if (e.toString().contains('rate limit') || e.toString().contains('429')) {
          errorMessage = 'Zbyt wiele prób logowania. Odczekaj chwilę i spróbuj ponownie.';
        }
        
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Błąd logowania'),
            content: Text(errorMessage),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isEmailValid = state.email.contains('@') && state.email.contains('.');
          final isPasswordValid = state.password.length >= 6; // Just a basic check for login
          final isValid = isEmailValid && isPasswordValid;

          return Column(
            children: [
              // Hero Image with Gradient and Blur
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35, // Slightly shorter than start screen
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://media.screensdesign.com/gasset/04578a9f0f674e60beaacfb3c2de1cfc_screen_image_success_hero_image_395e267d88.jpg',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: AppColors.background),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.background,
                      ),
                    ),
                    // Gradient overlay to blend with background seamlessly
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.background.withValues(alpha: 0.2), // Light uniform darken on top
                              AppColors.background,
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Back button overlay
                    Positioned(
                      top: MediaQuery.of(context).padding.top + AppSpacings.s12,
                      left: AppSpacings.s16,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.back, color: AppColors.label, size: 20),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Witaj z powrotem',
                        style: AppTypography.pageHeadline,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacings.s48),
                      
                      // Email Field
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) => context.read<AuthCubit>().updateEmail(val),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.emailHint,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacings.s24,
                            vertical: AppSpacings.s16,
                          ),
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
                        ),
                      ),
                      SizedBox(height: AppSpacings.s16),
                      
                      // Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onChanged: (val) => context.read<AuthCubit>().updatePassword(val),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.passwordHint,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacings.s24,
                            vertical: AppSpacings.s16,
                          ),
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
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              child: Text(
                                _obscurePassword ? 'Pokaż' : 'Ukryj',
                                style: AppTypography.subhead.copyWith(
                                  color: AppColors.accentDeep,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacings.s32),

                      // Login Button
                      Opacity(
                        opacity: isValid && !state.isLoading ? 1.0 : 0.4,
                        child: AppButton(
                          text: state.isLoading ? 'Logowanie...' : 'Zaloguj się',
                          onPressed: (isValid && !state.isLoading) ? () => _handleLogin(state) : () {},
                        ),
                      ),
                      
                      SizedBox(height: AppSpacings.s24),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nie masz konta?',
                            style: AppTypography.linkCaption,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => context.push('/auth/start'),
                            child: Text(
                              'Zarejestruj się',
                              style: AppTypography.linkCaptionBold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
