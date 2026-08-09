import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

/// Konfiguracja wizualna dla danego stylu piwa: ikona + dedykowana paleta gradientu.
class BeerStyleTheme {
  final IconData icon;
  final List<Color> gradientColors;
  final Color iconColor;

  const BeerStyleTheme({
    required this.icon,
    required this.gradientColors,
    required this.iconColor,
  });

  /// Mapuje styl piwa (nazwę ze słownika/bazy) na odpowiednią ikonę i gradient.
  factory BeerStyleTheme.fromStyle(String style) {
    final s = style.toLowerCase();

    if (s.contains('ipa') || s.contains('india pale ale') || s.contains('neipa') || s.contains('hazy')) {
      return const BeerStyleTheme(
        icon: CupertinoIcons.bolt_fill,
        gradientColors: [Color(0xFF0F3B20), Color(0xFF1F6B3C), Color(0xFF389E5E)],
        iconColor: Color(0xFFC8F5D8),
      );
    } else if (s.contains('lager') || s.contains('pils')) {
      return const BeerStyleTheme(
        icon: CupertinoIcons.sun_max_fill,
        gradientColors: [Color(0xFF4A3405), Color(0xFF9E6E10), Color(0xFFD49A24)],
        iconColor: Color(0xFFFFF7D6),
      );
    } else if (s.contains('stout')) {
      return const BeerStyleTheme(
        icon: CupertinoIcons.moon_stars_fill,
        gradientColors: [Color(0xFF0D0603), Color(0xFF1E0E06), Color(0xFF3B1E0C)],
        iconColor: Color(0xFFE8BA87),
      );
    } else if (s.contains('porter')) {
      return const BeerStyleTheme(
        icon: CupertinoIcons.moon_fill,
        gradientColors: [Color(0xFF180A04), Color(0xFF30180A), Color(0xFF572F15)],
        iconColor: Color(0xFFF0CCA0),
      );
    } else if (s.contains('weizen') || s.contains('wheat') || s.contains('pszen')) {
      return const BeerStyleTheme(
        icon: CupertinoIcons.wind,
        gradientColors: [Color(0xFF45300B), Color(0xFF8C6618), Color(0xFFC99832)],
        iconColor: Color(0xFFFFFBE8),
      );
    } else if (s.contains('sour') || s.contains('kwas') || s.contains('gose') || s.contains('lambic')) {
      return const BeerStyleTheme(
        icon: CupertinoIcons.drop_triangle_fill,
        gradientColors: [Color(0xFF2E0A2B), Color(0xFF5C1A57), Color(0xFF993D90)],
        iconColor: Color(0xFFFFD4F5),
      );
    } else if (s.contains('amber') || s.contains('belgian') || s.contains('ale') || s.contains('bock') || s.contains('koźlak')) {
      return const BeerStyleTheme(
        icon: CupertinoIcons.flame_fill,
        gradientColors: [Color(0xFF381205), Color(0xFF6E250A), Color(0xFFB85918)],
        iconColor: Color(0xFFFFDFB8),
      );
    } else {
      return const BeerStyleTheme(
        icon: CupertinoIcons.drop,
        gradientColors: [Color(0xFF261508), Color(0xFF4A2A10), Color(0xFF8A551E)],
        iconColor: Color(0xFFFBE4A8),
      );
    }
  }
}

/// Subtelna mikro-tekstura unoszących się bąbelków piwa w tle hero.
class BeerBubblesPainter extends CustomPainter {
  final Color color;

  const BeerBubblesPainter({required this.color});

