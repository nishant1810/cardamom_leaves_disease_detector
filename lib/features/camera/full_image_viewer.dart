import 'dart:io';
import 'package:flutter/material.dart';

class FullImageViewer extends StatelessWidget {
  final String imagePath;

  const FullImageViewer({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Image Preview",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Center(
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 5.0,
          panEnabled: true,
          child: Image.file(
            File(imagePath),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
