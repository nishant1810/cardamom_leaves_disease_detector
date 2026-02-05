import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../core/app_language.dart';
import '../core/constants/app_strings.dart';

class SamInteractionScreen extends StatefulWidget {
  final File imageFile;

  const SamInteractionScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<SamInteractionScreen> createState() =>
      _SamInteractionScreenState();
}

class _SamInteractionScreenState extends State<SamInteractionScreen> {
  Offset? tapPoint;
  Offset? boxStart;
  Offset? boxEnd;
  bool autoSegmentation = true;

  late img.Image decodedImage;

  @override
  void initState() {
    super.initState();
    decodedImage =
    img.decodeImage(widget.imageFile.readAsBytesSync())!;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (_, lang, __) {
        final strings = AppStrings.of(lang);

        return Scaffold(
          appBar: AppBar(
            title: Text(strings.leafSegmentation),
            backgroundColor: Colors.green.shade700,
          ),
          body: Column(
            children: [
              Expanded(child: _buildImageArea()),
              _buildControls(strings),
            ],
          ),
        );
      },
    );
  }

  // ================= IMAGE + GESTURE =================
  Widget _buildImageArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (d) {
            if (!autoSegmentation) {
              setState(() {
                tapPoint = d.localPosition;
                boxStart = null;
                boxEnd = null;
              });
            }
          },
          onPanStart: (d) {
            if (!autoSegmentation) {
              setState(() {
                boxStart = d.localPosition;
                boxEnd = null;
                tapPoint = null;
              });
            }
          },
          onPanUpdate: (d) {
            if (!autoSegmentation && boxStart != null) {
              setState(() {
                boxEnd = d.localPosition;
              });
            }
          },
          child: Stack(
            children: [
              Center(
                child: Image.file(
                  widget.imageFile,
                  fit: BoxFit.contain,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              ),

              // 🔴 TAP POINT
              if (tapPoint != null)
                Positioned(
                  left: tapPoint!.dx - 6,
                  top: tapPoint!.dy - 6,
                  child: const Icon(
                    Icons.circle,
                    color: Colors.red,
                    size: 12,
                  ),
                ),

              // 🟩 BOX
              if (boxStart != null && boxEnd != null)
                Positioned.fromRect(
                  rect: Rect.fromPoints(boxStart!, boxEnd!),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ================= CONTROLS =================
  Widget _buildControls(AppStrings strings) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SwitchListTile(
            title: Text(strings.autoSegmentation),
            value: autoSegmentation,
            onChanged: (v) {
              setState(() {
                autoSegmentation = v;
                tapPoint = null;
                boxStart = null;
                boxEnd = null;
              });
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _applySegmentation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: Text(strings.applySegmentation),
          ),
        ],
      ),
    );
  }

  // ================= APPLY =================
  void _applySegmentation() {
    if (autoSegmentation) {
      Navigator.pop(context, widget.imageFile);
      return;
    }

    if (tapPoint != null) {
      final cropped = _cropAroundPoint(tapPoint!, 120);
      Navigator.pop(context, cropped);
      return;
    }

    if (boxStart != null && boxEnd != null) {
      final cropped = _cropWithBox(boxStart!, boxEnd!);
      Navigator.pop(context, cropped);
      return;
    }

    final strings = AppStrings.of(appLanguage.value);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.selectRegionWarning),
      ),
    );
  }

  // ================= IMAGE CROP =================
  File _cropWithBox(Offset p1, Offset p2) {
    final left =
    p1.dx.clamp(0, decodedImage.width.toDouble()).toInt();
    final top =
    p1.dy.clamp(0, decodedImage.height.toDouble()).toInt();
    final right =
    p2.dx.clamp(0, decodedImage.width.toDouble()).toInt();
    final bottom =
    p2.dy.clamp(0, decodedImage.height.toDouble()).toInt();

    final width = (right - left).abs().clamp(1, decodedImage.width);
    final height =
    (bottom - top).abs().clamp(1, decodedImage.height);

    final cropped = img.copyCrop(
      decodedImage,
      x: left,
      y: top,
      width: width,
      height: height,
    );

    final file = File(
      '${widget.imageFile.parent.path}/sam_crop_${DateTime.now().millisecondsSinceEpoch}.png',
    );

    file.writeAsBytesSync(img.encodePng(cropped));
    return file;
  }

  File _cropAroundPoint(Offset p, double radius) {
    return _cropWithBox(
      Offset(p.dx - radius, p.dy - radius),
      Offset(p.dx + radius, p.dy + radius),
    );
  }
}
