import 'dart:io';
import 'package:flutter/material.dart';

import '../../core/models/scan_result.dart';
import '../../services/scan_storage.dart';
import '../../widgets/confidence_bar.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/app_strings.dart';
import '../../widgets/weather_warning_card.dart';
import '../../widgets/agri_helpline_button.dart';

import '../camera/camera_screen.dart';
import '../camera/full_image_viewer.dart';

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
  static const double reliableThreshold = 0.75;
  static const double uncertainThreshold = 0.60;

  bool _saved = false;

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
    final imageFile = File(widget.result.imagePath);

    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (_, lang, __) {
        final strings = AppStrings.of(lang);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              strings.leafHealthReport,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            backgroundColor: Colors.green.shade700,
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

          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // ================= IMAGE =================
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
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(
                        imageFile,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ================= STATUS =================
                  _StatusCard(
                    isHealthy: isHealthy,
                    isUncertain: isUncertain,
                    disease: widget.result.disease,
                    strings: strings,
                  ),

                  const SizedBox(height: 16),

                  // ================= CONFIDENCE =================
                  ConfidenceBar(
                    confidence: widget.result.confidence,
                    isHealthy: isHealthy,
                  ),

                  const SizedBox(height: 20),

                  // ================= WEATHER WARNING =================
                  if (!isHealthy)
                    const WeatherWarningCard(
                      rainExpected: false,
                      highWind: false,
                      highHumidity: false,
                    ),

                  if (!isHealthy)
                    const SizedBox(height: 14),

                  // ================= ACTION STEPS =================
                  if (!isHealthy)
                    _ActionSection(
                      disease: widget.result.disease,
                      isUncertain: isUncertain,
                    ),

                  if (isHealthy)
                    const _HealthyCareSection(),

                  const SizedBox(height: 20),

                  // ================= HELPLINE =================
                  const AgriHelplineButton(
                    phoneNumber: "18001801551", // Indian Kisan Helpline
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////
/// STATUS CARD
////////////////////////////////////////////////////////////////
class _StatusCard extends StatelessWidget {
  final bool isHealthy;
  final bool isUncertain;
  final String disease;
  final AppStrings strings;

  const _StatusCard({
    required this.isHealthy,
    required this.isUncertain,
    required this.disease,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final color = isUncertain
        ? Colors.orange
        : isHealthy
        ? Colors.green
        : Colors.red;

    final icon = isUncertain
        ? Icons.help_outline
        : isHealthy
        ? Icons.check_circle
        : Icons.warning_amber_rounded;

    final text = isUncertain
        ? strings.uncertainMessage
        : isHealthy
        ? strings.healthyLeaf
        : strings.diseaseDetected(disease);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// ACTION SECTION
////////////////////////////////////////////////////////////////
class _ActionSection extends StatelessWidget {
  final String disease;
  final bool isUncertain;

  const _ActionSection({
    required this.disease,
    required this.isUncertain,
  });

  @override
  Widget build(BuildContext context) {
    if (isUncertain) {
      return _InfoCard(
        title: "What to do next",
        icon: Icons.info,
        color: Colors.orange,
        points: const [
          "Take photo in good sunlight",
          "Capture only one leaf",
          "Avoid wet or dusty leaves",
          "Re-scan after some time",
        ],
      );
    }

    return Column(
      children: const [
        _InfoCard(
          title: "🌱 Organic Control",
          icon: Icons.eco,
          color: Colors.green,
          points: [
            "Remove infected leaves immediately",
            "Spray neem oil (3–5 ml per litre)",
            "Use Trichoderma bio-fungicide",
            "Maintain good air circulation",
          ],
        ),
        SizedBox(height: 12),
        _InfoCard(
          title: "🧪 Chemical Control",
          icon: Icons.science,
          color: Colors.red,
          points: [
            "Spray Copper Oxychloride (2.5 g/L)",
            "Use Mancozeb or Carbendazim",
            "Spray early morning or evening",
            "Follow recommended dosage only",
          ],
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////
/// HEALTHY CARE
////////////////////////////////////////////////////////////////
class _HealthyCareSection extends StatelessWidget {
  const _HealthyCareSection();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      title: "🌿 Crop Care Tips",
      icon: Icons.check_circle,
      color: Colors.green,
      points: [
        "Continue regular field monitoring",
        "Maintain proper irrigation",
        "Remove old or damaged leaves",
        "Apply balanced nutrients",
      ],
    );
  }
}

////////////////////////////////////////////////////////////////
/// INFO CARD
////////////////////////////////////////////////////////////////
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> points;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...points.map(
                (p) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                "• $p",
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
