import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../services/classifier.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Classifier classifier; // ✅ receive classifier

  const CameraScreen({
    Key? key,
    required this.cameras,
    required this.classifier,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    // ❌ NO model loading here
  }

  @override
  void dispose() {
    _controller.dispose();
    // ❌ DO NOT dispose classifier here (HomeScreen owns it)
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      await _processImage(File(image.path));
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final XFile? image =
      await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        await _processImage(File(image.path));
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      final result = await widget.classifier.predict(imageFile);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imageFile: imageFile,
            result: result,
          ),
        ),
      );
    } catch (e) {
      _showError('Model error: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Capture Leaf'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned.fill(child: CameraPreview(_controller)),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 20),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'gallery',
            onPressed: _isProcessing ? null : _pickFromGallery,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.photo_library),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.large(
            heroTag: 'camera',
            onPressed: _isProcessing ? null : _takePicture,
            backgroundColor: Colors.green,
            child: const Icon(Icons.camera, size: 40),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
