import 'package:flutter/cupertino.dart';
import '../widgets/branded_profile_header.dart';
import '../widgets/taste_profile_circles.dart';
import '../widgets/taste_profile_editor_sheet.dart';
import '../widgets/achievements_section.dart';
import '../widgets/profile_menu_section.dart';
import '../../../paywall/domain/entities/subscription_plan.dart';
import '../widgets/profile_share_sheet.dart';
import '../widgets/profile_history_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../beer/domain/entities/beer.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';
import '../../domain/entities/user_taste_stats.dart';
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
      builder: (ctx) => ProfileShareSheet(beer: showcaseBeer),
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
                  return BrandedProfileHeader(stats: stats);
                }
              ),

              SizedBox(height: AppSpacings.s24),

              const AchievementsSection(),
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
                child: TasteProfileCircles(
                isLoading: _isLoadingTasteProfile,
                profile: _tasteProfile,
                onEditTap: () => _showEditTasteProfileSheet(_tasteProfile ?? const TasteProfile()),
              ),
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
              ProfileMenuSection(
                onShareTap: () => _openShareCardSheet(context),
                currentSubscription: currentSubscription,
              ),

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
              const ProfileHistorySection(),

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

  void _showEditTasteProfileSheet(TasteProfile profile) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return TasteProfileEditorSheet(
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

}
