import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/home_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request camera permission (Android 13+ safe)
  final status = await Permission.camera.request();
  if (!status.isGranted) {
    debugPrint('Camera permission denied');
  }

  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Camera error: $e');
  }

  runApp(const CardamomDiseaseApp());
}

class CardamomDiseaseApp extends StatelessWidget {
  const CardamomDiseaseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardamom Disease Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
