import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/star_rating.dart';

class ShareCard extends StatelessWidget {
  final String beerName;
  final String breweryName;
  final String beerStyle;
  final String imageUrl;
  final double rating;
  final int matchPercentage;
  final bool isCapturing;
  final VoidCallback? onSaveTap;

  const ShareCard({
    super.key,
    required this.beerName,
    required this.breweryName,
    required this.beerStyle,
    required this.imageUrl,
    required this.rating,
    required this.matchPercentage,
    this.isCapturing = false,
    this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.r),
          // A subtle border so the white card doesn't bleed into the app background
          border: Border.all(color: AppColors.separator),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Top 65%: Image + Gradient + Name
            Expanded(
              flex: 65,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.card,
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.photo,
                          color: AppColors.separator,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.card,
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.photo,
                          color: AppColors.separator,
                        ),
                      ),
                    ),
                  ),
                  // Soft gradient at the bottom passing into AppColors.background
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 160.h,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, AppColors.background],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Beer Name (bold, white, positioned higher up)
                  Positioned(
                    bottom: 60.h,
                    left: 20.w,
                    right: 20.w,
                    child: Text(
                      beerName,
                      style: AppTypography.largeTitle.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 42.sp,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom 35%: Details
            Expanded(
              flex: 35,
              child: Container(
                color: AppColors.background,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brewery and Style (Single line)
                    Text(
                      '$breweryName · $beerStyle',
                      style: AppTypography.headline.copyWith(
                        color: AppColors.label,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 16.h),

                    // Stars
                    StarRating(rating: rating, size: 32.sp),

                    SizedBox(height: 4.h),

                    // MOJA OCENA label
                    Text(
                      AppLocalizations.of(context)!.shareCardMyRatingLabel,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.labelSecondary,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Match Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: AppColors.accent, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.heart_solid,
                            color: AppColors.accent,
                            size: 16.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '$matchPercentage${AppLocalizations.of(context)!.shareCardMatchSuffix}',
                            style: AppTypography.subhead.copyWith(
                              color: AppColors.label, // Dark text, NOT amber
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Bottom Row (Zapisz / BrewDNA)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Save Button (Hidden during capture)
                        Opacity(
                          opacity: isCapturing ? 0.0 : 1.0,
                          child: GestureDetector(
                            onTap: isCapturing ? null : onSaveTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: AppColors.label),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.arrow_down_doc,
                                    size: 16.sp,
                                    color: AppColors.label,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    AppLocalizations.of(context)!.shareCardSave,
                                    style: AppTypography.subhead.copyWith(
                                      color: AppColors.label,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // BrewDNA Logo/Text
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.tag_fill,
                              size: 12.sp,
                              color: AppColors.labelSecondary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'BrewDNA',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.labelSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
