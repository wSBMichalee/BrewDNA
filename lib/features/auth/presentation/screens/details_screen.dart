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
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../../../core/di/injection.dart';
import '../../../onboarding/presentation/bloc/onboarding_cubit.dart';

class AuthDetailsScreen extends StatefulWidget {
  const AuthDetailsScreen({super.key});

  @override
  State<AuthDetailsScreen> createState() => _AuthDetailsScreenState();
}

class _AuthDetailsScreenState extends State<AuthDetailsScreen> {
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isValid = state.name.isNotEmpty && state.acceptedTerms;
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
                  Text(AppLocalizations.of(context)!.detailsTitle, style: AppTypography.title1),
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
                              'https://media.screensdesign.com/gasset/4d547d2fafc349af8e93a6ac2e8406cd_screen_image_final_step_card_image_ccc796a7e7.png',
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
                            CupertinoIcons.person,
                            size: 64,
                            color: AppColors.accentTint,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s48),

                  TextField(
                    controller: _nameController,
                    onChanged: (val) =>
                        context.read<AuthCubit>().updateName(val),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.detailsHint,
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
                  SizedBox(height: AppSpacings.s16),

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
                              color: state.country.isEmpty
                                  ? AppColors.labelSecondary
                                  : AppColors.label,
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.chevron_down,
                            color: AppColors.labelSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s32),

                  Row(
                    children: [
                      CupertinoSwitch(
                        value: state.acceptedTerms,
                        activeColor: AppColors.accent,
                        onChanged: (val) =>
                            context.read<AuthCubit>().toggleTerms(val),
                      ),
                      SizedBox(width: AppSpacings.s12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.subhead.copyWith(
                              color: AppColors.label,
                            ),
                            children: [
                              TextSpan(text: AppLocalizations.of(context)!.detailsTermsAccept),
                              TextSpan(
                                text: AppLocalizations.of(context)!.detailsTermsLink,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: AppLocalizations.of(context)!.detailsTermsAnd),
                              TextSpan(
                                text: AppLocalizations.of(context)!.detailsPrivacyLink,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Disabled button logic
                  Opacity(
                    opacity: isValid && !_isLoading ? 1.0 : 0.4,
                    child: AppButton(
                      text: _isLoading ? AppLocalizations.of(context)!.detailsRegistering : AppLocalizations.of(context)!.detailsContinue,
                      onPressed: isValid && !_isLoading
                          ? () async {
                              setState(() => _isLoading = true);
                              try {
                                final authState = context
                                    .read<AuthCubit>()
                                    .state;
                                final response = await Supabase
                                    .instance
                                    .client
                                    .auth
                                    .signUp(
                                      email: authState.email,
                                      password: authState.password,
                                      data: {'display_name': authState.name},
                                    );

                                if (response.user != null) {
                                  // Update public.users table created by trigger
                                  await Supabase.instance.client
                                      .from('users')
                                      .update({'display_name': authState.name})
                                      .eq('id', response.user!.id);

                                  try {
                                    final onboardingState = getIt<OnboardingCubit>().state;
                                    await Supabase.instance.client
                                        .from('taste_profiles')
                                        .upsert({
                                          'user_id': response.user!.id,
                                          'axis_strength': onboardingState.lightStrongValue,
                                          'axis_bitterness': onboardingState.bitterSweetValue,
                                          'axis_fruitiness': onboardingState.dryFruityValue,
                                          'preferred_styles': onboardingState.selectedStyles.toList(),
                                          'preferred_countries': onboardingState.selectedCountries.toList(),
                                          'experience_level': onboardingState.experienceLevel,
                                        });
                                  } catch (e) {
                                    debugPrint('Failed to save taste profile: $e');
                                  }

                                  if (mounted) {
                                    context.go('/auth/welcome');
                                  }
                                }
                              } on AuthException catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(context)!.detailsErrorGeneric),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Wystąpił nieoczekiwany błąd',
                                      ),
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _isLoading = false);
                                }
                              }
                            }
                          : () {},
                    ),
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
