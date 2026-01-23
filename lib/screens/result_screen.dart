import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final File imageFile;
  final Map<String, dynamic> result;

  const ResultScreen({
    Key? key,
    required this.imageFile,
    required this.result,
  }) : super(key: key);

  Color _getColorForConfidence(double confidence) {
    if (confidence > 0.8) return Colors.green;
    if (confidence > 0.6) return Colors.orange;
    return Colors.red;
  }

  IconData _getIconForLabel(String label) {
    if (label.toLowerCase().contains('healthy')) {
      return Icons.check_circle;
    }
    return Icons.warning;
  }

  @override
  Widget build(BuildContext context) {
    final label = result['label'] as String;
    final confidence = result['confidence'] as double;
    final allResults = result['all_results'] as Map<String, double>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Result'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'captured_image',
              child: Image.file(
                imageFile,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: _getColorForConfidence(confidence).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _getColorForConfidence(confidence),
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getIconForLabel(label),
                    size: 60,
                    color: _getColorForConfidence(confidence),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _getColorForConfidence(confidence),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: confidence,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColorForConfidence(confidence),
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.analytics, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'All Predictions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ...allResults.entries.map((entry) {
              final isTopPrediction = entry.key == label;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: isTopPrediction
                      ? _getColorForConfidence(entry.value).withOpacity(0.1)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isTopPrediction
                        ? _getColorForConfidence(entry.value)
                        : Colors.grey[300]!,
                    width: isTopPrediction ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getColorForConfidence(entry.value),
                    foregroundColor: Colors.white,
                    child: Text(
                      '${(entry.value * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    entry.key,
                    style: TextStyle(
                      fontWeight: isTopPrediction
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      value: entry.value,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getColorForConfidence(entry.value),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Scan Again'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}