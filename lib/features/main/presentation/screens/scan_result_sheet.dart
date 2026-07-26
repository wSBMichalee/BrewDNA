import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
            
            // Header: Image + Title/Subtitle
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8),
                    image: beer.imageUrl.isNotEmpty
                        ? DecorationImage(image: NetworkImage(beer.imageUrl), fit: BoxFit.cover)
                        : null,
                  ),
                  child: beer.imageUrl.isEmpty
                      ? const Icon(CupertinoIcons.photo, color: AppColors.separator)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(beer.name, style: AppTypography.title2),
                      Text(beer.brewery, style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Detection info
            Row(
              children: [
                const Icon(CupertinoIcons.sparkles, color: AppColors.gold, size: 16),
                const SizedBox(width: 8),
                Text(
                  'WYKRYTO AUTOMATYCZNIE W 1.2S',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.labelSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip(CupertinoIcons.drop, beer.style.toUpperCase()),
                _buildChip(CupertinoIcons.drop_fill, '${beer.abv}% ABV'), // placeholder for ABV icon
                _buildChip(CupertinoIcons.location_solid, beer.country.toUpperCase()),
                _buildChip(CupertinoIcons.time, 'LEŻAKOWANIE: 2 TYG.'),
              ],
            ),
            
            const SizedBox(height: 32),
            
            AppButton(
              text: 'Tak, to ono',
              isPrimary: true,
              onPressed: () {
                context.push('/beer/${beer.id}', extra: beer);
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Otwieram ręczne wyszukiwanie...')));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'To nie to piwo, szukaj ręcznie',
                    style: AppTypography.subhead.copyWith(fontWeight: FontWeight.w600, color: AppColors.labelSecondary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.gold),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
