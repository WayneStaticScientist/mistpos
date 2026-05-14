import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/themes/app_theme.dart';

/// A screen that lets the user crop/resize their receipt logo image
/// to fit the thermal printer's width. The user can pan and zoom the
/// image within a fixed-width crop area that matches the receipt width.
class ScreenReceiptLogoCrop extends StatefulWidget {
  final String imagePath;
  final int receiptCharWidth;

  const ScreenReceiptLogoCrop({
    super.key,
    required this.imagePath,
    required this.receiptCharWidth,
  });

  @override
  State<ScreenReceiptLogoCrop> createState() => _ScreenReceiptLogoCropState();
}

class _ScreenReceiptLogoCropState extends State<ScreenReceiptLogoCrop> {
  /// Each character on a 58mm thermal printer is ~12 dots wide.
  /// 80mm printers are ~18 dots per char. We use 12 as the common default.
  static const int _dotsPerChar = 12;

  late final int _targetPixelWidth;
  final TransformationController _transformController =
      TransformationController();
  bool _isSaving = false;

  // Image dimensions
  ui.Image? _decodedImage;
  bool _imageLoaded = false;

  // Viewport and Crop dimensions (captured during build)
  double _screenWidth = 0;
  double _screenHeight = 0;
  double _cropDisplayWidth = 0;
  double _cropDisplayHeight = 0;

