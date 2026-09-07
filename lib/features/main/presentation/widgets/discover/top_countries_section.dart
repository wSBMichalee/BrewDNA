import 'package:flutter/material.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import 'discover_shared.dart';

class TopCountriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> topCountries;
  final Animation<double> animation;

  const TopCountriesSection({
    super.key,
    required this.topCountries,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    if (topCountries.isEmpty) return const SizedBox.shrink();

    return StaggeredAnimatedItem(
      animation: animation,
      index: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
            child: Text(
              AppLocalizations.of(context)!.discoverTopCountries,
              style: AppTypography.title2,
            ),
          ),
          SizedBox(height: AppSpacings.s16),
          SizedBox(
            height: 136,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              itemCount: topCountries.length,
              itemBuilder: (context, index) {
                final country = topCountries[index];
                return InteractiveCard(
                  onTap: () {},
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.only(right: AppSpacings.s16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          country['flag'] as String,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          country['name'] as String,
                          style: AppTypography.subhead,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.beersCount(country['count'] as int),
                          style: AppTypography.caption.copyWith(color: AppColors.labelSecondary),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
