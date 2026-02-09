import 'dart:io';
import 'package:flutter/material.dart';

import '../../core/localization/app_language.dart';
import '../../core/localization/app_strings.dart';
import '../../core/models/scan_result.dart';
import '../../services/model_service.dart';
import '../result/result_screen.dart';
import 'sam_interaction_screen.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File imageFile;

  const ImagePreviewScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _isProcessing = false;

  Future<void> _analyzeImage(File imageToAnalyze) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final ScanResult result =
      await ModelService.runPipeline(imageToAnalyze);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: result),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final strings = AppStrings.of(appLanguage.value);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            strings.errorMessage("prediction_failed"),
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (_, lang, __) {
        final strings = AppStrings.of(lang);

        return Scaffold(
          backgroundColor: Colors.black,

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              strings.previewImage,
              style: const TextStyle(color: Colors.white),
            ),
          ),

          body: SafeArea(
            child: Column(
              children: [
                // 🖼 IMAGE PREVIEW
                Expanded(
                  child: Center(
                    child: Image.file(
                      widget.imageFile,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // 🔘 ACTION BUTTONS
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // 🔄 RETAKE
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side:
                            const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                          onPressed: _isProcessing
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(strings.retake),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // ✋ SELECT LEAF REGION (SAM)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.orange.shade700,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                          onPressed: _isProcessing
                              ? null
                              : () async {
                            final File? segmented =
                            await Navigator.push<File?>(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SamInteractionScreen(
                                      imageFile:
                                      widget.imageFile,
                                    ),
                              ),
                            );

                            if (segmented != null) {
                              _analyzeImage(segmented);
                            }
                          },
                          child: Text(
                            strings.selectLeafRegion,
                            style:
                            const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
