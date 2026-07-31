import 'package:flutter/material.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

class AnalyzingPage extends StatefulWidget {
  final VoidCallback onComplete;

  const AnalyzingPage({super.key, required this.onComplete});

  @override
  State<AnalyzingPage> createState() => _AnalyzingPageState();
}

class _AnalyzingPageState extends State<AnalyzingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Progress circle
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.65,
                  strokeWidth: 6,
                  color: AppColors.accent,
                  backgroundColor: AppColors.separator,
                ),
                Center(child: Text('🍺', style: TextStyle(fontSize: 40))),
              ],
            ),
          ),
          SizedBox(height: AppSpacings.s48),
          Text(
            AppLocalizations.of(context)!.onboardingAnalyzingTitle,
            style: AppTypography.title2.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacings.s16),
          Text(
            AppLocalizations.of(context)!.onboardingAnalyzingFact,
            style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.onboardingAnalyzingWait,
            style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
          ),
          SizedBox(height: AppSpacings.s32),
        ],
      ),
    );
  }
}
