import 'package:flutter/material.dart';

class ConfidenceBar extends StatelessWidget {
  final double confidence;
  final bool isHealthy;

  static const double _uncertainThreshold = 0.70;

  const ConfidenceBar({
    super.key,
    required this.confidence,
    required this.isHealthy,
  });

  Color _getColor() {
    if (confidence < _uncertainThreshold) {
      return Colors.orange;
    }
    return isHealthy ? Colors.green : Colors.red;
  }

  String _getConfidenceLabel() {
    if (confidence < _uncertainThreshold) return "Low confidence";
    if (confidence < 0.85) return "Medium confidence";
    return "High confidence";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Prediction Confidence",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: confidence,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
              color: _getColor(),
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${(confidence * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _getConfidenceLabel(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _getColor(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
