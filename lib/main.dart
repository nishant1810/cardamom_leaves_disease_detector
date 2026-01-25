import 'package:flutter/material.dart';
import 'package:cardamom_leaves_disease_detector/core/theme/app_theme.dart';
import 'package:cardamom_leaves_disease_detector/screens/camera_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CardamomDiseaseApp());
}

class CardamomDiseaseApp extends StatelessWidget {
  const CardamomDiseaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardamom Leaf Disease Detector',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const CameraScreen(),
    );
  }
}
