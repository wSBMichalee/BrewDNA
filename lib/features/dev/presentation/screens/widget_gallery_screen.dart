import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_segmented_control.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../../../core/widgets/taste_slider.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_tab_bar.dart';

class WidgetGalleryScreen extends StatefulWidget {
  WidgetGalleryScreen({super.key});

  @override
  State<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends State<WidgetGalleryScreen> {
  String _segmentValue = 'oceny';
  double _rating = 3.5;
  double _tasteValue = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.groupedBackground,
      appBar: AppBar(
        title: Text('Widget Gallery'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      // bottomNavigationBar: AppTabBar(
        // currentIndex: 0,
        // onTap: (_) {},
        // items: [
          // BottomNavigationBarItem(icon: Icon(CupertinoIcons.camera), label: 'Skanuj'),
          // BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart), label: 'Moje Piwa'),
      //  ],
      // ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacings.s16),
        children: [
          _buildSection('AppButton (Primary)', AppButton(
            text: 'Zapisz ocenę',
            onPressed: () {},
          )),
          _buildSection('AppButton (Secondary)', AppButton(
            text: 'Anuluj',
            isPrimary: false,
            onPressed: () {},
          )),
          _buildSection('AppButton (Loading)', AppButton(
            text: 'Zapisz',
            isLoading: true,
            onPressed: () {},
          )),
          _buildSection('AppCard', AppCard(
            hasShadow: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Karta z cieniem', style: AppTypography.title3),
                SizedBox(height: AppSpacings.s8),
                Text('Przykładowy opis karty.', style: AppTypography.body),
              ],
            ),
          )),
          _buildSection('AppSegmentedControl', AppSegmentedControl<String>(
            items: const {
              'oceny': 'Oceny',
              'wishlista': 'Wishlista',
              'piwniczka': 'Piwniczka',
            },
            groupValue: _segmentValue,
            onValueChanged: (v) {
              if (v != null) setState(() => _segmentValue = v);
            },
          )),
          _buildSection('StarRating', Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tylko do odczytu (4.5):', style: AppTypography.caption),
              StarRating(rating: 4.5),
              SizedBox(height: AppSpacings.s8),
              Text('Interaktywny:', style: AppTypography.caption),
              StarRating(
                rating: _rating,
                onRatingChanged: (v) => setState(() => _rating = v),
              ),
            ],
          )),
          _buildSection('TasteSlider', TasteSlider(
            leftLabel: 'Lekkie',
            rightLabel: 'Intensywne',
            value: _tasteValue,
            onChanged: (v) => setState(() => _tasteValue = v),
          )),
          _buildSection('AppAvatar', Row(
            children: [
              AppAvatar(url: 'https://i.pravatar.cc/150?img=11', size: 64),
              SizedBox(width: AppSpacings.s16),
              AppAvatar(size: 64), // placeholder
            ],
          )),
          _buildSection('AppEmptyState', AppCard(
            child: AppEmptyState(
              icon: CupertinoIcons.heart_slash,
              title: 'Brak ocen',
              description: 'Twoja wishlista jest pusta.',
              buttonText: 'Odkryj piwa',
              onButtonTap: () {},
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacings.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTypography.caption.copyWith(color: AppColors.labelSecondary),
          ),
          SizedBox(height: AppSpacings.s12),
          child,
        ],
      ),
    );
  }
}
