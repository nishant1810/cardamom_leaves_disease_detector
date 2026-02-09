import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/localization/app_language.dart';
import '../../core/localization/app_strings.dart';
import '../history/history_screen.dart';
import 'image_preview_screen.dart';
import '../../widgets/guideline_tile.dart';
import '../../widgets/language_option_tile.dart';

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
      useSafeArea: true,
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

              LanguageOptionTile(
                title: "English",
                selected: appLanguage.value == AppLanguage.en,
                onTap: () {
                  appLanguage.value = AppLanguage.en;
                  Navigator.pop(sheetContext);
                },
              ),
              LanguageOptionTile(
                title: "മലയാളം",
                selected: appLanguage.value == AppLanguage.ml,
                onTap: () {
                  appLanguage.value = AppLanguage.ml;
                  Navigator.pop(sheetContext);
                },
              ),
              LanguageOptionTile(
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
                backgroundColor: Colors.white.withOpacity(0.15),
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
                child: Container(color: Colors.black.withOpacity(0.55)),
              ),

              SafeArea(
                bottom: true,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 26, 24, 16),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
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

                                _buildDetectableCard(strings),

                                const SizedBox(height: 22),

                                _buildGuidelines(strings),

                                const Spacer(),

                                ElevatedButton.icon(
                                  icon: const Icon(Icons.camera_alt),
                                  label: Text(strings.startDetection),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Colors.green.shade900,
                                    foregroundColor: Colors.white,
                                    minimumSize:
                                    const Size(double.infinity, 56),
                                  ),
                                  onPressed: () =>
                                      _pickImage(ImageSource.camera),
                                ),

                                const SizedBox(height: 14),

                                OutlinedButton.icon(
                                  icon:
                                  const Icon(Icons.photo_library),
                                  label:
                                  Text(strings.uploadFromGallery),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                        color: Colors.white),
                                    minimumSize:
                                    const Size(double.infinity, 48),
                                  ),
                                  onPressed: () =>
                                      _pickImage(ImageSource.gallery),
                                ),

                                //  SAFE SPACE FOR NAVIGATION GESTURES
                                SizedBox(
                                  height: MediaQuery.of(context)
                                      .padding
                                      .bottom +
                                      8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= UI SECTIONS =================
  Widget _buildDetectableCard(AppStrings strings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade900.withOpacity(0.10),
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
          Text("• ${strings.blight}", style: _diseaseStyle),
          Text("• ${strings.phyllosticta}", style: _diseaseStyle),
          Text("• ${strings.healthyLeaf}", style: _diseaseStyle),
        ],
      ),
    );
  }

  Widget _buildGuidelines(AppStrings strings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.35),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
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
          GuidelineTile(icon: Icons.wb_sunny, text: strings.guidelineNaturalLight),
          GuidelineTile(icon: Icons.center_focus_strong, text: strings.guidelineFocus),
          GuidelineTile(icon: Icons.block, text: strings.guidelineAvoidBlur),
          GuidelineTile(icon: Icons.eco, text: strings.guidelineSingleLeaf),
          GuidelineTile(icon: Icons.straighten, text: strings.guidelineDistance),
          GuidelineTile(icon: Icons.water_drop_outlined, text: strings.guidelineDryLeaf),
        ],
      ),
    );
  }
}

// ================= STYLES =================
const _diseaseStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.w800,
);
