import 'dart:io';

class ImageValidator {
  static void validate(File image) {
    // Check file exists
    if (!image.existsSync()) {
      throw Exception("Image file does not exist");
    }

    // Check file size (max 10 MB)
    final sizeMB = image.lengthSync() / (1024 * 1024);
    if (sizeMB > 10) {
      throw Exception("Image size too large (max 10 MB)");
    }

    // Optional: check extension
    final ext = image.path.toLowerCase();
    if (!(ext.endsWith('.jpg') ||
        ext.endsWith('.jpeg') ||
        ext.endsWith('.png'))) {
      throw Exception("Unsupported image format");
    }
  }
}
