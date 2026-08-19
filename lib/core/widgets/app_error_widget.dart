import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isNoInternet;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.isNoInternet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNoInternet ? CupertinoIcons.wifi_slash : CupertinoIcons.exclamationmark_triangle,
              color: isNoInternet ? AppColors.labelSecondary : CupertinoColors.systemRed,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              isNoInternet ? 'Brak połączenia z internetem' : 'Wystąpił błąd',
              style: AppTypography.title2.copyWith(
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isNoInternet
                  ? 'Sprawdź swoje połączenie sieciowe i spróbuj ponownie.'
                  : message,
              style: AppTypography.body.copyWith(
                color: AppColors.labelSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Spróbuj ponownie',
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
