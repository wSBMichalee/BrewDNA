import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

class TasteSlider extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  TasteSlider({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(leftLabel, style: AppTypography.footnote.copyWith(color: AppColors.labelSecondary)),
            Text(rightLabel, style: AppTypography.footnote.copyWith(color: AppColors.labelSecondary)),
          ],
        ),
        SizedBox(height: AppSpacings.s4),
        SizedBox(
          width: double.infinity,
          child: CupertinoSlider(
            value: value,
            min: min,
            max: max,
            activeColor: AppColors.accent,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
