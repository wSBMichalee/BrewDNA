import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';

class ShareUtils {
  /// Captures the widget specified by the GlobalKey as a PNG image.
  /// Returns the path to the temporary file.
  static Future<String?> captureWidget(GlobalKey key) async {
    try {
      final RenderRepaintBoundary? boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      
      final pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/beer_share_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);

      return file.path;
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }

  /// Shares the image via native share dialog.
  static Future<void> shareImage(String path) async {
    try {
      await Share.shareXFiles(
        [XFile(path)],
        text: 'Sprawdź moje BrewDNA! 🍺',
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
    }
  }

  /// Saves the image to the device gallery.
  static Future<bool> saveToGallery(String path) async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final request = await Gal.requestAccess();
        if (!request) return false;
      }
      await Gal.putImage(path);
      return true;
    } catch (e) {
      debugPrint('Error saving to gallery: $e');
      return false;
    }
  }
}
