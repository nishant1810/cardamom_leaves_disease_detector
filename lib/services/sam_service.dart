import 'dart:io';
import '../core/models/sam_prompt.dart';

class SamService {

  /// Auto segmentation
  static Future<File> segmentAuto(File image) async {
    // Backend call placeholder
    return image;
  }

  /// Point-based segmentation
  static Future<File> segmentWithPoint(
      File image,
      SamPoint point,
      ) async {
    // Send image + (x, y) to SAM backend
    return image;
  }

  /// Box-based segmentation
  static Future<File> segmentWithBox(
      File image,
      SamBox box,
      ) async {
    // Send image + (x1, y1, x2, y2)
    return image;
  }
}
