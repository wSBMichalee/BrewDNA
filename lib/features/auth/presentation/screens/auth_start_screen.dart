import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

class AuthStartScreen extends StatelessWidget {
  AuthStartScreen({super.key});

  void _showComingSoon(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Wkrótce dostępne'),
        content: Text('Ta metoda logowania będzie dostępna w przyszłych wersjach.'),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
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
              Spacer(),
              Text(
                'Zacznij budować swoją kolekcję',
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
                    Icon(Icons.apple, color: AppColors.white, size: 24),
                    SizedBox(width: 8),
                    Text('Kontynuuj z Apple', style: TextStyle(color: AppColors.white, fontSize: 17, fontWeight: FontWeight.w600)),
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
                    Icon(CupertinoIcons.globe, color: AppColors.black.withValues(alpha: 0.87), size: 24), 
                    SizedBox(width: 8),
                    Text('Kontynuuj z Google', style: TextStyle(color: AppColors.black.withValues(alpha: 0.87), fontSize: 17, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              
              SizedBox(height: AppSpacings.s32),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.separator)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s16),
                    child: Text('lub', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary)),
                  ),
                  Expanded(child: Divider(color: AppColors.separator)),
                ],
              ),
              SizedBox(height: AppSpacings.s32),
              
              // Email Button
              AppButton(
                text: 'Kontynuuj emailem',
                isPrimary: false,
                onPressed: () => context.go('/auth/email'),
              ),
              
              Spacer(),
              
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Masz już konto? ', style: AppTypography.body.copyWith(color: AppColors.labelSecondary)),
                  GestureDetector(
                    onTap: () => context.go('/auth/login'),
                    child: Text(
                      'Zaloguj się',
                      style: AppTypography.body.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
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
