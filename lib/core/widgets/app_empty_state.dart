import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacings.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.labelSecondary.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacings.s16),
          Text(
            title,
            style: AppTypography.title3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacings.s8),
          Text(
            description,
            style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary),
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onButtonTap != null) ...[
            SizedBox(height: AppSpacings.s24),
            AppButton(
              text: buttonText!,
              onPressed: onButtonTap,
              isPrimary: false,
            ),
          ]
        ],
      ),
    );
  }
}
