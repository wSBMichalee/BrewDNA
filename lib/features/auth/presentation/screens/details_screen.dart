import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class AuthDetailsScreen extends StatefulWidget {
  const AuthDetailsScreen({super.key});

  @override
  State<AuthDetailsScreen> createState() => _AuthDetailsScreenState();
}

class _AuthDetailsScreenState extends State<AuthDetailsScreen> {
  final _nameController = TextEditingController();

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
              final country = ['Polska', 'Niemcy', 'Czechy', 'Wielka Brytania', 'USA'][index];
              context.read<AuthCubit>().updateCountry(country);
            },
            children: const [
              Text('Polska'),
              Text('Niemcy'),
              Text('Czechy'),
              Text('Wielka Brytania'),
              Text('USA'),
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
                    child: const Icon(CupertinoIcons.back, color: AppColors.label),
                  ),
                  SizedBox(height: AppSpacings.s24),
                  Text('Ostatni krok', style: AppTypography.title1),
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
                          imageUrl: 'https://media.screensdesign.com/gasset/4d547d2fafc349af8e93a6ac2e8406cd_screen_image_final_step_card_image_ccc796a7e7.png',
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) => const Icon(CupertinoIcons.person, size: 64, color: AppColors.accentTint),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s48),
                  
                  TextField(
                    controller: _nameController,
                    onChanged: (val) => context.read<AuthCubit>().updateName(val),
                    decoration: InputDecoration(
                      hintText: 'Imię',
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
                    ),
                  ),
                  SizedBox(height: AppSpacings.s16),
                  
                  GestureDetector(
                    onTap: () => _showCountryPicker(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.separator),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.country.isEmpty ? 'Kraj' : state.country,
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
                  
                  Row(
                    children: [
                      CupertinoSwitch(
                        value: state.acceptedTerms,
                        activeColor: AppColors.accent,
                        onChanged: (val) => context.read<AuthCubit>().toggleTerms(val),
                      ),
                      SizedBox(width: AppSpacings.s12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.subhead.copyWith(color: AppColors.label),
                            children: const [
                              TextSpan(text: 'Akceptuję '),
                              TextSpan(
                                text: 'Regulamin',
                                style: TextStyle(decoration: TextDecoration.underline),
                              ),
                              TextSpan(text: ' i '),
                              TextSpan(
                                text: 'Politykę Prywatności',
                                style: TextStyle(decoration: TextDecoration.underline),
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
                    opacity: isValid ? 1.0 : 0.4,
                    child: AppButton(
                      text: 'Kontynuuj',
                      onPressed: isValid ? () => context.go('/auth/welcome') : () {},
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
