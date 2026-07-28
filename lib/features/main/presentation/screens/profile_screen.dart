import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_segmented_control.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTasteTab = 0;
  String _brewDnaSummary = "Analizowanie Twojego DNA smakowego...";
  
  @override
  void initState() {
    super.initState();
    _loadBrewDna();
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
          // Parse summary or fallback
          _brewDnaSummary = response['insights_json']['summary'] ?? "Twoje DNA smakowe jest już gotowe. Kliknij, by je poznać.";
        });
      } else {
        setState(() {
          _brewDnaSummary = "Jesteś na dobrej drodze. Spróbuj więcej piw, by wygenerować swój profil.";
        });
      }
    } catch (e) {
      setState(() {
        _brewDnaSummary = "Błąd pobierania DNA smakowego. (Mock)";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s24),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.separator,
                      backgroundImage: const NetworkImage('https://media.screensdesign.com/gasset/b187515082164f9b884126bfdbaf486c_screen_image_michal_c009d732c4.png'), // Mock matching reference
                    ),
                    SizedBox(width: AppSpacings.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Michał', style: AppTypography.title1),
                          SizedBox(height: AppSpacings.s4),
                          // TODO: Aggregated stats from checkins/ratings
                          Text('68 piw · 31 browarów · 12 krajów', style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: AppSpacings.s16),
              
              // Osiągnięcia (Placeholder)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Text('Osiągnięcia', style: AppTypography.title2),
              ),
              SizedBox(height: AppSpacings.s16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Row(
                  children: [
                    _buildAchievementCard(CupertinoIcons.leaf_arrow_circlepath, 'Odkrywca', '19 stylów'),
                    SizedBox(width: AppSpacings.s16),
                    _buildAchievementCard(CupertinoIcons.rosette, 'Top 10', 'w Polsce'),
                    SizedBox(width: AppSpacings.s16),
                    _buildAchievementCard(CupertinoIcons.star, 'Koneser', '100+ ocen'),
                  ],
                ),
              ),
              
              SizedBox(height: AppSpacings.s32),
              
              // Profil smakowy
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Text('Profil smakowy', style: AppTypography.title2),
              ),
              SizedBox(height: AppSpacings.s16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: AppSegmentedControl<int>(
                  items: const {0: 'Style', 1: 'Kraje'},
                  groupValue: _selectedTasteTab,
                  onValueChanged: (index) {
                    if (index != null) {
                      setState(() => _selectedTasteTab = index);
                    }
                  },
                ),
              ),
              
              SizedBox(height: AppSpacings.s24),
              
              // Progress Card
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Container(
                  padding: EdgeInsets.all(AppSpacings.s24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.separator.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Spróbowano 19 z 42 stylów', style: AppTypography.subhead.copyWith(fontWeight: FontWeight.bold)),
                          Text('45%', style: AppTypography.subhead.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: AppSpacings.s16),
                      // Progress Bar
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.separator.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.45,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacings.s24),
                      // Favorite Style
                      Container(
                        padding: EdgeInsets.all(AppSpacings.s16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.white,
                              child: Icon(CupertinoIcons.drop, color: AppColors.accent),
                            ),
                            SizedBox(width: AppSpacings.s16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('West Coast IPA', style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                                  Text('Ulubiony styl', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary)),
                                ],
                              ),
                            ),
                            Row(
                              children: List.generate(5, (index) => Icon(
                                index < 4 ? CupertinoIcons.star_fill : CupertinoIcons.star_lefthalf_fill, 
                                size: 14, 
                                color: AppColors.accent,
                              )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: AppSpacings.s32),
              
              // BrewDNA Card
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
                      Icon(CupertinoIcons.hare, color: AppColors.accent, size: 32), // Placeholder DNA icon
                      SizedBox(width: AppSpacings.s16),
                      Expanded(
                        child: Text(
                          'Twoje BrewDNA',
                          style: AppTypography.title2.copyWith(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(AppSpacings.s24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.separator.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accent, size: 32),
          SizedBox(height: AppSpacings.s16),
          Text(title, style: AppTypography.subhead.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 4),
          Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.labelSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