  static const List<_BubbleSpec> _bubbles = [
    _BubbleSpec(0.12, 0.18, 2.5, 0.06),
    _BubbleSpec(0.22, 0.35, 4.0, 0.05),
    _BubbleSpec(0.18, 0.62, 2.0, 0.07),
    _BubbleSpec(0.28, 0.78, 3.5, 0.06),
    _BubbleSpec(0.38, 0.22, 3.0, 0.08),
    _BubbleSpec(0.45, 0.48, 5.0, 0.05),
    _BubbleSpec(0.52, 0.15, 2.0, 0.07),
    _BubbleSpec(0.58, 0.68, 4.5, 0.06),
    _BubbleSpec(0.65, 0.32, 3.0, 0.08),
    _BubbleSpec(0.72, 0.55, 2.5, 0.06),
    _BubbleSpec(0.78, 0.20, 4.0, 0.07),
    _BubbleSpec(0.85, 0.75, 3.5, 0.05),
    _BubbleSpec(0.88, 0.42, 2.0, 0.08),
    _BubbleSpec(0.15, 0.85, 3.0, 0.05),
    _BubbleSpec(0.82, 0.88, 4.0, 0.06),
    _BubbleSpec(0.32, 0.90, 2.5, 0.07),
    _BubbleSpec(0.68, 0.82, 3.5, 0.06),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in _bubbles) {
      final center = Offset(b.relX * size.width, b.relY * size.height);
      final paintFill = Paint()
        ..color = color.withValues(alpha: b.opacity)
        ..style = PaintingStyle.fill;
      final paintStroke = Paint()
        ..color = color.withValues(alpha: b.opacity * 1.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawCircle(center, b.radius, paintFill);
      canvas.drawCircle(center, b.radius, paintStroke);
    }
  }

  @override
  bool shouldRepaint(covariant BeerBubblesPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _BubbleSpec {
  final double relX;
  final double relY;
  final double radius;
  final double opacity;

  const _BubbleSpec(this.relX, this.relY, this.radius, this.opacity);
}

/// Dynamiczny placeholder z gradientem i ikoną dopasowaną do stylu piwa.
class BeerStylePlaceholder extends StatelessWidget {
  final String style;
  final bool isLarge;
  final bool isHero;
  final double? iconSize;
  final double? circleSize;

  const BeerStylePlaceholder({
    super.key,
    required this.style,
    this.isLarge = false,
    this.isHero = false,
    this.iconSize,
    this.circleSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = BeerStyleTheme.fromStyle(style);
    final effectiveCircle = circleSize ?? (isHero ? 72.0 : (isLarge ? 64.0 : 38.0));
    final effectiveIcon = iconSize ?? (isHero ? 36.0 : (isLarge ? 32.0 : 18.0));

    return Container(
      decoration: BoxDecoration(
        gradient: isHero
            ? RadialGradient(
                center: const Alignment(0.0, -0.2),
                radius: 1.1,
                colors: [
                  theme.gradientColors.last.withValues(alpha: 0.85),
                  theme.gradientColors.first,
                  const Color(0xFF0D0D0D),
                ],
                stops: const [0.0, 0.65, 1.0],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: theme.gradientColors,
              ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isHero)
            Positioned.fill(
              child: CustomPaint(
                painter: BeerBubblesPainter(color: theme.iconColor),
              ),
            ),
          Center(
            child: Container(
              width: effectiveCircle,
              height: effectiveCircle,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.28),
                border: Border.all(
                  color: theme.iconColor.withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: isHero
                    ? [
                        BoxShadow(
                          color: theme.gradientColors.last.withValues(alpha: 0.25),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                theme.icon,
                size: effectiveIcon,
                color: theme.iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inteligentny widget obrazka: jeśli URL jest placeholderem/404, natychmiast
/// renderuje [BeerStylePlaceholder] bez wykonywania niepotrzebnych requestów HTTP.
class BeerImageOrPlaceholder extends StatelessWidget {
  final String imageUrl;
  final String style;
  final bool isLarge;
  final bool isHero;
  final double? iconSize;
  final double? circleSize;

  const BeerImageOrPlaceholder({
    super.key,
    required this.imageUrl,
    required this.style,
    this.isLarge = false,
    this.isHero = false,
    this.iconSize,
    this.circleSize,
  });

  bool get _hasRealImage {
    if (imageUrl.isEmpty) return false;
    if (imageUrl.contains('image-placeholder') ||
        imageUrl.contains('placeholder') ||
        imageUrl.contains('screensdesign.com')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasRealImage) {
      return BeerStylePlaceholder(
        style: style,
        isLarge: isLarge,
        isHero: isHero,
        iconSize: iconSize,
        circleSize: circleSize,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.separator,
        highlightColor: AppColors.background,
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, url, error) => BeerStylePlaceholder(
        style: style,
        isLarge: isLarge,
        isHero: isHero,
        iconSize: iconSize,
        circleSize: circleSize,
      ),
    );
  }
}
