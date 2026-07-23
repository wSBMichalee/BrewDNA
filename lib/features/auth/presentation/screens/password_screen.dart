import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class AuthPasswordScreen extends StatefulWidget {
  AuthPasswordScreen({super.key});

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
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpacings.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Stwórz hasło', style: AppTypography.title1),
                  SizedBox(height: AppSpacings.s48),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    obscureText: _obscure,
                    onChanged: (val) => context.read<AuthCubit>().updatePassword(val),
                    decoration: InputDecoration(
                      hintText: 'Hasło',
                      border: UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                          color: AppColors.labelSecondary,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s12),
                  Text(
                    'Minimum 8 znaków',
                    style: AppTypography.caption.copyWith(
                      color: isValid ? CupertinoColors.activeGreen : AppColors.labelSecondary,
                      fontSize: 20.w,
                    ),
                  ),
                  Spacer(),
                  AppButton(
                    text: 'Dalej',
                    onPressed: isValid ? () => context.go('/auth/details') : () {},
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