  @override
  void initState() {
    super.initState();
    _targetPixelWidth = widget.receiptCharWidth * _dotsPerChar;
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final bytes = File(widget.imagePath).readAsBytesSync();
      final codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes));
      final frame = await codec.getNextFrame();
      setState(() {
        _decodedImage = frame.image;
        _imageLoaded = true;
      });
    } catch (e) {
      setState(() => _imageLoaded = true);
    }
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Receipt Logo"),
        actions: [
          if (!_isSaving)
            TextButton.icon(
              onPressed: _saveCroppedImage,
              icon: Icon(Icons.check_rounded, color: Colors.green),
              label: Text(
                "Save",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (_isSaving)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // ─── Info Card ──────────────────────────────────────
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withAlpha(40)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: primaryColor, size: 20),
                10.gapWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Receipt width: ${widget.receiptCharWidth} chars · ${_targetPixelWidth}px",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppTheme.color(context),
                        ),
                      ),
                      4.gapHeight,
                      Text(
                        "Pinch to zoom and drag to position your logo within the crop area. The highlighted region will be printed.",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.color(context).withAlpha(140),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── Crop Area ──────────────────────────────────────
          Expanded(
            child: !_imageLoaded
                ? Center(child: CircularProgressIndicator())
                : _decodedImage == null
                    ? Center(
                        child: Text(
                          "Failed to load image",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : _buildCropArea(primaryColor),
          ),

          // ─── Bottom Actions ─────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              border: Border(
                top: BorderSide(
                  color: AppTheme.color(context).withAlpha(20),
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Reset button
                  OutlinedButton.icon(
                    onPressed: () {
                      _transformController.value = Matrix4.identity();
                    },
                    icon: Icon(Icons.refresh_rounded, size: 18),
                    label: Text("Reset"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.color(context),
                      side: BorderSide(
                        color: AppTheme.color(context).withAlpha(60),
                      ),
                    ),
                  ),
                  Spacer(),
                  // Save button
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveCroppedImage,
                    icon: Icon(Icons.crop_rounded, size: 18),
                    label: Text("Crop & Save"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  Widget _buildCropArea(Color primaryColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _screenWidth = constraints.maxWidth;
        _screenHeight = constraints.maxHeight;

        // Scale the crop box to fit within the screen
        _cropDisplayWidth = (_screenWidth * 0.85).clamp(0.0, _screenWidth);
        _cropDisplayHeight = _screenHeight * 0.6;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Background
            Container(color: Colors.black.withAlpha(20)),

            // Interactive image viewer
            ClipRect(
              child: InteractiveViewer(
                transformationController: _transformController,
                minScale: 0.1,
                maxScale: 10.0,
                constrained: false,
                child: Image.file(
                  File(widget.imagePath),
                  width: _cropDisplayWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Crop overlay (darkens outside the crop area)
            IgnorePointer(
              child: CustomPaint(
                size: Size(_screenWidth, _screenHeight),
                painter: _CropOverlayPainter(
                  cropRect: Rect.fromCenter(
                    center: Offset(_screenWidth / 2, _screenHeight / 2),
                    width: _cropDisplayWidth,
                    height: _cropDisplayHeight,
                  ),
                  borderColor: primaryColor,
                ),
              ),
            ),

            // Crop area border with size label
            IgnorePointer(
              child: Container(
                width: _cropDisplayWidth,
                height: _cropDisplayHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${_targetPixelWidth}px wide",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCroppedImage() async {
    if (_isSaving || _decodedImage == null || _screenWidth == 0) return;
    setState(() => _isSaving = true);

    try {
      final imageFile = File(widget.imagePath);
      final Matrix4 matrix = _transformController.value;

      // 1. Calculate the UI-to-Physical scale ratio
      // In the UI, the base image width was _cropDisplayWidth
      // Physically, we want the output width to be _targetPixelWidth
      final double uiToPhysicalScale = _targetPixelWidth / _cropDisplayWidth;

      // 2. The output image dimensions (physical pixels)
      final int physicalWidth = _targetPixelWidth;
      final int physicalHeight = (_cropDisplayHeight * uiToPhysicalScale).round();

      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);

      // 3. Setup the canvas to capture what's inside the crop box
      // The InteractiveViewer matrix maps child coordinates to viewport coordinates.
      // Viewport center is at (_screenWidth/2, _screenHeight/2).
      // Our output canvas origin (0,0) should be the top-left of the crop box.

      // Scale everything to physical resolution
      canvas.scale(uiToPhysicalScale);

      // Translate so that the crop box top-left on screen becomes (0,0) on canvas
      final double cropTopLeftX = (_screenWidth / 2) - (_cropDisplayWidth / 2);
      final double cropTopLeftY = (_screenHeight / 2) - (_cropDisplayHeight / 2);
      canvas.translate(-cropTopLeftX, -cropTopLeftY);

      // Apply the user's transformation matrix (pan/zoom)
      canvas.transform(matrix.storage);

      // 4. Draw the image at its UI-relative base size
      final double imageBaseWidth = _cropDisplayWidth;
      final double imageBaseHeight =
          _decodedImage!.height * (imageBaseWidth / _decodedImage!.width);

      canvas.drawImageRect(
        _decodedImage!,
        Rect.fromLTWH(0, 0, _decodedImage!.width.toDouble(),
            _decodedImage!.height.toDouble()),
        Rect.fromLTWH(0, 0, imageBaseWidth, imageBaseHeight),
        ui.Paint()..filterQuality = ui.FilterQuality.high,
      );

      // 5. Build and save the image
      final picture = recorder.endRecording();
      final resizedImage = await picture.toImage(physicalWidth, physicalHeight);

      // Encode as PNG
      final byteData =
          await resizedImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception("Failed to encode image");
      }

      await imageFile.writeAsBytes(byteData.buffer.asUint8List());

      Get.back(result: true);
    } catch (e) {
      setState(() => _isSaving = false);
      Get.snackbar(
        "Error",
        "Failed to save cropped image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(200),
        colorText: Colors.white,
      );
    }
  }
}

/// Paints a semi-transparent overlay outside the crop rectangle.
class _CropOverlayPainter extends CustomPainter {
  final Rect cropRect;
  final Color borderColor;

  _CropOverlayPainter({required this.cropRect, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withAlpha(120);

    // Top
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, cropRect.top),
      paint,
    );
    // Bottom
    canvas.drawRect(
      Rect.fromLTRB(0, cropRect.bottom, size.width, size.height),
      paint,
    );
    // Left
    canvas.drawRect(
      Rect.fromLTRB(0, cropRect.top, cropRect.left, cropRect.bottom),
      paint,
    );
    // Right
    canvas.drawRect(
      Rect.fromLTRB(cropRect.right, cropRect.top, size.width, cropRect.bottom),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter old) =>
      old.cropRect != cropRect;
}
