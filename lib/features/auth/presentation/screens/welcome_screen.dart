import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class AuthWelcomeScreen extends StatelessWidget {
  AuthWelcomeScreen({super.key});

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.checkmark_seal_fill, size: 80, color: AppColors.accent),
                  SizedBox(height: AppSpacings.s32),
                  Text(
                    'Witaj w HopIQ, ${state.name}!',
                    style: AppTypography.largeTitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacings.s16),
                  Text(
                    'Twoje konto zostało pomyślnie utworzone. Zeskanuj pierwsze piwo, żeby zacząć budować swoją kolekcję.',
                    style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacings.s48),
                  AppButton(
                    text: 'Przejdź do skanowania',
                    onPressed: () => context.go('/main/scan'),
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
