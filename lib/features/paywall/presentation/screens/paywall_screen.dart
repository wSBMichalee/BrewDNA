import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

class PaywallScreen extends StatefulWidget {
  PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isYearly = true; // Default selected plan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Close Button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(CupertinoIcons.xmark, color: AppColors.label),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSpacings.s16),
                    Text(
                      'HopIQ Premium',
                      style: AppTypography.largeTitle.copyWith(color: AppColors.gold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacings.s12),
                    Text(
                      'Odblokuj pełny potencjał swojego profilu piwnego',
                      style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacings.s48),
                    
                    // Features List
                    _buildFeatureItem(CupertinoIcons.sparkles, 'AI bez limitu', 'Nielimitowane skany i BeerDNA'),
                    _buildFeatureItem(CupertinoIcons.chart_bar_fill, 'Zaawansowane statystyki', 'Odkryj ukryte wzorce w swoich ocenach'),
                    _buildFeatureItem(CupertinoIcons.doc_text_fill, 'Eksport kolekcji', 'Pobierz swoje dane do CSV lub PDF'),
                    _buildFeatureItem(CupertinoIcons.cloud_fill, 'Backup w chmurze', 'Nigdy nie trać swojej kolekcji'),
                    _buildFeatureItem(CupertinoIcons.rosette, 'Ekskluzywne odznaki', 'Zdobądź profil premium na platformie'),
                    
                    SizedBox(height: AppSpacings.s48),
                    
                    // Plan Selector
                    Row(
                      children: [
                        Expanded(
                          child: _buildPlanCard(
                            title: 'Miesięcznie',
                            price: '14,99 zł',
                            subtitle: 'Rozliczenie co miesiąc',
                            isSelected: !_isYearly,
                            onTap: () => setState(() => _isYearly = false),
                          ),
                        ),
                        SizedBox(width: AppSpacings.s16),
                        Expanded(
                          child: _buildPlanCard(
                            title: 'Rocznie',
                            price: '149,99 zł',
                            subtitle: '3 dni za darmo, potem 149,99 zł/rok',
                            badge: 'Oszczędzasz 16%',
                            isSelected: _isYearly,
                            onTap: () => setState(() => _isYearly = true),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: AppSpacings.s32),
                    
                    // CTA Button
                    AppButton(
                      text: 'Kup',
                      onPressed: () {
                        // Mock purchase
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      },
                    ),
                    
                    SizedBox(height: AppSpacings.s16),
                    
                    // Fine Print (App Store compliance)
                    Text(
                      'Płatność pobierana przy zakupie. Subskrypcja odnawia się automatycznie, chyba że zostanie anulowana 24h przed końcem bieżącego okresu. Możesz zarządzać subskrypcjami w Ustawieniach Konta.',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.labelSecondary,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacings.s24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacings.s24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 28),
          SizedBox(width: AppSpacings.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.subhead),
                SizedBox(height: 2),
                Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.labelSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String subtitle,
    String? badge,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacings.s16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold.withOpacity(0.1) : AppColors.card,
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.separator,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.white),
                ),
              ),
            Text(title, style: AppTypography.body),
            SizedBox(height: AppSpacings.s8),
            Text(price, style: AppTypography.title2),
            SizedBox(height: AppSpacings.s4),
            Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.labelSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
