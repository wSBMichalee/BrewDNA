import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/core/theme/app_theme.dart';
import 'package:hop_iq/core/widgets/app_button.dart';
import 'dart:async';

class PaywallReengagementModal extends StatefulWidget {
  const PaywallReengagementModal({super.key});

  @override
  State<PaywallReengagementModal> createState() => _PaywallReengagementModalState();
}

class _PaywallReengagementModalState extends State<PaywallReengagementModal> {
  late Timer _timer;
  Duration _timeLeft = const Duration(hours: 0, minutes: 59, seconds: 59);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.85), // Wymaga mocniejszego alfa by tekst był czytelny jako modal
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.separator.withValues(alpha: 0.5)),
            ),
            padding: EdgeInsets.all(AppSpacings.s24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => context.pop(),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacings.s8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(CupertinoIcons.xmark, color: AppColors.labelSecondary, size: 20),
                    ),
                  ),
                ),
                
                Text(
                  'Specjalna Oferta!',
                  style: AppTypography.title1.copyWith(color: AppColors.accentDeep),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacings.s16),
                
                Text(
                  'Odbierz darmowy tydzień Premium',
                  style: AppTypography.headline.copyWith(color: AppColors.label),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacings.s8),
                
                Text(
                  'Skorzystaj z inteligentniejszych przygód piwnych i AI podsumowań.',
                  style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacings.s24),
                
                Container(
                  padding: EdgeInsets.symmetric(vertical: AppSpacings.s16),
                  decoration: BoxDecoration(
                    color: AppColors.groupedBackground.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppRadius.card / 2),
                    border: Border.all(color: AppColors.separator.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Oferta wygasa za:',
                        style: AppTypography.footnote.copyWith(
                          color: AppColors.labelSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSpacings.s8),
                      Text(
                        _formatDuration(_timeLeft),
                        style: AppTypography.brandDisplay.copyWith(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacings.s24),
                
                AppButton(
                  text: 'Rozpocznij darmowy okres',
                  onPressed: () {
                    // TODO: RevenueCat buy
                    context.pop();
                  },
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}
