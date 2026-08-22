import '../../../../core/widgets/app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../beer/domain/entities/beer.dart';
import '../../../beer/presentation/widgets/share_card.dart';
import '../../../beer/presentation/utils/share_utils.dart';
import 'dart:ui';

class ProfileShareSheet extends StatefulWidget {
  final Beer beer;
  const ProfileShareSheet({super.key, required this.beer});

  @override
  State<ProfileShareSheet> createState() => ProfileShareSheetState();
}

class ProfileShareSheetState extends State<ProfileShareSheet> {
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

