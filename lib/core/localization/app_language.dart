import 'package:flutter/foundation.dart';

enum AppLanguage { en, ml, ta, hi }

final ValueNotifier<AppLanguage> appLanguage =
ValueNotifier<AppLanguage>(AppLanguage.en);

void detectDeviceLanguage() {
  final locale = PlatformDispatcher.instance.locale.languageCode;

  if (locale.startsWith('ml')) {
    appLanguage.value = AppLanguage.ml;
  } else if (locale.startsWith('ta')) {
    appLanguage.value = AppLanguage.ta;
  } else if (locale.startsWith('hi')) {
    appLanguage.value = AppLanguage.hi;
  } else {
    appLanguage.value = AppLanguage.en;
  }
}
