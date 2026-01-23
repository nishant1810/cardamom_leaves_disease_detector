import 'package:flutter/material.dart';
import 'camera_screen.dart';
import '../main.dart';
import '../services/classifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ✅ ADD THIS LINE (THIS IS THE FIX)
  final Classifier classifier = Classifier();

  bool _modelLoaded = false;
  bool _loadingError = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await classifier.loadModel();
      setState(() {
        _modelLoaded = true;
      });
    } catch (e) {
      debugPrint('Model load error: $e');
      setState(() {
        _loadingError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardamom Leaf Disease Detection'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: _loadingError
            ? const Text(
          'Failed to load AI model',
          style: TextStyle(color: Colors.red),
        )
            : !_modelLoaded
            ? const CircularProgressIndicator(color: Colors.green)
            : _buildMainUI(context),
      ),
    );
  }

  Widget _buildMainUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.eco, size: 120, color: Colors.green),
        const SizedBox(height: 30),
        const Text(
          'Detect Cardamom Leaf Diseases',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: cameras.isEmpty
              ? null
              : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CameraScreen(
                  cameras: cameras,
                  classifier: classifier, // ✅ pass classifier
                ),
              ),
            );
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Start Detection'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}
