import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class AuthEmailScreen extends StatefulWidget {
  AuthEmailScreen({super.key});

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
                  Text('Jaki jest Twój e-mail?', style: AppTypography.title1),
                  SizedBox(height: AppSpacings.s48),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) => context.read<AuthCubit>().updateEmail(val),
                    decoration: InputDecoration(
                      hintText: 'adres@email.com',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  Spacer(),
                  AppButton(
                    text: 'Dalej',
                    onPressed: state.email.contains('@') && state.email.contains('.')
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
