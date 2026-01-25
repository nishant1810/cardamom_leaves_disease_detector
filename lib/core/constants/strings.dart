enum AppLanguage { en, hi }

class AppStrings {
  static AppLanguage current = AppLanguage.en;

  static String title() =>
      current == AppLanguage.en
          ? "Cardamom Disease Detector"
          : "इलायची रोग पहचान";

  static String selectImage() =>
      current == AppLanguage.en
          ? "Select Leaf Image"
          : "पत्ता चुनें";

  static String healthy() =>
      current == AppLanguage.en
          ? "Healthy Leaf"
          : "स्वस्थ पत्ता";

  static String diseased() =>
      current == AppLanguage.en
          ? "Diseased Leaf"
          : "बीमार पत्ता";
}
