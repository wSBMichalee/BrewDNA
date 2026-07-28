import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool hasShadow;
  final EdgeInsetsGeometry? padding;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.hasShadow = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: padding ?? EdgeInsets.all(AppSpacings.s16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  offset: Offset(0, 2),
                  blurRadius: 16,
                )
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}
