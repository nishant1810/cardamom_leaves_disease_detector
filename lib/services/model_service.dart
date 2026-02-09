import 'dart:io';
import 'package:image/image.dart' as img;

import '../core/models/scan_result.dart';
import '../core/utils/image_quality.dart';
import '../core/utils/image_validator.dart';
import '../core/utils/image_resize.dart';
import '../core/utils/leaf_validator.dart';
import 'ml/tflite_service.dart';

class ModelService {
  /// ================= FULL PIPELINE =================
  ///
  /// Image →
  /// Validation →
  /// Quality →
  /// Leaf Heuristic →
  /// Resize →
  /// MobileNet →
  /// Decision →
  /// ScanResult
  static Future<ScanResult> runPipeline(File imageFile) async {
    // ================= 1️⃣ BASIC FILE VALIDATION =================
    final bool isValid = await ImageValidator.isValidImage(imageFile);
    if (!isValid) {
      throw Exception(
        "Invalid image. Please upload a clear cardamom leaf image.",
      );
    }

    // ================= 2️⃣ BLUR CHECK =================
    if (ImageQuality.isBlurred(imageFile)) {
      throw Exception(
        "Image is blurry. Please capture a clearer image.",
      );
    }

    // ================= 3️⃣ LEAF HEURISTIC CHECK =================
    final decoded = img.decodeImage(await imageFile.readAsBytes());
    if (decoded == null || !LeafValidator.isLikelyLeaf(decoded)) {
      throw Exception(
        "This is not a cardamom leaf.\nPlease upload a cardamom leaf image.",
      );
    }

    // ================= 4️⃣ RESIZE TO 224×224 =================
    // ⚠️ Model trained on full images (NO SAM)
    final File resizedImage = await ImageResize.to224(imageFile);

    // ================= 5️⃣ TFLITE CLASSIFICATION =================
    final Map<String, dynamic> prediction =
    await TFLiteService.classify(resizedImage);

    final String label = prediction['label'] as String;
    final String disease = prediction['disease'] as String;
    final double confidence =
    (prediction['confidence'] as num).toDouble();

    // ================= 6️⃣ NON-CARDAMOM REJECTION =================
    // Model confused → reject
    if (confidence < 0.35) {
      throw Exception(
        "This image does not match cardamom leaf patterns.\nPlease re-capture the leaf clearly.",
      );
    }

    // ================= 7️⃣ UNCERTAINTY FLAG =================
    // Healthy leaves can have lower confidence
    final bool isUncertain = confidence < 0.60;

    // ================= 8️⃣ BUILD RESULT =================
    return ScanResult(
      imagePath: imageFile.path,
      label: label,
      disease: disease,
      confidence: confidence,
      source: "Camera/Gallery",
      timestamp: DateTime.now(),
      isUncertain: isUncertain,
    );
  }
}
