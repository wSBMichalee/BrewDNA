import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacings.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Witaj ponownie!', style: AppTypography.largeTitle),
              SizedBox(height: AppSpacings.s48),
              
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: AppSpacings.s24),
              
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Hasło',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: AppSpacings.s32),
              
              AppButton(
                text: 'Zaloguj się',
                onPressed: () => context.go('/main/scan'),
              ),
              SizedBox(height: AppSpacings.s24),
              
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Forgot password mock
                  },
                  child: Text(
                    'Zapomniałeś hasła?',
                    style: AppTypography.body.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
