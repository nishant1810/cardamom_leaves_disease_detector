import 'dart:io';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File imageFile;

  const ImagePreviewScreen({
    super.key,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Preview Image",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // 🖼 IMAGE PREVIEW
          Expanded(
            child: Center(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 🔘 ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                //  RETAKE / CANCEL
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Retake"),
                  ),
                ),

                const SizedBox(width: 12),

                //  ANALYZE
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HomeScreen(imageFile: imageFile),
                        ),
                      );
                    },
                    child: const Text(
                      "Analyze",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
