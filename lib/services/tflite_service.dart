import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  static Interpreter? _interpreter;
  static bool _loaded = false;

  /// Load TFLite model
  static Future<void> loadModel() async {
    if (_loaded) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/models/mobilenet_model.tflite', // ✅ FIXED PATH
      options: InterpreterOptions()..threads = 4,
    );

    _loaded = true;
  }

  /// Classify image
  static Future<Map<String, dynamic>> classify(File imageFile) async {
    await loadModel();

    // Decode image
    final Uint8List bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Unable to decode image");
    }

    // Resize image to 224x224
    image = img.copyResize(image, width: 224, height: 224);

    // Input tensor [1, 224, 224, 3]
    final input = List.generate(
      1,
          (_) => List.generate(
        224,
            (y) => List.generate(
          224,
              (x) {
            final pixel = image!.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    // Output tensor [1, 3]
    final output = List.generate(
      1,
          (_) => List.filled(3, 0.0),
    );

    _interpreter!.run(input, output);

    final probs = output[0];

    final maxIdx =
    probs.indexOf(probs.reduce((a, b) => a > b ? a : b));

    final labels = [
      "Blight",
      "Healthy",
      "Phyllosticta",
    ];

    return {
      'label': labels[maxIdx],
      'disease': labels[maxIdx],
      'confidence': probs[maxIdx],
    };
  }
}
