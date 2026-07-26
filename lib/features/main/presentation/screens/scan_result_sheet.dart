import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../beer/domain/entities/beer.dart';

class ScanResultSheet extends StatelessWidget {
  final Beer beer;
  
  const ScanResultSheet({super.key, required this.beer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.separator,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text('Rozpoznano piwo!', style: AppTypography.title2, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            
            // Beer info tile
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.separator),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.accentTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(CupertinoIcons.drop, color: AppColors.accent),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(beer.name, style: AppTypography.headline),
                        const SizedBox(height: 4),
                        Text(beer.brewery, style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.separator,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(beer.style, style: AppTypography.caption),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.separator,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('${beer.abv}% ABV', style: AppTypography.caption),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            CupertinoButton(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              onPressed: () {
                context.pop(); // Close sheet
                context.push('/main/beer/${beer.id}');
              },
              child: const Text('Tak, to ono', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
            ),
            
            const SizedBox(height: 12),
            
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 16),
              onPressed: () {
                // Return to scanner
                context.pop();
                context.pop(); // Pop scanning screen too
                // Optional: show snackbar about manual search
              },
              child: Text('To nie to piwo, szukaj ręcznie', style: TextStyle(color: AppColors.labelSecondary, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
