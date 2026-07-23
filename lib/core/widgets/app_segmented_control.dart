import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

class AppSegmentedControl<T extends Object> extends StatelessWidget {
  final Map<T, String> items;
  final T groupValue;
  final ValueChanged<T?> onValueChanged;

  AppSegmentedControl({
    super.key,
    required this.items,
    required this.groupValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl<T>(
        backgroundColor: AppColors.separator,
        thumbColor: AppColors.background,
        groupValue: groupValue,
        onValueChanged: onValueChanged,
        children: items.map(
          (key, value) => MapEntry(
            key,
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.s12,
                vertical: AppSpacings.s8,
              ),
              child: Text(
                value,
                style: AppTypography.subhead.copyWith(
                  color: groupValue == key ? AppColors.label : AppColors.labelSecondary,
                  fontWeight: groupValue == key ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
