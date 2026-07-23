import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;

  AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isLoading ? null : onPressed,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.accent : AppColors.accentTint,
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? CupertinoActivityIndicator(
                color: isPrimary ? AppColors.background : AppColors.accent,
              )
            : Text(
                text,
                style: AppTypography.headline.copyWith(
                  color: isPrimary ? AppColors.background : AppColors.accent,
                ),
              ),
      ),
    );
  }
}
