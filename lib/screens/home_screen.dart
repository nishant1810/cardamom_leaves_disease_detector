import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import '../services/model_service.dart';
import '../services/scan_storage.dart';
import '../core/utils/image_quality.dart';
import '../core/models/scan_result.dart';
import '../core/utils/image_validator.dart';
import 'result_screen.dart';
import 'camera_screen.dart';

class HomeScreen extends StatefulWidget {
  final File? imageFile;

  const HomeScreen({
    super.key,
    this.imageFile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();

    // Run prediction ONLY if image exists
    if (widget.imageFile != null) {
      _runPredictionFlow();
    }
  }

  Future<void> _runPredictionFlow() async {
    setState(() {
      _hasError = false;
      _errorMessage = "";
    });

    try {
      final image = widget.imageFile!;

      // 1️⃣ Validate image (file format, size, etc.)
      ImageValidator.validate(image);

      // 2️⃣ Blur check (image quality)
      if (ImageQuality.isBlurred(image)) {
        _showBlurDialog();
        return;
      }

      // 3️⃣ Initialize ML model
      await ModelService.init();

      // 4️⃣ Predict with timeout
      final prediction = await ModelService.classifier
          .predict(image)
          .timeout(const Duration(seconds: 8));

      final String label = prediction['label'] as String;
      final double confidence =
      (prediction['confidence'] as num).toDouble();

      // 5️⃣ ❗ CRITICAL FIX: Reject random / non-cardamom images
      // Threshold intentionally kept high to block tables, cakes, landscapes, drawings
      if (confidence < 0.75) {
        _showInvalidImageDialog();
        return;
      }

      // 6️⃣ Save ONLY valid scans
      await ScanStorage.saveScan(
        ScanResult(
          imagePath: image.path,
          label: label,
          confidence: confidence,
          source: "Camera/Gallery",
          timestamp: DateTime.now(),
          isUncertain: false,
        ),
      );

      if (!mounted) return;

      // 7️⃣ Navigate to result screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            image: image,
            label: label,
            confidence: confidence,
          ),
        ),
      );
    } on TimeoutException {
      _showError("Prediction timed out. Please try again.");
    } catch (e, st) {
      debugPrint("Prediction error: $e");
      debugPrint("$st");
      _showError("Prediction failed. Please try again.");
    }
  }

  // ================= BLUR IMAGE POPUP =================
  void _showBlurDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Image Not Clear"),
        content: const Text(
          "The leaf image appears blurry or unclear.\n\n"
              "Please retake a clear photo or upload another image "
              "for accurate disease detection.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CameraScreen(),
                ),
              );
            },
            child: const Text("Retake Capture"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CameraScreen(),
                ),
              );
            },
            child: const Text("Upload Leaf Image"),
          ),
        ],
      ),
    );
  }

  // ================= INVALID IMAGE POPUP =================
  void _showInvalidImageDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Invalid Image"),
        content: const Text(
          "This image does not appear to be a cardamom leaf.\n\n"
              "Please upload a clear image of a cardamom leaf "
              "for accurate disease detection.",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CameraScreen(),
                ),
              );
            },
            child: const Text("Upload Cardamom Leaf"),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If no image → go to camera screen
    if (widget.imageFile == null) {
      return const CameraScreen();
    }

    return Scaffold(
      body: _hasError
          ? _FallbackUI(
        message: _errorMessage,
        onRetry: _runPredictionFlow,
      )
          : const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text(
              "Analyzing leaf image…",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   ERROR / FALLBACK UI
   ========================= */

class _FallbackUI extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FallbackUI({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const CameraScreen(),
              ),
            );
          },
        ),
        title: const Text(
          "Analysis Failed",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 72,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: onRetry,
                child: const Text(
                  "Retry",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
