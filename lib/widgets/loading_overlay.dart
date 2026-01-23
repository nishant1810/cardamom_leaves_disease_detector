import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final String text;
  const LoadingOverlay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
