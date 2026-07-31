import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/star_rating.dart';
import '../bloc/rating_cubit.dart';
import '../bloc/rating_state.dart';
import '../widgets/share_card.dart';
import '../utils/share_utils.dart';

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

  bool _showShareCard = false;
  bool _isCapturing = false;
  final GlobalKey _shareCardKey = GlobalKey();

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
            setState(() {
              _showShareCard = true;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.rateBeerSavedSuccess)));
          },
          error: (msg) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          },
          orElse: () {},
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.r),
            topRight: Radius.circular(32.r),
          ),
        ),
        child: _showShareCard
            ? _buildShareView()
            : Column(
                children: [
                  // Handle & Title
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacings.s24,
                      vertical: AppSpacings.s16,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColors.separator,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(height: AppSpacings.s16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(8.r),
                                    image: widget.imageUrl.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              widget.imageUrl,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: widget.imageUrl.isEmpty
                                      ? const Icon(
                                          CupertinoIcons.photo,
                                          color: AppColors.separator,
                                        )
                                      : null,
                                ),
                                SizedBox(width: AppSpacings.s12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.beerName,
                                      style: AppTypography.title2,
                                    ),
                                    Text(
                                      widget.breweryName,
                                      style: AppTypography.subhead.copyWith(
                                        color: AppColors.labelSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor: AppColors.card,
                              radius: 16,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  CupertinoIcons.xmark,
                                  size: 16.sp,
                                  color: AppColors.labelSecondary,
                                ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacings.s24,
                        vertical: AppSpacings.s16,
                      ),
                      child: Column(
                        children: [
                          // Main rating
                          StarRating(
                            rating: _overall.toDouble(),
                            size: 40.sp,
                            onRatingChanged: (rating) {
                              setState(() {
                                _overall = rating.round();
                              });
                            },
                          ),
                          SizedBox(height: AppSpacings.s8),
                          Text(
                            AppLocalizations.of(context)!.rateBeerOverallLabel,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.labelSecondary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: AppSpacings.s32),

                          // Sliders
                          _buildSlider(
                            AppLocalizations.of(context)!.rateBeerTaste,
                            _taste,
                            (v) => setState(() => _taste = v),
                          ),
                          _buildSlider(
                            AppLocalizations.of(context)!.rateBeerAroma,
                            _aroma,
                            (v) => setState(() => _aroma = v),
                          ),
                          _buildSlider(
                            AppLocalizations.of(context)!.rateBeerBitterness,
                            _bitterness,
                            (v) => setState(() => _bitterness = v),
                          ),
                          _buildSlider(
                            AppLocalizations.of(context)!.rateBeerAppearance,
                            _appearance,
                            (v) => setState(() => _appearance = v),
                          ),
                          _buildSlider(
                            AppLocalizations.of(context)!.rateBeerDrinkability,
                            _drinkability,
                            (v) => setState(() => _drinkability = v),
                          ),

                          SizedBox(height: AppSpacings.s32),

                          // Note
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!.rateBeerNoteLabel,
                              style: AppTypography.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacings.s8),
                          CupertinoTextField(
                            controller: _noteController,
                            placeholder: AppLocalizations.of(context)!.rateBeerNotePlaceholder,
                            maxLines: 4,
                            padding: EdgeInsets.all(AppSpacings.s16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: AppColors.separator),
                            ),
                          ),

                          SizedBox(height: AppSpacings.s32),

                          // Image upload placeholder
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!.rateBeerPhotoLabel,
                              style: AppTypography.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacings.s8),
                          // TODO: Implement actual image upload to Supabase Storage
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppSpacings.s24),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.separator,
                                style: BorderStyle.solid,
                              ), // In a real app we'd use dashed border here
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  CupertinoIcons.camera,
                                  color: AppColors.labelSecondary,
                                  size: 32.sp,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  AppLocalizations.of(context)!.rateBeerPhotoAdd,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.labelSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 100.h),
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
                          final isSubmitting = state.maybeWhen(
                            submitting: () => true,
                            orElse: () => false,
                          );
                          return AppButton(
                            text: isSubmitting
                                ? AppLocalizations.of(context)!.rateBeerSaving
                                : AppLocalizations.of(context)!.rateBeerSaveButton,
                            isPrimary: true,
                            onPressed: isSubmitting || _overall == 0
                                ? null
                                : () {
                                    context.read<RatingCubit>().submitRating(
                                      beerId: widget.beerId,
                                      overall: _overall,
                                      taste: _taste.round(),
                                      aroma: _aroma.round(),
                                      bitterness: _bitterness.round(),
                                      appearance: _appearance.round(),
                                      drinkability: _drinkability.round(),
                                      note:
                                          _noteController.text.trim().isNotEmpty
                                          ? _noteController.text.trim()
                                          : null,
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

  Widget _buildSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacings.s16),
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
            ),
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

  Widget _buildShareView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacings.s24,
            vertical: AppSpacings.s16,
          ),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.separator,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: AppSpacings.s16),
              Text(AppLocalizations.of(context)!.rateBeerYourRating, style: AppTypography.title2),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacings.s24,
              vertical: AppSpacings.s16,
            ),
            child: Column(
              children: [
                RepaintBoundary(
                  key: _shareCardKey,
                  child: ShareCard(
                    beerName: widget.beerName,
                    breweryName: widget.breweryName,
                    beerStyle: 'Craft Beer',
                    imageUrl: widget.imageUrl,
                    rating: _overall.toDouble(),
                    matchPercentage: 96,
                    isCapturing: _isCapturing,
                    onSaveTap: () => _handleSaveToGallery(),
                  ),
                ),

                SizedBox(height: AppSpacings.s32),

                AppButton(
                  text: AppLocalizations.of(context)!.rateBeerShareButton,
                  onPressed: _isCapturing ? () {} : _handleShare,
                ),

                SizedBox(height: AppSpacings.s16),

                AppButton(
                  text: AppLocalizations.of(context)!.rateBeerClose,
                  onPressed: () => context.pop(),
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSaveToGallery() async {
    setState(() => _isCapturing = true);
    await Future.delayed(const Duration(milliseconds: 100)); // wait for frame
    final path = await ShareUtils.captureWidget(_shareCardKey);
    setState(() => _isCapturing = false);

    if (path != null) {
      final success = await ShareUtils.saveToGallery(path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? AppLocalizations.of(context)!.rateBeerGallerySavedSuccess : AppLocalizations.of(context)!.rateBeerGallerySavedError),
          ),
        );
      }
    }
  }

  Future<void> _handleShare() async {
    setState(() => _isCapturing = true);
    await Future.delayed(const Duration(milliseconds: 100)); // wait for frame
    final path = await ShareUtils.captureWidget(_shareCardKey);
    setState(() => _isCapturing = false);

    if (path != null) {
      await ShareUtils.shareImage(path);
    }
  }
}
