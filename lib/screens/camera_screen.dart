import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'history_screen.dart';
import 'image_preview_screen.dart';

enum AppLanguage { en, hi }

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  AppLanguage _currentLang = AppLanguage.en;
  final ImagePicker _picker = ImagePicker();

  // ================= IMAGE PICK =================
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ImagePreviewScreen(imageFile: File(pickedFile.path)),
        ),
      );
    }
  }

  // ================= BOTTOM SHEET =================
  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(
                _currentLang == AppLanguage.en
                    ? "Capture Leaf Image"
                    : "पत्ते की फोटो लें",
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(
                _currentLang == AppLanguage.en
                    ? "Upload from Gallery"
                    : "गैलरी से अपलोड करें",
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ================= TEXT =================
  String get appBarTitle =>
      _currentLang == AppLanguage.en
          ? "Cardamom Leaf Disease Detection"
          : "इलायची पत्ता रोग पहचान";

  String get mainTitle =>
      _currentLang == AppLanguage.en
          ? "Start Leaf Disease Detection"
          : "पत्ता रोग पहचान शुरू करें";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 2,
        centerTitle: true,

        // ===== TITLE =====
        title: Text(
          appBarTitle,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),

        actions: [
          // 🌐 LANGUAGE SWITCH
          IconButton(
            tooltip: _currentLang == AppLanguage.en
                ? "Switch to Hindi"
                : "अंग्रेज़ी में बदलें",
            icon: const Icon(Icons.language),
            onPressed: () {
              setState(() {
                _currentLang = _currentLang == AppLanguage.en
                    ? AppLanguage.hi
                    : AppLanguage.en;
              });
            },
          ),

          // 🕘 HISTORY
          IconButton(
            tooltip: _currentLang == AppLanguage.en
                ? "Detection History"
                : "पहचान इतिहास",
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Text(
                "The New Era of",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.brown.shade600,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFDFF2DF),
                    ),
                    child: const Icon(
                      Icons.eco,
                      size: 20,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "AGRICULTURE",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Text(
                "AI-powered sustainable farming\nfor a better tomorrow",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green.shade200,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 26),

              // ===== IMAGE =====
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/cardamom_leaf.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                mainTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ===== PRIMARY ACTION BUTTONS =====
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.camera_alt),
                label: Text(
                  _currentLang == AppLanguage.en
                      ? "Capture Leaf Image"
                      : "पत्ते की फोटो लें",
                ),
                onPressed: () => _pickImage(ImageSource.camera),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.photo_library),
                label: Text(
                  _currentLang == AppLanguage.en
                      ? "Upload from Gallery"
                      : "गैलरी से अपलोड करें",
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),

              const SizedBox(height: 20),

              Text(
                "Accurate • Fast • AI-Based Detection",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        tooltip: "More options",
        onPressed: _showPickOptions,
        child: const Icon(Icons.add),
      ),
    );
  }
}
