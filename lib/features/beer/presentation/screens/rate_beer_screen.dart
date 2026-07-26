import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/star_rating.dart';
import '../bloc/rating_cubit.dart';
import '../bloc/rating_state.dart';

class RateBeerScreen extends StatefulWidget {
  final String beerId;
  final String beerName;
  final String breweryName;
  final String imageUrl;

  const RateBeerScreen({
    super.key,
    required this.beerId,
    required this.beerName,
    required this.breweryName,
    required this.imageUrl,
  });

  @override
  State<RateBeerScreen> createState() => _RateBeerScreenState();
}

class _RateBeerScreenState extends State<RateBeerScreen> {
  int _overall = 0;
  double _taste = 5;
  double _aroma = 5;
  double _bitterness = 5;
  double _appearance = 5;
  double _drinkability = 5;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RatingCubit, RatingState>(
      listener: (context, state) {
        state.maybeWhen(
          submitted: () {
            if (context.canPop()) context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ocena zapisana!')),
            );
          },
          error: (msg) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          },
          orElse: () {},
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            // Handle & Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.separator,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: AppSpacings.s16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(8),
                              image: widget.imageUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(widget.imageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: widget.imageUrl.isEmpty
                                ? const Icon(CupertinoIcons.photo, color: AppColors.separator)
                                : null,
                          ),
                          SizedBox(width: AppSpacings.s12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.beerName, style: AppTypography.title2),
                              Text(widget.breweryName, style: AppTypography.subhead.copyWith(color: AppColors.labelSecondary)),
                            ],
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.card,
                        radius: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(CupertinoIcons.xmark, size: 16, color: AppColors.labelSecondary),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
                child: Column(
                  children: [
                    // Main rating
                    StarRating(
                      rating: _overall.toDouble(),
                      size: 40,
                      onRatingChanged: (rating) {
                        setState(() {
                          _overall = rating.round();
                        });
                      },
                    ),
                    SizedBox(height: AppSpacings.s8),
                    Text('TWOJA OGÓLNA OCENA', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary, letterSpacing: 1.2)),
                    SizedBox(height: AppSpacings.s32),
                    
                    // Sliders
                    _buildSlider('Smak', _taste, (v) => setState(() => _taste = v)),
                    _buildSlider('Aromat', _aroma, (v) => setState(() => _aroma = v)),
                    _buildSlider('Gorycz', _bitterness, (v) => setState(() => _bitterness = v)),
                    _buildSlider('Wygląd', _appearance, (v) => setState(() => _appearance = v)),
                    _buildSlider('Pijalność', _drinkability, (v) => setState(() => _drinkability = v)),
                    
                    SizedBox(height: AppSpacings.s32),
                    
                    // Note
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Notatka (opcjonalnie)', style: AppTypography.subhead.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: AppSpacings.s8),
                    CupertinoTextField(
                      controller: _noteController,
                      placeholder: 'Co Ci się podobało?',
                      maxLines: 4,
                      padding: EdgeInsets.all(AppSpacings.s16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.separator),
                      ),
                    ),
                    
                    SizedBox(height: AppSpacings.s32),
                    
                    // Image upload placeholder
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Zdjęcie', style: AppTypography.subhead.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: AppSpacings.s8),
                    // TODO: Implement actual image upload to Supabase Storage
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacings.s24),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.separator, style: BorderStyle.solid), // In a real app we'd use dashed border here
                      ),
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.camera, color: AppColors.labelSecondary, size: 32),
                          SizedBox(height: 8),
                          Text('Dodaj zdjęcie (TODO)', style: AppTypography.caption.copyWith(color: AppColors.labelSecondary)),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            // Save Button
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacings.s24),
                child: BlocBuilder<RatingCubit, RatingState>(
                  builder: (context, state) {
                    final isSubmitting = state.maybeWhen(submitting: () => true, orElse: () => false);
                    return AppButton(
                      text: isSubmitting ? 'Zapisywanie...' : 'Zapisz ocenę',
                      isPrimary: true,
                      onPressed: isSubmitting || _overall == 0 ? null : () {
                        context.read<RatingCubit>().submitRating(
                          beerId: widget.beerId,
                          overall: _overall,
                          taste: _taste.round(),
                          aroma: _aroma.round(),
                          bitterness: _bitterness.round(),
                          appearance: _appearance.round(),
                          drinkability: _drinkability.round(),
                          note: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null,
                        );
                      },
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

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacings.s16),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: CupertinoSlider(
              value: value,
              min: 0,
              max: 5,
              activeColor: AppColors.accent,
              thumbColor: AppColors.accent,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
