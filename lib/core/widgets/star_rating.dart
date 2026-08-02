import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final ValueChanged<double>? onRatingChanged;
  final double size;
  final int maxRating;

  const StarRating({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.size = 24.0,
    this.maxRating = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        return GestureDetector(
          onTap: onRatingChanged != null ? () => onRatingChanged!(index + 1.0) : null,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(right: AppSpacings.s4),
            child: Icon(
              index < rating.floor()
                  ? CupertinoIcons.star_fill
                  : (index < rating ? CupertinoIcons.star_lefthalf_fill : CupertinoIcons.star),
              color: AppColors.gold,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}
