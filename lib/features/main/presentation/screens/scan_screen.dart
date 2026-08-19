import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../paywall/presentation/screens/paywall_selection_screen.dart';
import '../../../../core/di/injection.dart';
import '../../../paywall/domain/entities/subscription_plan.dart';
import '../../../beer/domain/repositories/i_scan_limit_repository.dart';

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

  int? _remainingScans;
  final bool _isPremium = currentSubscription != SubscriptionPlan.free;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
    _fetchScanLimit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPopups();
    });
  }

  Future<void> _fetchScanLimit() async {
    if (_isPremium) return;
    
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final remaining = await getIt<IScanLimitRepository>().getRemainingScans(userId);
    if (mounted) {
      setState(() {
        _remainingScans = remaining;
      });
    }
  }

  Future<void> _checkAndShowPopups() async {
    final prefs = await SharedPreferences.getInstance();
    final promoShown = prefs.getBool('scan_promo_shown') ?? false;

    if (!promoShown) {
      await prefs.setBool('scan_promo_shown', true);
      if (!mounted) return;
      
      // Pokazuje promo
      await _showPromoBottomSheet();
      
      if (!mounted) return;
      // Od razu po promo pokazuje paywall
      await _showPaywallBottomSheet();
    }
  }

  Future<void> _showPromoBottomSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0).copyWith(
            bottom: MediaQuery.of(context).padding.bottom + 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.separator,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Icon(CupertinoIcons.sparkles, size: 64, color: AppColors.accent),
              const SizedBox(height: 16),
              Text(
                'Inteligentne skanowanie',
                style: AppTypography.title1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Zeskanuj dowolną etykietę piwa, a nasze AI błyskawicznie przeanalizuje profil smakowy, styl i dopasowanie do Twojego gustu.',
                style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Wypróbuj teraz',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPaywallBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: const PaywallSelectionScreen(isPromoModal: true),
          ),
        );
      },
    );
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
        debugPrint(
          'Selected camera: ${backCamera.name} (direction: ${backCamera.lensDirection})',
        );

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
      debugPrint(
        'CameraException caught: code=${e.code}, description=${e.description}',
      );
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
    debugPrint(
      'Final state -> _isCameraInitialized: $_isCameraInitialized, _isCameraPermissionDenied: $_isCameraPermissionDenied',
    );
    debugPrint('--- CAMERA INIT END ---');
  }

  Future<void> _takePicture() async {
    if (!_isPremium && _remainingScans != null && _remainingScans! <= 0) {
      await _showPaywallBottomSheet();
      return;
    }

    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture) {
      return;
    }
    try {
      final XFile picture = await _controller!.takePicture();
      final bytes = await picture.readAsBytes();

      if (!_isPremium) {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null) {
          await getIt<IScanLimitRepository>().incrementScanCount(userId);
          // Odświeżamy limit po zeskanowaniu, żeby wracając na ten ekran mieć aktualny
          _fetchScanLimit();
        }
      }

      if (mounted) {
        context.push('/main/scanning', extra: bytes);
      }
    } catch (e) {
      // Ignore or show snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // 1. Spód: Camera Preview (zawsze pełny ekran, nawet jak ukryte na symulatorze)
          Positioned.fill(child: _buildCameraPreview()),

          // 2. Nakładka (zawsze widoczna)
          SafeArea(
            child: Column(
              children: [
                // A. Górny pasek: X (lewo) i Flash (prawo)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacings.s16,
                    vertical: AppSpacings.s8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Przycisk X
                      GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/main/discover');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.xmark,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      // Przycisk Flash (obecnie no-op placeholder)
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement flash toggle when camera controller supports it
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.bolt,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // B. Środek: Tekst instruktażowy i ramka Viewfindera
                Text(
                  l10n.scanInstruction,
                  style: AppTypography.subhead.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_isPremium && _remainingScans != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_remainingScans/5 skanów w tym miesiącu',
                      style: AppTypography.footnote.copyWith(
                        color: _remainingScans! > 0 ? AppColors.white : CupertinoColors.systemRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  width: 250,
                  height: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.accent, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                const Spacer(),

                // C. Dół: Segmented Control
                AdaptiveSegmentedControl(
                  labels: const ['Etykieta', 'Lista'],
                  selectedIndex: _segmentedIndex,
                  shrinkWrap: true,
                  onValueChanged: (val) =>
                      setState(() => _segmentedIndex = val),
                ),
                const SizedBox(height: 32),

                // Dolny pasek: Galeria, Migawka, (Puste miejsce dla symetrii)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.s32)
                      .copyWith(bottom: AppSpacings.s24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Ikona galerii
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement image picker from gallery
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.photo,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      // Duży biały przycisk migawki
                      GestureDetector(
                        onTap: _isCameraInitialized ? _takePicture : null,
                        child: Opacity(
                          opacity: _isCameraInitialized ? 1.0 : 0.5,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 4,
                              ),
                              color: AppColors.accent.withValues(alpha: 0.8),
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.camera,
                                color: AppColors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Pusty element dla zachowania symetrii w Row
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ],
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
              const Icon(
                CupertinoIcons.camera_fill,
                color: AppColors.separator,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Brak dostępu do aparatu',
                style: AppTypography.title2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Aby zeskanować etykietę, zezwól aplikacji na dostęp do aparatu w ustawieniach urządzenia.',
                style: AppTypography.body.copyWith(
                  color: AppColors.labelSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!_isCameraInitialized || _controller == null) {
      return const Center(
        child: CupertinoActivityIndicator(color: AppColors.white),
      );
    }

    return CameraPreview(_controller!);
  }
}
