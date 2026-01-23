import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class Classifier {
  static const int inputSize = 224;
  static const String modelPath =
      'assets/models/cardamom_disease_model.tflite';
  static const String labelsPath = 'assets/labels.txt';

  Interpreter? _interpreter;
  late List<String> _labels;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(modelPath);
    _labels = await _loadLabels();

    debugPrint('Model loaded');
    debugPrint(
        'Input shape: ${_interpreter!.getInputTensor(0).shape}');
    debugPrint(
        'Output shape: ${_interpreter!.getOutputTensor(0).shape}');
    debugPrint('LABELS LOADED: $_labels');
    debugPrint('LABEL COUNT: ${_labels.length}');
  }

  Future<List<String>> _loadLabels() async {
    final raw = await rootBundle.loadString(labelsPath);

    return raw
        .replaceAll('\r', '')          // remove Windows CR
        .replaceAll('\uFEFF', '')      // remove BOM if present
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> predict(File imageFile) async {
    if (_interpreter == null) {
      throw Exception('Interpreter not initialized');
    }

    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Invalid image');
    }

    final resized =
    img.copyResize(image, width: inputSize, height: inputSize);

    // 1️⃣ Input preprocessing
    final input = _imageToFloat32(resized);
    final input4D = input.reshape([1, inputSize, inputSize, 3]);

    // 2️⃣ Output buffer from model shape (CRITICAL FIX)
    final outputTensor = _interpreter!.getOutputTensor(0);
    final outputShape = outputTensor.shape;
    final outputSize = outputShape.reduce((a, b) => a * b);

    final output =
    List.filled(outputSize, 0.0).reshape(outputShape);

    // 3️⃣ Run inference
    _interpreter!.run(input4D, output);

    final scores = List<double>.from(output[0]);

    // 4️⃣ Safety check
    if (scores.length != _labels.length) {
      throw Exception(
        'Model outputs ${scores.length} values but labels.txt has ${_labels.length}',
      );
    }

    // 5️⃣ Softmax + best label
    final probs = _softmax(scores);

    int bestIdx = 0;
    double bestScore = probs[0];
    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > bestScore) {
        bestScore = probs[i];
        bestIdx = i;
      }
    }

    return {
      'label': _labels[bestIdx],
      'confidence': bestScore,
      'all_results': Map.fromIterables(_labels, probs),
    };
  }

  /// ✅ RETURNS FLAT Float32List (NO reshape here)
  Float32List _imageToFloat32(img.Image image) {
    final buffer = Float32List(inputSize * inputSize * 3);
    int index = 0;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final p = image.getPixel(x, y);
        buffer[index++] = p.r / 255.0;
        buffer[index++] = p.g / 255.0;
        buffer[index++] = p.b / 255.0;
      }
    }
    return buffer;
  }

  List<double> _softmax(List<double> x) {
    final maxVal = x.reduce(math.max);
    final exp = x.map((e) => math.exp(e - maxVal)).toList();
    final sum = exp.reduce((a, b) => a + b);
    return exp.map((e) => e / sum).toList();
  }

  void dispose() {
    _interpreter?.close();
  }
}
