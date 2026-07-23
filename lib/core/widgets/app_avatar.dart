import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

class AppAvatar extends StatelessWidget {
  final String? url;
  final double size;

  AppAvatar({
    super.key,
    this.url,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.separator,
        borderRadius: BorderRadius.circular(AppRadius.full),
        image: url != null
            ? DecorationImage(
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: url == null
          ? Icon(
              CupertinoIcons.person_solid,
              color: AppColors.labelSecondary,
              size: size * 0.6,
            )
          : null,
    );
  }
}
