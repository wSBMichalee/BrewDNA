import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/taste_profile.dart';

class TasteProfileEditorSheet extends StatefulWidget {
  final TasteProfile profile;
  final Function(double strength, double bitterness, double fruitiness) onSave;

  const TasteProfileEditorSheet({
    super.key,
    required this.profile,
    required this.onSave,
  });

  @override
  State<TasteProfileEditorSheet> createState() => TasteProfileEditorSheetState();
}

class TasteProfileEditorSheetState extends State<TasteProfileEditorSheet> {
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
