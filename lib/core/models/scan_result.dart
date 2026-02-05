class ScanResult {
  final String imagePath;
  final String label;
  final String disease;
  final double confidence;
  final String source;
  final DateTime timestamp;
  final bool isUncertain;

  const ScanResult({
    required this.imagePath,
    required this.label,
    required this.disease,
    required this.confidence,
    required this.source,
    required this.timestamp,
    required this.isUncertain,
  });

  // ================= SERIALIZATION =================
  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'label': label,
    'disease': disease,
    'confidence': confidence,
    'source': source,
    'timestamp': timestamp.toIso8601String(),
    'isUncertain': isUncertain,
  };

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      imagePath: json['imagePath'] as String? ?? '',
      label: json['label'] as String? ?? '',
      disease: json['disease'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      isUncertain: json['isUncertain'] as bool? ?? false,
    );
  }

  // ================= COPY =================
  ScanResult copyWith({
    String? imagePath,
    String? label,
    String? disease,
    double? confidence,
    String? source,
    DateTime? timestamp,
    bool? isUncertain,
  }) {
    return ScanResult(
      imagePath: imagePath ?? this.imagePath,
      label: label ?? this.label,
      disease: disease ?? this.disease,
      confidence: confidence ?? this.confidence,
      source: source ?? this.source,
      timestamp: timestamp ?? this.timestamp,
      isUncertain: isUncertain ?? this.isUncertain,
    );
  }

  // ================= EQUALITY =================
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanResult &&
        other.imagePath == imagePath &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => imagePath.hashCode ^ timestamp.hashCode;
}
