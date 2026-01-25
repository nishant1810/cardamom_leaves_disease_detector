import 'dart:io';
import 'package:image/image.dart' as img;

/// Utility to check image sharpness / blur
/// Uses variance of luminance as a blur metric
class ImageQuality {
  /// Returns true if image is considered blurred
  static bool isBlurred(File file) {
    final bytes = file.readAsBytesSync();
    final image = img.decodeImage(bytes);

    if (image == null) return true;

    double sum = 0;
    double sumSq = 0;
    int count = 0;

    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        final pixel = image.getPixel(x, y);
        final luminance = img.getLuminance(pixel);

        sum += luminance;
        sumSq += luminance * luminance;
        count++;
      }
    }

    final mean = sum / count;
    final variance = (sumSq / count) - (mean * mean);

    //  Threshold tuned for mobile leaf images
    return variance < 120;
  }
}
