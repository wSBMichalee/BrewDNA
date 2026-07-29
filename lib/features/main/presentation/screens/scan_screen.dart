import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_segmented_control.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  int _segmentedIndex = 0;
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isCameraPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    debugPrint('--- CAMERA INIT START ---');
    try {
      _cameras = await availableCameras();
      debugPrint('Available cameras count: ${_cameras.length}');
      if (_cameras.isNotEmpty) {
        final backCamera = _cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        );
        debugPrint('Selected camera: ${backCamera.name} (direction: ${backCamera.lensDirection})');
        
        _controller = CameraController(
          backCamera,
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        debugPrint('Initializing camera controller...');
        await _controller!.initialize();
        debugPrint('Camera initialized successfully!');
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } else {
        debugPrint('No cameras found on device.');
      }
    } on CameraException catch (e) {
      debugPrint('CameraException caught: code=${e.code}, description=${e.description}');
      if (e.code == 'cameraPermission') {
        debugPrint('Camera permission denied.');
        if (mounted) {
          setState(() {
            _isCameraPermissionDenied = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Unknown error during camera init: $e');
    }
    debugPrint('Final state -> _isCameraInitialized: $_isCameraInitialized, _isCameraPermissionDenied: $_isCameraPermissionDenied');
    debugPrint('--- CAMERA INIT END ---');
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _controller!.value.isTakingPicture) {
      return;
    }
    try {
      final XFile picture = await _controller!.takePicture();
      final bytes = await picture.readAsBytes();
      if (mounted) {
        context.push('/main/scanning', extra: bytes);
      }
    } catch (e) {
      // Ignore or show snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(
            child: _buildCameraPreview(),
          ),
          
          // Overlays
          if (_isCameraInitialized) ...[
            // Viewfinder corners
            Center(
              child: Container(
                width: 250,
                height: 350,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.accent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            
            // Shutter Button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 4),
                      color: AppColors.accent.withValues(alpha: 0.8),
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.camera, color: AppColors.white, size: 32),
                    ),
                  ),
                ),
              ),
            ),
          ],
          
          // Header / Segmented Control
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24, vertical: AppSpacings.s16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AppSegmentedControl(
                    items: const {0: 'Etykieta', 1: 'Lista'},
                    groupValue: _segmentedIndex,
                    onValueChanged: (val) => setState(() => _segmentedIndex = val as int),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/main/discover');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.xmark, color: AppColors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_isCameraPermissionDenied) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacings.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.camera_fill, color: AppColors.separator, size: 64),
              const SizedBox(height: 16),
              Text(
                'Brak dostępu do aparatu',
                style: AppTypography.title2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Aby zeskanować etykietę, zezwól aplikacji na dostęp do aparatu w ustawieniach urządzenia.',
                style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    if (!_isCameraInitialized || _controller == null) {
      return const Center(child: CupertinoActivityIndicator(color: AppColors.white));
    }
    
    return CameraPreview(_controller!);
  }
}
