import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/confidence_bar.dart';
import 'package:cardamom_leaves_disease_detector/core/constants/strings.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final File image;
  final String label;
  final double confidence;
  final List<Map<String, dynamic>>? top2;
  final File? gradCamImage;

  const ResultScreen({
    super.key,
    required this.image,
    required this.label,
    required this.confidence,
    this.top2,
    this.gradCamImage,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  bool get isHealthy =>
      widget.label.toLowerCase().contains('healthy');

  String get diseaseClass => isHealthy ? "" : widget.label.trim();

  String get severity {
    if (isHealthy) return "";
    if (widget.confidence < 0.70) return "Mild";
    if (widget.confidence < 0.85) return "Moderate";
    return "Severe";
  }

  Color get severityColor {
    switch (severity) {
      case "Mild":
        return Colors.orange;
      case "Moderate":
        return Colors.deepOrange;
      case "Severe":
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.95,
      upperBound: 1.08,
    );

    if (!isHealthy) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get statusText {
    if (isHealthy) {
      if (widget.confidence >= 0.8) return "Healthy";
      if (widget.confidence >= 0.6) return "Likely Healthy";
      return "Uncertain Result";
    }
    return "Disease Detected ($diseaseClass)";
  }

  String get statusSubText {
    if (isHealthy) {
      if (widget.confidence >= 0.8) {
        return "No visible disease signs detected";
      }
      return "Low model certainty — consider re-scanning";
    }
    return "Severity: $severity";
  }

  Color get statusColor {
    if (isHealthy && widget.confidence >= 0.8) return Colors.green;
    if (isHealthy) return Colors.orange;
    return severityColor;
  }

  List<String> get treatmentSuggestions {
    if (isHealthy) return [];

    if (severity == "Mild") {
      return [
        "Remove affected leaves manually",
        "Monitor plant weekly for spread",
        "Avoid excess irrigation",
      ];
    }

    if (severity == "Moderate") {
      return [
        "Prune infected plant parts",
        "Apply recommended fungicide",
        "Improve airflow and drainage",
      ];
    }

    return [
      "Remove heavily infected leaves",
      "Apply systemic fungicide",
      "Consult local agriculture officer",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.current == AppLanguage.en
              ? "Leaf Health Report"
              : "पत्तियों का स्वास्थ्य रिपोर्ट",
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Re-analyze image",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(
                  widget.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      isHealthy
                          ? Icons.check_circle
                          : Icons.warning_amber_rounded,
                      color: statusColor,
                      size: 34,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Prediction Result",
                              style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            statusSubText,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ConfidenceBar(
                  confidence: widget.confidence,
                  isHealthy: isHealthy,
                ),
              ),

              if (!isHealthy)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: severityColor),
                    color: severityColor.withOpacity(0.08),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recommended Actions ($severity)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: severityColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...treatmentSuggestions.map(
                            (tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text("• $tip"),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Retake / Re-scan Leaf",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
