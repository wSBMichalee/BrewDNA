import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/core/theme/app_theme.dart';
import 'package:hop_iq/core/widgets/app_button.dart';
import '../../domain/entities/subscription_plan.dart';
import '../bloc/paywall_cubit.dart';
import '../bloc/paywall_state.dart';

class PaywallSelectionScreen extends StatelessWidget {
  final bool isManageMode;

  const PaywallSelectionScreen({
    super.key,
    this.isManageMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real subscription status once payment integration exists.
    final initialPlan = isManageMode
        ? (currentSubscription == SubscriptionPlan.premium
            ? PaywallPlan.premiumYearly
            : (currentSubscription == SubscriptionPlan.premiumTrial
                ? PaywallPlan.premiumTrial
                : PaywallPlan.free))
        : PaywallPlan.premiumTrial;

    return BlocProvider(
      create: (context) => PaywallCubit(initialPlan: initialPlan),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Subtelne, eleganckie tło gradientowe dla efektu glassmorphism
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentTint.withValues(alpha: 0.6),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withValues(alpha: 0.1),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacings.s24,
                  vertical: AppSpacings.s16,
                ),
                child: BlocBuilder<PaywallCubit, PaywallState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isManageMode) ...[
                          Align(
                            alignment: Alignment.topRight,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.separator.withValues(alpha: 0.35),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.xmark,
                                  size: 18,
                                  color: AppColors.label,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(height: AppSpacings.s16),
                        ],
                        Text(
                          'Wybierz swój plan',
                          style: AppTypography.brandDisplay.copyWith(color: AppColors.label),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacings.s8),
                        Text(
                          'Odblokuj pełen potencjał BrewDNA',
                          style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacings.s16),
                        
                        _buildPlanCard(
                          context,
                          plan: PaywallPlan.premiumTrial,
                          title: 'Premium Trial',
                          subtitle: 'Darmowe przez 7 dni, potem 19,99 zł/mies.',
                          description: 'Pełen dostęp Premium, 7 dni za darmo',
                          isSelected: state.selectedPlan == PaywallPlan.premiumTrial,
                          badge: 'Polecane',
                        ),
                        SizedBox(height: AppSpacings.s8),
                        _buildPlanCard(
                          context,
                          plan: PaywallPlan.premiumYearly,
                          title: 'Premium',
                          subtitle: '199,99 zł/rok (16,66 zł/mies.)',
                          description: 'Poszerzaj wiedzę z pełnym dostępem',
                          isSelected: state.selectedPlan == PaywallPlan.premiumYearly,
                        ),
                        SizedBox(height: AppSpacings.s8),
                        _buildPlanCard(
                          context,
                          plan: PaywallPlan.free,
                          title: 'Free',
                          subtitle: 'Darmowy dostęp z ograniczeniami',
                          description: '',
                          isSelected: state.selectedPlan == PaywallPlan.free,
                        ),
                        
                        SizedBox(height: AppSpacings.s12),
                        Center(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => context.push('/paywall/benefits'),
                            child: Text(
                              'Odkryj korzyści Premium',
                              style: AppTypography.footnote.copyWith(
                                color: AppColors.accentDeep,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        if (state.selectedPlan != PaywallPlan.free)
                          Padding(
                            padding: EdgeInsets.only(bottom: AppSpacings.s16),
                            child: Text(
                              'TO JEST SYMULACJA. Nie zostaniesz obciążony kosztami.',
                              style: AppTypography.caption.copyWith(color: CupertinoColors.systemRed),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                        AppButton(
                          text: isManageMode
                              ? 'Zmień plan'
                              : (state.selectedPlan == PaywallPlan.free
                                  ? 'Kontynuuj za darmo'
                                  : 'Rozpocznij'),
                          isLoading: state.isLoading,
                          onPressed: () async {
                            await context.read<PaywallCubit>().confirmPlan();
                            if (context.mounted &&
                                context.read<PaywallCubit>().state.error == null) {
                              if (isManageMode) {
                                Navigator.of(context).pop();
                              } else {
                                context.go('/auth/welcome');
                              }
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required PaywallPlan plan,
    required String title,
    required String subtitle,
    required String description,
    required bool isSelected,
    String? badge,
  }) {
    return GestureDetector(
      onTap: () => context.read<PaywallCubit>().selectPlan(plan),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.separator.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s16, vertical: AppSpacings.s12),
              color: AppColors.white.withValues(alpha: 0.65), // Jasne szkło
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isSelected ? CupertinoIcons.checkmark_alt_circle_fill : CupertinoIcons.circle,
                        color: isSelected ? AppColors.accent : AppColors.labelMuted,
                        size: 24,
                      ),
                      SizedBox(width: AppSpacings.s12),
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.headline.copyWith(
                            color: isSelected ? AppColors.label : AppColors.labelSecondary,
                          ),
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s8, vertical: AppSpacings.s4),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppSpacings.s8),
                  Text(
                    subtitle,
                    style: AppTypography.subhead.copyWith(
                      color: AppColors.label,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    SizedBox(height: AppSpacings.s4),
                    Text(
                      description,
                      style: AppTypography.footnote.copyWith(
                        color: AppColors.labelSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
