import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/app_language.dart';
import 'features/camera/camera_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔤 Detect device language once
  detectDeviceLanguage();

  runApp(const CardoDisDetectApp());
}

class CardoDisDetectApp extends StatelessWidget {
  const CardoDisDetectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (context, lang, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CardoDisDetect',

          // 🌍 Locale from global language state
          locale: Locale(_localeCode(lang)),

          supportedLocales: const [
            Locale('en'),
            Locale('ml'),
            Locale('ta'),
            Locale('hi'),
          ],

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: const CameraScreen(),
        );
      },
    );
  }

  /// Convert AppLanguage → locale code
  String _localeCode(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.ml:
        return 'ml';
      case AppLanguage.ta:
        return 'ta';
      case AppLanguage.en:
      default:
        return 'en';
    }
  }
}
