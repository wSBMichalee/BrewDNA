import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../../../../core/di/injection.dart';
import '../../../onboarding/presentation/bloc/onboarding_cubit.dart';

class AuthEmailFlowScreen extends StatefulWidget {
  const AuthEmailFlowScreen({super.key});

  @override
  State<AuthEmailFlowScreen> createState() => _AuthEmailFlowScreenState();
}

class _AuthEmailFlowScreenState extends State<AuthEmailFlowScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authCubit = context.read<AuthCubit>();
      if (authCubit.state.country.isEmpty) {
        final locale = WidgetsBinding.instance.platformDispatcher.locale;
        final countryCode = locale.countryCode;
        
        String detectedCountry = 'Polska'; // Fallback
        switch (countryCode) {
          case 'PL': detectedCountry = 'Polska'; break;
          case 'DE': detectedCountry = 'Niemcy'; break;
          case 'CZ': detectedCountry = 'Czechy'; break;
          case 'GB':
          case 'UK': detectedCountry = 'Wielka Brytania'; break;
          case 'US': detectedCountry = 'USA'; break;
        }
        
        authCubit.updateCountry(detectedCountry);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onEmailChanged(String val, BuildContext context) {
    context.read<AuthCubit>().updateEmail(val);
    
    // Cancel any active debounce timer
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    
    // Only check if it looks like a valid email structure
    if (val.contains('@') && val.contains('.')) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        context.read<AuthCubit>().checkEmailExists(val);
      });
    }
  }

  void _showCountryPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: AppColors.background,
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            backgroundColor: AppColors.background,
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              final country = [
                'Polska',
                'Niemcy',
                'Czechy',
                'Wielka Brytania',
                'USA',
              ][index];
              context.read<AuthCubit>().updateCountry(country);
            },
            children: [
              Text(AppLocalizations.of(context)!.detailsCountryPoland),
              Text(AppLocalizations.of(context)!.detailsCountryGermany),
              Text(AppLocalizations.of(context)!.detailsCountryCzech),
              Text(AppLocalizations.of(context)!.detailsCountryUK),
              Text(AppLocalizations.of(context)!.detailsCountryUSA),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(AuthState state) async {
    if (state.isReturningUser) {
      setState(() => _isLoading = true);
      try {
        await context.read<AuthCubit>().signInWithEmail();
        if (mounted) {
          context.go('/main/discover');
        }
      } catch (e) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Błąd logowania'),
              content: const Text('Nieprawidłowy e-mail lub hasło.'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      // Register flow
      setState(() => _isLoading = true);
      try {
        final onboardingState = getIt<OnboardingCubit>().state;
        final tasteProfileData = {
          'axis_strength': onboardingState.lightStrongValue,
          'axis_bitterness': onboardingState.bitterSweetValue,
          'axis_fruitiness': onboardingState.dryFruityValue,
          'preferred_styles': onboardingState.selectedStyles.toList(),
          'preferred_countries': onboardingState.selectedCountries.toList(),
          'experience_level': onboardingState.experienceLevel,
        };

        await context.read<AuthCubit>().signUpWithEmail(tasteProfileData);

        if (mounted) {
          context.go('/paywall');
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Wystąpił nieoczekiwany błąd. Spróbuj ponownie później.';
          if (e.toString().contains('rate limit') || e.toString().contains('429')) {
            errorMessage = 'Zbyt wiele prób rejestracji. Odczekaj chwilę i spróbuj ponownie.';
          } else if (e.toString().contains('already registered') || e.toString().contains('User already exists')) {
            errorMessage = 'Konto z tym adresem email już istnieje.';
          }
          
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Błąd rejestracji'),
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
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            // Validation Logic
            final isEmailValid = state.email.contains('@') && state.email.contains('.');
            final isPasswordValid = state.password.length >= 8;
            final isDetailsValid = state.name.isNotEmpty && state.acceptedTerms;
            
            final isValid = state.isReturningUser
                ? (isEmailValid && isPasswordValid)
                : (isEmailValid && isPasswordValid && isDetailsValid);
                
            return Column(
              children: [
                // Header (Back button)
                Padding(
                  padding: EdgeInsets.only(left: AppSpacings.s24, top: AppSpacings.s24, right: AppSpacings.s24),
                  child: Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        onPressed: () => context.pop(),
                        child: const Icon(CupertinoIcons.back, color: AppColors.label),
                      ),
                    ],
                  ),
                ),
                
                // Scrollable Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppSpacings.s12),
                        Text(
                          (!isEmailValid) 
                              ? 'Wprowadź e-mail' 
                              : (state.isReturningUser ? AppLocalizations.of(context)!.passwordTitleLogin : 'Rejestracja'),
                          style: AppTypography.pageHeadline,
                        ),
                        SizedBox(height: AppSpacings.s48),
                        
                        // Email Field
                        TextField(
                          controller: _emailController,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          onChanged: (val) => _onEmailChanged(val, context),
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
                        
                        // Password and Details Section (Progressive Disclosure)
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: isEmailValid ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: AppSpacings.s24),
                              
                              // Password Field
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                autofillHints: const [AutofillHints.newPassword],
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
                              SizedBox(height: AppSpacings.s16),
                              
                              // Password validation hint
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.checkmark_alt_circle_fill,
                                    color: isPasswordValid ? AppColors.accent : AppColors.separator,
                                    size: 20,
                                  ),
                                  SizedBox(width: AppSpacings.s8),
                                  Text(
                                    'co najmniej 8 znaków',
                                    style: AppTypography.subhead.copyWith(
                                      color: AppColors.labelSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Extra Fields for Registration
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: (!state.isReturningUser) ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: AppSpacings.s32),
                                    Text(AppLocalizations.of(context)!.detailsTitle, style: AppTypography.title2),
                                    SizedBox(height: AppSpacings.s24),
                                    
                                    // Name Field
                                    TextField(
                                      controller: _nameController,
                                      autofillHints: const [AutofillHints.name],
                                      keyboardType: TextInputType.name,
                                      textCapitalization: TextCapitalization.words,
                                      onChanged: (val) => context.read<AuthCubit>().updateName(val),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.detailsHint,
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
                                    
                                    // Country Picker
                                    GestureDetector(
                                      onTap: () => _showCountryPicker(context),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppSpacings.s24,
                                          vertical: AppSpacings.s16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          border: Border.all(color: AppColors.separator),
                                          borderRadius: BorderRadius.circular(AppRadius.button),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              state.country.isEmpty ? AppLocalizations.of(context)!.detailsCountryPlaceholder : state.country,
                                              style: AppTypography.body.copyWith(
                                                color: state.country.isEmpty ? AppColors.labelSecondary : AppColors.label,
                                              ),
                                            ),
                                            const Icon(CupertinoIcons.chevron_down, color: AppColors.labelSecondary, size: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: AppSpacings.s32),
                                    
                                    // Terms Checkbox
                                    Row(
                                      children: [
                                        CupertinoSwitch(
                                          value: state.acceptedTerms,
                                          activeTrackColor: AppColors.accent,
                                          onChanged: (val) => context.read<AuthCubit>().toggleTerms(val),
                                        ),
                                        SizedBox(width: AppSpacings.s12),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: AppTypography.subhead.copyWith(color: AppColors.label),
                                              children: [
                                                TextSpan(text: AppLocalizations.of(context)!.detailsTermsAccept),
                                                TextSpan(
                                                  text: AppLocalizations.of(context)!.detailsTermsLink,
                                                  style: const TextStyle(decoration: TextDecoration.underline),
                                                ),
                                                TextSpan(text: AppLocalizations.of(context)!.detailsTermsAnd),
                                                TextSpan(
                                                  text: AppLocalizations.of(context)!.detailsPrivacyLink,
                                                  style: const TextStyle(decoration: TextDecoration.underline),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ) : const SizedBox.shrink(),
                              ),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                        SizedBox(height: AppSpacings.s32),
                      ],
                    ),
                  ),
                ),
                
                // Bottom Fixed CTA
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: (!isEmailValid) ? const SizedBox.shrink() : Padding(
                    padding: EdgeInsets.all(AppSpacings.s24),
                    child: Opacity(
                      opacity: isValid && !_isLoading ? 1.0 : 0.4,
                      child: AppButton(
                        text: _isLoading 
                            ? AppLocalizations.of(context)!.detailsRegistering 
                            : (state.isReturningUser ? 'Zaloguj się' : AppLocalizations.of(context)!.detailsContinue),
                        onPressed: (isValid && !_isLoading) ? () => _handleSubmit(state) : () {},
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
