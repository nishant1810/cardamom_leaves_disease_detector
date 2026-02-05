import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_language.dart';
import '../core/constants/app_strings.dart';
import 'history_screen.dart';
import 'image_preview_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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

  // ================= LANGUAGE SELECTOR =================
  void _showLanguageSelector(BuildContext context, AppStrings strings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                strings.selectLanguage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _LanguageOption(
                title: "English",
                selected: appLanguage.value == AppLanguage.en,
                onTap: () {
                  appLanguage.value = AppLanguage.en;
                  Navigator.pop(sheetContext);
                },
              ),
              _LanguageOption(
                title: "മലയാളം",
                selected: appLanguage.value == AppLanguage.ml,
                onTap: () {
                  appLanguage.value = AppLanguage.ml;
                  Navigator.pop(sheetContext);
                },
              ),
              _LanguageOption(
                title: "தமிழ்",
                selected: appLanguage.value == AppLanguage.ta,
                onTap: () {
                  appLanguage.value = AppLanguage.ta;
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (_, lang, __) {
        final strings = AppStrings.of(lang);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.green.shade800,
            centerTitle: true,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            title: Text(
              strings.appName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),

            actions: [
              IconButton(
                icon: const Icon(Icons.language),
                tooltip: strings.changeLanguage,
                onPressed: () =>
                    _showLanguageSelector(context, strings),
              ),
              IconButton(
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

          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bg_image.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 26,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      Text(
                        strings.heroTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ===== DETECTABLE CLASSES =====
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.green.shade900
                              .withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.detectableTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("• ${strings.blight}",
                                style: _diseaseStyle),
                            Text("• ${strings.phyllosticta}",
                                style: _diseaseStyle),
                            Text("• ${strings.healthyLeaf}",
                                style: _diseaseStyle),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ===== GUIDELINES =====
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black.withValues(alpha: 0.35),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.guidelinesTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),

                            _GuidelineTile(
                              icon: Icons.wb_sunny,
                              text: strings.guidelineNaturalLight,
                            ),
                            _GuidelineTile(
                              icon: Icons.center_focus_strong,
                              text: strings.guidelineFocus,
                            ),
                            _GuidelineTile(
                              icon: Icons.block,
                              text: strings.guidelineAvoidBlur,
                            ),
                            _GuidelineTile(
                              icon: Icons.eco,
                              text: strings.guidelineSingleLeaf,
                            ),
                            _GuidelineTile(
                              icon: Icons.straighten,
                              text: strings.guidelineDistance,
                            ),
                            _GuidelineTile(
                              icon: Icons.water_drop_outlined,
                              text: strings.guidelineDryLeaf,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade900,
                          foregroundColor: Colors.white,
                          minimumSize:
                          const Size(double.infinity, 56),
                        ),
                        icon: const Icon(Icons.camera_alt),
                        label: Text(strings.startDetection),
                        onPressed: () =>
                            _pickImage(ImageSource.camera),
                      ),

                      const SizedBox(height: 14),

                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side:
                          const BorderSide(color: Colors.white),
                          minimumSize:
                          const Size(double.infinity, 48),
                        ),
                        icon:
                        const Icon(Icons.photo_library),
                        label:
                        Text(strings.uploadFromGallery),
                        onPressed: () =>
                            _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================= STYLES =================
const _diseaseStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.w800,
);

// ================= GUIDELINE TILE =================
class _GuidelineTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _GuidelineTile({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= LANGUAGE OPTION TILE =================
class _LanguageOption extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        selected ? Icons.check_circle : Icons.language,
        color: selected ? Colors.green : Colors.grey,
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
