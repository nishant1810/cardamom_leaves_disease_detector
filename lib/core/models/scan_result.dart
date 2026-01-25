class ScanResult {
  final String imagePath;
  final String label;
  final double confidence;
  final String source;
  final DateTime timestamp;
  final bool isUncertain;

  ScanResult({
    required this.imagePath,
    required this.label,
    required this.confidence,
    required this.source,
    required this.timestamp,
    required this.isUncertain,
  });

  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'label': label,
    'confidence': confidence,
    'source': source,
    'timestamp': timestamp.toIso8601String(),
    'isUncertain': isUncertain,
  };

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      imagePath: json['imagePath'] as String,
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      source: json['source'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUncertain: json['isUncertain'] as bool? ?? false,
    );
  }
}
