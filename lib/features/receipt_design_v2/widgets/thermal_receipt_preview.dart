import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../engine/receipt_template_engine.dart';
import '../models/receipt_template_v2_model.dart';

class ThermalReceiptPreview extends StatelessWidget {
  final ReceiptTemplateV2Model template;
  final VoidCallback? onPrintTest;
  final bool compact;

  const ThermalReceiptPreview({
    super.key,
    required this.template,
    this.onPrintTest,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final preview = ReceiptTemplateV2Engine.renderForPreview(template: template);
    final is58mm = template.paperWidth <= 32;
    final paperPixelWidth = (template.paperWidth * 8.0 + 24.0).clamp(270.0, 520.0);

    return Center(
      child: Container(
        width: paperPixelWidth,
        margin: compact ? const EdgeInsets.symmetric(vertical: 4) : const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFBF7), // authentic thermal receipt ivory
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top jagged paper tear edge
            CustomPaint(
              size: Size(paperPixelWidth, 10),
              painter: JaggedPaperEdgePainter(isTop: true),
            ),

            // Paper Header Bar (subtle indicator)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      is58mm ? "58mm Thermal Paper" : "80mm Thermal Paper",
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (onPrintTest != null)
                    InkWell(
                      onTap: onPrintTest,
                      borderRadius: BorderRadius.circular(4),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.print_outlined, size: 12, color: Colors.blueGrey),
                            SizedBox(width: 4),
                            Text(
                              "TEST",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFE5E0D5), height: 1),

            // Receipt Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: preview.elements.map((el) {
                  switch (el.type) {
                    case PreviewElementType.logo:
                      Alignment lAlignment = Alignment.center;
                      if (el.align == TextAlign.left) lAlignment = Alignment.centerLeft;
                      if (el.align == TextAlign.right) lAlignment = Alignment.centerRight;
                      final hasLogo = el.logoPath != null &&
                          el.logoPath!.isNotEmpty &&
                          File(el.logoPath!).existsSync();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Align(
                          alignment: lAlignment,
                          child: hasLogo
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: is58mm ? 130 : 180,
                                    maxHeight: 75,
                                  ),
                                  child: Image.file(
                                    File(el.logoPath!),
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => _buildLogoPlaceholder(),
                                  ),
                                )
                              : _buildLogoPlaceholder(),
                        ),
                      );

                    case PreviewElementType.spacer:
                      return SizedBox(height: el.spacerLines * 12.0);

                    case PreviewElementType.qr:
                      Alignment alignment = Alignment.center;
                      if (el.align == TextAlign.left) alignment = Alignment.centerLeft;
                      if (el.align == TextAlign.right) alignment = Alignment.centerRight;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Align(
                          alignment: alignment,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            color: Colors.white,
                            child: QrImageView(
                              data: el.text,
                              version: QrVersions.auto,
                              size: is58mm ? 100 : 130,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      );

                    case PreviewElementType.barcode:
                      Alignment bAlignment = Alignment.center;
                      if (el.align == TextAlign.left) bAlignment = Alignment.centerLeft;
                      if (el.align == TextAlign.right) bAlignment = Alignment.centerRight;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Align(
                          alignment: bAlignment,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomPaint(
                                size: Size(paperPixelWidth - 60, 36),
                                painter: BarcodePreviewPainter(),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                el.text,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  color: Color(0xFF222222),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                    case PreviewElementType.text:
                      if (el.text.isEmpty) {
                        return const SizedBox(height: 6);
                      }
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: el.align == TextAlign.center
                            ? Alignment.center
                            : (el.align == TextAlign.right
                                ? Alignment.centerRight
                                : Alignment.centerLeft),
                        child: Text(
                          el.text,
                          textAlign: el.align,
                          softWrap: false,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: is58mm ? 10.5 : 11.5,
                            height: 1.25,
                            fontWeight: el.isBold ? FontWeight.w900 : FontWeight.w500,
                            color: const Color(0xFF1B1B1B),
                            letterSpacing: -0.2,
                          ),
                        ),
                      );
                  }
                }).toList(),
              ),
            ),

            // Bottom jagged paper tear edge
            CustomPaint(
              size: Size(paperPixelWidth, 10),
              painter: JaggedPaperEdgePainter(isTop: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black26),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_outlined, size: 14, color: Colors.black54),
          SizedBox(width: 5),
          Text(
            "[RECEIPT LOGO]",
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for authentic jagged paper tear edge at top/bottom
class JaggedPaperEdgePainter extends CustomPainter {
  final bool isTop;

  JaggedPaperEdgePainter({required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFDFBF7)
      ..style = PaintingStyle.fill;

    final path = Path();
    const toothWidth = 8.0;
    const toothHeight = 4.0;
    final count = (size.width / toothWidth).ceil();

    if (isTop) {
      path.moveTo(0, size.height);
      for (int i = 0; i <= count; i++) {
        final x = i * toothWidth;
        final y = (i % 2 == 0) ? size.height : size.height - toothHeight;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.close();
    } else {
      path.moveTo(0, 0);
      for (int i = 0; i <= count; i++) {
        final x = i * toothWidth;
        final y = (i % 2 == 0) ? 0.0 : toothHeight;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, 0);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simple simulated Code128 barcode lines
class BarcodePreviewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    const pattern = [
      2, 1, 3, 1, 1, 2, 4, 1, 2, 3, 1, 2, 1, 4, 2, 1, 3, 2, 1, 1, 4, 1, 2, 2,
      1, 3, 2, 4, 1, 1, 2, 3, 1, 4, 2, 1, 1, 2, 3, 1, 2, 4, 1, 2, 3, 1, 2, 1
    ];

    double currentX = 0;
    bool isBar = true;

    for (final width in pattern) {
      final barWidth = width * 1.5;
      if (isBar && currentX + barWidth <= size.width) {
        canvas.drawRect(Rect.fromLTWH(currentX, 0, barWidth, size.height), paint);
      }
      currentX += barWidth;
      isBar = !isBar;
      if (currentX >= size.width) break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
