import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_segmented_control.dart';

class ScanScreen extends StatefulWidget {
  ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  int _segmentedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Camera Placeholder
          Positioned.fill(
            child: Container(
              color: AppColors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.camera_viewfinder, color: AppColors.white.withValues(alpha: 0.54), size: 80),
                    SizedBox(height: AppSpacings.s16),
                    Text('Trwa ładowanie kamery...', style: TextStyle(color: AppColors.white.withValues(alpha: 0.54))),
                  ],
                ),
              ),
            ),
          ),
          
          // Header / Segmented Control
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
              child: AppSegmentedControl(
                items: const {0: 'Etykieta', 1: 'Lista'},
                groupValue: _segmentedIndex,
                onValueChanged: (val) => setState(() => _segmentedIndex = val as int),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
