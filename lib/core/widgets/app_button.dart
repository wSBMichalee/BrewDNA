import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Border? border;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.border,
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
          color: backgroundColor ?? (isPrimary ? AppColors.accent : AppColors.accentTint),
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: border,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? CupertinoActivityIndicator(
                color: textColor ?? (isPrimary ? AppColors.background : AppColors.accent),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(width: AppSpacings.s12),
                  ],
                  Text(
                    text,
                    style: AppTypography.headline.copyWith(
                      color: textColor ?? (isPrimary ? AppColors.background : AppColors.accent),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
