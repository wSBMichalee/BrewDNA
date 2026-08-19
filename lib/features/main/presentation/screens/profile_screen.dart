import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/beer_style_placeholder.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../beer/domain/entities/beer.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';
import '../../../beer/presentation/widgets/share_card.dart';
import '../../../beer/presentation/utils/share_utils.dart';
import '../../../paywall/domain/entities/subscription_plan.dart';
import '../../domain/entities/user_taste_stats.dart';
import '../../../beer/domain/repositories/i_beer_repository.dart';
import '../../domain/entities/taste_profile.dart';
import '../../domain/repositories/i_taste_profile_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TasteProfile? _tasteProfile;
  bool _isLoadingTasteProfile = true;
  // ignore: unused_field
  String _brewDnaSummary = "Analizowanie Twojego DNA smakowego...";
  


  @override
  void initState() {
    super.initState();
    _loadTasteProfile();
    _loadBrewDna();
  }

  Future<void> _loadTasteProfile() async {
    final repo = getIt<ITasteProfileRepository>();
    final result = await repo.getTasteProfile();
    if (mounted) {
      setState(() {
        _isLoadingTasteProfile = false;
        result.fold(
          (l) => null,
          (profile) => _tasteProfile = profile,
        );
      });
    }
  }


  Future<void> _loadBrewDna() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('taste_profiles')
          .select('insights_json')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response != null && response['insights_json'] != null) {
        setState(() {
          _brewDnaSummary =
              response['insights_json']['summary'] ??
              "Twoje DNA smakowe jest już gotowe. Kliknij, by je poznać.";
        });
      } else {
        setState(() {
          _brewDnaSummary =
              "Jesteś na dobrej drodze. Spróbuj więcej piw, by wygenerować swój profil.";
        });
      }
    } catch (e) {
      setState(() {
        _brewDnaSummary = "Błąd pobierania DNA smakowego. (Mock)";
      });
    }
  }

  void _openShareCardSheet(BuildContext context) {
    // Sprawdź czy BeerCubit ma załadowaną historię piw użytkownika
    final beerState = context.read<BeerCubit>().state;
    Beer? topBeer;

    beerState.maybeWhen(
      loaded: (history, recs, ch, cr, botd, sb, mb) {
        if (history.isNotEmpty) {
          topBeer = history.first;
        }
      },
      orElse: () {},
    );

    // Domyślne piwo pokazowe profilu, jeśli historia jest pusta
    final showcaseBeer = topBeer ??
        const Beer(
          id: 'showcase-top-beer',
          name: 'Bawarski Lager',
          brewery: 'Browar Artezan',
          country: 'Polska',
          style: 'Lager',
          abv: 5.2,
          rating: 4.8,
          ratingCount: 142,
          lightStrong: 0.4,
          bitterSweet: 0.3,
          dryFruity: 0.2,
          imageUrl:
              'https://images.unsplash.com/photo-1535958636474-b021ee887b13?auto=format&fit=crop&w=600&q=80',
        );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ProfileShareSheet(beer: showcaseBeer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BeerCubit>()..loadHistory(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Brandowany Header z gradientem, bąbelkami i przyciskiem Settings
              BlocBuilder<BeerCubit, BeerState>(
                builder: (context, state) {
                  final stats = state.maybeWhen(
                    loaded: (history, r, c, t, b, s, m) => UserTasteStats.fromHistory(history),
                    orElse: () => const UserTasteStats(
                      totalBeers: 0,
                      uniqueBreweries: 0,
                      uniqueCountries: 0,
                      uniqueStylesCount: 0,
                    ),
                  );
                  return _buildBrandedHeader(context, stats);
                }
              ),

              SizedBox(height: AppSpacings.s24),

              // 2. Osiągnięcia (Placeholder)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Text(
                  AppLocalizations.of(context)!.profileAchievementsTitle,
                  style: AppTypography.title2,
                ),
              ),
              SizedBox(height: AppSpacings.s16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Row(
                  children: [
                    _buildAchievementCard(
                      CupertinoIcons.leaf_arrow_circlepath,
                      AppLocalizations.of(context)!.profileAchievement1Title,
                      AppLocalizations.of(context)!.profileAchievement1Subtitle,
                    ),
                    SizedBox(width: AppSpacings.s16),
                    _buildAchievementCard(
                      CupertinoIcons.rosette,
                      AppLocalizations.of(context)!.profileAchievement2Title,
                      AppLocalizations.of(context)!.profileAchievement2Subtitle,
                    ),
                    SizedBox(width: AppSpacings.s16),
                    _buildAchievementCard(
                      CupertinoIcons.star,
                      AppLocalizations.of(context)!.profileAchievement3Title,
                      AppLocalizations.of(context)!.profileAchievement3Subtitle,
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacings.s32),

              // 3. Profil smakowy
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Text(
                  AppLocalizations.of(context)!.profileTasteProfileTitle,
                  style: AppTypography.title2,
                ),
              ),
              SizedBox(height: AppSpacings.s16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: _buildTasteProfileCircles(),
              ),

              SizedBox(height: AppSpacings.s32),

              // 4. BrewDNA Card CTA
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Container(
                  padding: EdgeInsets.all(AppSpacings.s24),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.hare,
                        color: AppColors.accent,
                        size: 32,
                      ),
                      SizedBox(width: AppSpacings.s16),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.profileBrewDnaTitle,
                          style: AppTypography.title2.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacings.s32),

              // 5. NOWA SEKCJA MENU (Vivino Style)
              _buildMenuSection(context),

              SizedBox(height: AppSpacings.s32),

              // 6. Historia
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Text(
                  AppLocalizations.of(context)!.historyTabHistory,
                  style: AppTypography.title2,
                ),
              ),
              SizedBox(height: AppSpacings.s16),
              _buildHistorySection(context),

              SizedBox(height: AppSpacings.s32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: AppButton(
                  text: 'Wyloguj się',
                  onPressed: () async {
                    await context.read<AuthCubit>().signOut();
                    if (context.mounted) {
                      context.go('/');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasteProfileCircles() {
    if (_isLoadingTasteProfile) {
      return const Center(child: CupertinoActivityIndicator());
    }
    
    final profile = _tasteProfile ?? const TasteProfile(
      calculatedStrength: 50,
      calculatedBitterness: 50,
      calculatedFruitiness: 50,
    );

    return Container(
      padding: EdgeInsets.all(AppSpacings.s24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.separator.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.profileTasteProfileTitle,
                style: AppTypography.headline,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showEditTasteProfileSheet(profile),
                child: const Icon(CupertinoIcons.pencil, color: AppColors.labelSecondary),
              ),
            ],
          ),
          SizedBox(height: AppSpacings.s24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTasteAxisCircle(
                context,
                title: AppLocalizations.of(context)!.onboardingQ1Left, // Słodkie/Goryczka
                value: profile.effectiveBitterness,
                color: const Color(0xFF6A994E), // Zgaszona zieleń
                icon: CupertinoIcons.leaf_arrow_circlepath,
              ),
              _buildTasteAxisCircle(
                context,
                title: AppLocalizations.of(context)!.onboardingQ2Left, // Lekkie/Mocne
                value: profile.effectiveStrength,
                color: const Color(0xFFBC4749), // Ciemne bordo
                icon: CupertinoIcons.bolt_fill,
              ),
              _buildTasteAxisCircle(
                context,
                title: AppLocalizations.of(context)!.onboardingQ3Right, // Owocowe
                value: profile.effectiveFruitiness,
                color: const Color(0xFFF2A65A), // Pomarańcz
                icon: CupertinoIcons.drop_fill,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasteAxisCircle(
    BuildContext context, {
    required String title,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        _showEditTasteProfileSheet(_tasteProfile ?? const TasteProfile());
      },
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: AppSpacings.s8),
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 8,
                  backgroundColor: AppColors.separator.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    '${value.round()}%',
                    style: AppTypography.headline.copyWith(
                      color: AppColors.label,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacings.s8),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditTasteProfileSheet(TasteProfile profile) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return _TasteProfileEditorSheet(
          profile: profile,
          onSave: (strength, bitterness, fruitiness) async {
            setState(() => _isLoadingTasteProfile = true);
            final repo = getIt<ITasteProfileRepository>();
            await repo.updateDeclaredPreferences(
              declaredStrength: strength,
              declaredBitterness: bitterness,
              declaredFruitiness: fruitiness,
            );
            _loadTasteProfile();
          },
        );
      },
    );
  }

  Widget _buildBrandedHeader(BuildContext context, UserTasteStats stats) {
    final topPadding = MediaQuery.of(context).padding.top;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent, AppColors.accentDeep],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtelny mikro-wzór bąbelków piwa w tle
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              child: const CustomPaint(
                painter: BeerBubblesPainter(color: Colors.white),
              ),
            ),
          ),
          // Treść nagłówka
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacings.s24,
              topPadding + AppSpacings.s12,
              AppSpacings.s24,
              AppSpacings.s24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rząd z przyciskiem Ustawień (lewy górny róg)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => context.push('/main/settings'),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.gear,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: AppSpacings.s16),
                // Awatar + Imię + Statystyki
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        child: Text(
                          'MC',
                          style: AppTypography.title2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacings.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.profileDummyName,
                            style: AppTypography.pageHeadline.copyWith(
                              color: AppColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // TODO: Aggregated stats from checkins/ratings
                          Text(
                            '${stats.totalBeers} piw · ${stats.uniqueBreweries} browarów · ${stats.uniqueCountries} krajów',
                            style: AppTypography.subhead.copyWith(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // TODO: social feature not yet implemented
                          Text(
                            'Obserwowani: 0 · Obserwujący: 0',
                            style: AppTypography.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu',
            style: AppTypography.title2,
          ),
          SizedBox(height: AppSpacings.s16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.separator.withValues(alpha: 0.6),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: CupertinoIcons.map_fill,
                  iconColor: AppColors.accent,
                  title: 'Mapa',
                  onTap: () => context.go('/main/map'),
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: CupertinoIcons.archivebox_fill,
                  iconColor: AppColors.accent,
                  title: 'Moje Piwa',
                  onTap: () => context.go('/main/history'),
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: CupertinoIcons.share,
                  iconColor: AppColors.accent,
                  title: 'Udostępnij profil',
                  onTap: () => _openShareCardSheet(context),
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: CupertinoIcons.star_fill,
                  iconColor: AppColors.accent,
                  title: 'Subskrypcja Premium',
                  // TODO: replace with real subscription status once payment integration exists.
                  badgeText: currentSubscription != SubscriptionPlan.free ? 'PRO' : null,
                  onTap: () => context.push(
                    '/paywall',
                    extra: {'isManageMode': true},
                  ),
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: CupertinoIcons.question_circle,
                  iconColor: AppColors.accent,
                  title: 'Pomoc i wsparcie',
                  onTap: () => context.push('/main/help_support'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacings.s16,
        vertical: AppSpacings.s12,
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          SizedBox(width: AppSpacings.s16),
          Expanded(
            child: Text(
              title,
              style: AppTypography.subhead.copyWith(
                color: AppColors.label,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (badgeText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.accentDeep],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(width: AppSpacings.s8),
          ],
          const Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: AppColors.labelMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: AppColors.separator.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    return BlocBuilder<BeerCubit, BeerState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
            child: Shimmer.fromColors(
              baseColor: AppColors.separator,
              highlightColor: AppColors.background,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          error: (msg) => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
            child: Text(
              msg,
              style: AppTypography.caption.copyWith(color: Colors.red),
            ),
          ),
          loaded: (history, recommendations, cachedHistory, cachedRecs, beerOfTheDay, selectedBeer, matchedBeers) {
            if (history.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Container(
                  padding: EdgeInsets.all(AppSpacings.s20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.historyEmptyState,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.labelSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
              itemCount: history.length > 5 ? 5 : history.length,
              itemBuilder: (context, index) {
                final beer = history[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacings.s12),
                  child: AppCard(
                    padding: EdgeInsets.all(AppSpacings.s16),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.push('/main/beer/${beer.id}'),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: BeerImageOrPlaceholder(
                                imageUrl: beer.imageUrl,
                                style: beer.style,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacings.s16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  beer.name,
                                  style: AppTypography.subhead.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${beer.brewery} • ${beer.style}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.labelSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.star_fill,
                                size: 14,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                beer.rating.toString(),
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildAchievementCard(IconData icon, String title, String subtitle) {
    return SizedBox(
      width: 144,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacings.s12,
          vertical: AppSpacings.s20,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.separator.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.accent, size: 32),
            SizedBox(height: AppSpacings.s12),
            Text(
              title,
              style: AppTypography.subhead.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13, // Zmniejszony rozmiar fontu
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(
                color: AppColors.labelSecondary,
                fontSize: 11, // Delikatnie mniejszy podtytuł dla lepszych proporcji
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal do udostępniania profilu/karty piwa (ShareCard flow)
class _ProfileShareSheet extends StatefulWidget {
  final Beer beer;
  const _ProfileShareSheet({required this.beer});

  @override
  State<_ProfileShareSheet> createState() => _ProfileShareSheetState();
}

class _ProfileShareSheetState extends State<_ProfileShareSheet> {
  final GlobalKey _shareCardKey = GlobalKey();
  bool _isCapturing = false;

  Future<void> _handleShare() async {
    setState(() => _isCapturing = true);
    await Future.delayed(const Duration(milliseconds: 120));
    final path = await ShareUtils.captureWidget(_shareCardKey);
    setState(() => _isCapturing = false);

    if (path != null) {
      await ShareUtils.shareImage(path);
    }
  }

  Future<void> _handleSaveToGallery() async {
    setState(() => _isCapturing = true);
    await Future.delayed(const Duration(milliseconds: 120));
    final path = await ShareUtils.captureWidget(_shareCardKey);
    setState(() => _isCapturing = false);

    if (path != null) {
      final success = await ShareUtils.saveToGallery(path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.label,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Text(
              success
                  ? AppLocalizations.of(context)!.rateBeerGallerySavedSuccess
                  : AppLocalizations.of(context)!.rateBeerGallerySavedError,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.separator,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: 8),
            child: Text(
              'Karta Twojego BrewDNA',
              style: AppTypography.title2.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.s24,
                vertical: AppSpacings.s12,
              ),
              child: Column(
                children: [
                  RepaintBoundary(
                    key: _shareCardKey,
                    child: ShareCard(
                      beerName: widget.beer.name,
                      breweryName: widget.beer.brewery,
                      beerStyle: widget.beer.style,
                      imageUrl: widget.beer.imageUrl,
                      rating: widget.beer.rating,
                      matchPercentage: 98,
                      isCapturing: _isCapturing,
                      onSaveTap: _handleSaveToGallery,
                    ),
                  ),
                  SizedBox(height: AppSpacings.s24),
                  AppButton(
                    text: l10n.rateBeerShareButton,
                    onPressed: _isCapturing ? () {} : _handleShare,
                  ),
                  SizedBox(height: AppSpacings.s12),
                  AppButton(
                    text: l10n.rateBeerClose,
                    isPrimary: false,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(height: AppSpacings.s24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TasteProfileEditorSheet extends StatefulWidget {
  final TasteProfile profile;
  final Function(double strength, double bitterness, double fruitiness) onSave;

  const _TasteProfileEditorSheet({
    required this.profile,
    required this.onSave,
  });

  @override
  State<_TasteProfileEditorSheet> createState() => _TasteProfileEditorSheetState();
}

class _TasteProfileEditorSheetState extends State<_TasteProfileEditorSheet> {
  late double _strength;
  late double _bitterness;
  late double _fruitiness;

  @override
  void initState() {
    super.initState();
    _strength = widget.profile.declaredStrength?.toDouble() ?? widget.profile.calculatedStrength?.toDouble() ?? 50.0;
    _bitterness = widget.profile.declaredBitterness?.toDouble() ?? widget.profile.calculatedBitterness?.toDouble() ?? 50.0;
    _fruitiness = widget.profile.declaredFruitiness?.toDouble() ?? widget.profile.calculatedFruitiness?.toDouble() ?? 50.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSpacings.s24,
        left: AppSpacings.s24,
        right: AppSpacings.s24,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacings.s24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Edytuj preferencje smaku",
              style: AppTypography.title2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacings.s8),
            Text(
              "Suwaki definiują Twoje zadeklarowane preferencje. Wpływają one na finalny profil w 30%, reszta to historia ocen.",
              style: AppTypography.caption.copyWith(color: AppColors.labelSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacings.s32),
            _buildSliderRow(
              "Słodkie", "Goryczka", 
              _bitterness, 
              (v) => setState(() => _bitterness = v),
              const Color(0xFF6A994E),
            ),
            SizedBox(height: AppSpacings.s24),
            _buildSliderRow(
              "Lekkie", "Mocne", 
              _strength, 
              (v) => setState(() => _strength = v),
              const Color(0xFFBC4749),
            ),
            SizedBox(height: AppSpacings.s24),
            _buildSliderRow(
              "Wytrawne", "Owocowe", 
              _fruitiness, 
              (v) => setState(() => _fruitiness = v),
              const Color(0xFFF2A65A),
            ),
            SizedBox(height: AppSpacings.s48),
            AppButton(
              text: "Zapisz",
              onPressed: () {
                widget.onSave(_strength, _bitterness, _fruitiness);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow(String left, String right, double value, ValueChanged<double> onChanged, Color activeColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(left, style: AppTypography.subhead),
            Text(right, style: AppTypography.subhead),
          ],
        ),
        SizedBox(height: AppSpacings.s8),
        CupertinoSlider(
          value: value,
          min: 0,
          max: 100,
          activeColor: activeColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
