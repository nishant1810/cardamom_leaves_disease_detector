import 'dart:io';
import 'package:flutter/material.dart';

import '../core/models/scan_result.dart';
import '../services/scan_storage.dart';
import '../widgets/confidence_bar.dart';
import '../core/app_language.dart';
import '../core/constants/app_strings.dart';

import 'camera_screen.dart';
import 'full_image_viewer.dart';

class ResultScreen extends StatefulWidget {
  final ScanResult result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  // ===== CONFIDENCE THRESHOLDS =====
  static const double reliableThreshold = 0.75;
  static const double uncertainThreshold = 0.60;

  bool get isUncertain =>
      widget.result.confidence < uncertainThreshold;

  bool get isReliable =>
      widget.result.confidence >= reliableThreshold;

  bool get isHealthy =>
      isReliable &&
          widget.result.disease.toLowerCase().contains('healthy');

  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    if (_saved) return;
    await ScanStorage.saveScan(widget.result);
    _saved = true;
  }

  @override
  Widget build(BuildContext context) {
    final File imageFile = File(widget.result.imagePath);

    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (_, lang, __) {
        final strings = AppStrings.of(lang);
        final Color statusColor = isUncertain
            ? Colors.orange
            : isHealthy
            ? Colors.green
            : Colors.red;

        final String diseaseLabel = isUncertain
            ? strings.uncertain
            : isHealthy
            ? strings.healthyLeaf
            : widget.result.disease;

        final List<String> recommendations =
        strings.recommendations(widget.result.disease, isUncertain);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green.shade700,
            title: Text(
              strings.leafHealthReport,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CameraScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ===== IMAGE =====
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FullImageViewer(imagePath: imageFile.path),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      imageFile,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===== STATUS CARD =====
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isUncertain
                            ? Icons.help_outline
                            : isHealthy
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        color: statusColor,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isUncertain
                              ? strings.uncertainMessage
                              : isHealthy
                              ? strings.healthyLeaf
                              : strings.diseaseDetected(diseaseLabel),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ===== CONFIDENCE BAR =====
                ConfidenceBar(
                  confidence: widget.result.confidence,
                  isHealthy: isHealthy,
                ),

                // ===== RECOMMENDATIONS =====
                if (recommendations.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: statusColor),
                      color: statusColor.withOpacity(0.08),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHealthy
                              ? strings.careTips
                              : isUncertain
                              ? strings.suggestions
                              : strings.recommendedActions,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...recommendations.map(
                              (tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text("• $tip"),
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
