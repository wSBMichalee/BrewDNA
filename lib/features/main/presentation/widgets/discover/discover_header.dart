import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import 'discover_shared.dart';

class DiscoverHeader extends StatelessWidget {
  final Animation<double> animation;
  
  const DiscoverHeader({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredAnimatedItem(
      animation: animation,
      index: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacings.s24,
              vertical: AppSpacings.s16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final name = Supabase
                              .instance
                              .client
                              .auth
                              .currentUser
                              ?.userMetadata?['name'] as String? ??
                          '';
                      return Text(
                        '${AppLocalizations.of(context)!.discoverGreetingHello}${name.isNotEmpty ? name : AppLocalizations.of(context)!.discoverGreetingDefaultName}',
                        style: AppTypography.pageHeadline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.separator,
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.search,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacings.s24,
            ),
            child: Text(
              AppLocalizations.of(context)!.discoverSubtitle,
              style: AppTypography.body.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
