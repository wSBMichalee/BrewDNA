import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class AuthDetailsScreen extends StatefulWidget {
  AuthDetailsScreen({super.key});

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
            children: [
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
                  Text('Prawie gotowe!', style: AppTypography.title1),
                  SizedBox(height: AppSpacings.s48),
                  TextField(
                    controller: _nameController,
                    onChanged: (val) => context.read<AuthCubit>().updateName(val),
                    decoration: InputDecoration(
                      labelText: 'Imię',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s24),
                  GestureDetector(
                    onTap: () => _showCountryPicker(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.s12),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.separator)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Kraj', style: AppTypography.body.copyWith(color: AppColors.labelSecondary)),
                          Row(
                            children: [
                              Text(state.country, style: AppTypography.body),
                              Icon(CupertinoIcons.chevron_down, color: AppColors.labelSecondary, size: 20),
                            ],
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
                        onChanged: (val) => context.read<AuthCubit>().toggleTerms(val),
                      ),
                      SizedBox(width: AppSpacings.s16),
                      Expanded(
                        child: Text(
                          'Akceptuję Regulamin i Politykę Prywatności',
                          style: AppTypography.subhead,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  AppButton(
                    text: 'Kontynuuj',
                    onPressed: isValid ? () => context.go('/auth/welcome') : () {},
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
