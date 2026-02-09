import 'app_language.dart';

class AppStrings {
  final AppLanguage lang;
  AppStrings(this.lang);

  static AppStrings of(AppLanguage lang) => AppStrings(lang);

  // ======================================================
  // APP
  // ======================================================
  String get appName => _t(
    en: "CardoDisDetect",
    ml: "കാർഡോഡിസ്‌ഡിറ്റക്ട്",
    ta: "ஏலக்காய் நோய் கண்டறிதல்",
    hi: "इलायची रोग पहचान",
  );

  String get selectLanguage => _t(
    en: "Select Language",
    ml: "ഭാഷ തിരഞ്ഞെടുക്കുക",
    ta: "மொழியைத் தேர்ந்தெடுக்கவும்",
    hi: "भाषा चुनें",
  );

  String get changeLanguage => _t(
    en: "Change Language",
    ml: "ഭാഷ മാറ്റുക",
    ta: "மொழி மாற்று",
    hi: "भाषा बदलें",
  );

  // ======================================================
  // HOME / CAMERA
  // ======================================================
  String get heroTitle => _t(
    en: "Detect Cardamom Leaf Disease Instantly",
    ml: "ഏലക്ക ഇലയുടെ രോഗം ഉടൻ കണ്ടെത്തുക",
    ta: "ஏலக்காய் இலை நோயை உடனே கண்டறியுங்கள்",
    hi: "इलायची पत्ती रोग तुरंत पहचानें",
  );

  String get detectableTitle => _t(
    en: "Detectable Leaf Conditions",
    ml: "കണ്ടെത്താവുന്ന ഇല രോഗങ്ങൾ",
    ta: "கண்டறியப்படும் இலை நிலைகள்",
    hi: "पहचाने जाने वाले रोग",
  );

  String get guidelinesTitle => _t(
    en: "Quick Capture Tips",
    ml: "ശരിയായ ചിത്രത്തിനുള്ള നിർദ്ദേശങ്ങൾ",
    ta: "சரியான புகைப்பட வழிகாட்டி",
    hi: "सही फोटो लेने के सुझाव",
  );

  String get guidelineNaturalLight => _t(
    en: "Use natural light",
    ml: "സ്വാഭാവിക വെളിച്ചം ഉപയോഗിക്കുക",
    ta: "இயற்கை வெளிச்சம் பயன்படுத்தவும்",
    hi: "प्राकृतिक रोशनी का उपयोग करें",
  );

  String get guidelineFocus => _t(
    en: "Keep leaf clearly focused",
    ml: "ഇല വ്യക്തമായി ഫോക്കസ് ചെയ്യുക",
    ta: "இலை தெளிவாக இருக்க வேண்டும்",
    hi: "पत्ती को साफ फोकस करें",
  );

  String get guidelineAvoidBlur => _t(
    en: "Avoid blurry or dark images",
    ml: "മങ്ങിയ ചിത്രങ്ങൾ ഒഴിവാക്കുക",
    ta: "மங்கலான படங்களை தவிர்க்கவும்",
    hi: "धुंधली फोटो से बचें",
  );

  String get guidelineSingleLeaf => _t(
    en: "Capture only one leaf",
    ml: "ഒരു ഇല മാത്രം എടുക്കുക",
    ta: "ஒரு இலை மட்டுமே",
    hi: "सिर्फ एक पत्ती लें",
  );

  String get guidelineDistance => _t(
    en: "Keep phone 30–40 cm away",
    ml: "ഫോൺ 30–40 സെ.മീ അകലെ",
    ta: "30–40 செ.மீ தூரம்",
    hi: "30–40 सेमी दूरी रखें",
  );

  String get guidelineDryLeaf => _t(
    en: "Avoid wet or dusty leaves",
    ml: "നനഞ്ഞ ഇല ഒഴിവാക്കുക",
    ta: "நனைந்த இலை தவிர்க்கவும்",
    hi: "गीली पत्तियों से बचें",
  );

  String get startDetection => _t(
    en: "Capture Disease Detection",
    ml: "ക്യാമറ ഉപയോഗിച്ച് കണ്ടെത്തുക",
    ta: "கேமராவுடன் கண்டறிதல்",
    hi: "कैमरा से पहचानें",
  );

  String get uploadFromGallery => _t(
    en: "Upload from Gallery",
    ml: "ഗാലറിയിൽ നിന്ന്",
    ta: "கேலரியில் இருந்து",
    hi: "गैलरी से अपलोड",
  );

  // ======================================================
  // ERRORS / LOADING
  // ======================================================
  String get invalidImageTitle => _t(
    en: "Invalid Image",
    ml: "അസാധുവായ ചിത്രം",
    ta: "தவறான படம்",
    hi: "अमान्य फोटो",
  );

  String get invalidImageMessage => _t(
    en: "Please upload a clear cardamom leaf image.",
    ml: "വ്യക്തമായ ഏലക്ക ഇല ചിത്രം നൽകുക.",
    ta: "தெளிவான ஏலக்காய் இலை படம் பதிவேற்றவும்",
    hi: "साफ इलायची पत्ती फोटो अपलोड करें",
  );

  String get analyzingImage => _t(
    en: "Analyzing image…",
    ml: "ചിത്രം വിശകലനം ചെയ്യുന്നു…",
    ta: "படம் பகுப்பாய்வு செய்யப்படுகிறது…",
    hi: "चित्र विश्लेषण हो रहा है…",
  );

  String get analysisFailed => _t(
    en: "Analysis Failed",
    ml: "വിശകലനം പരാജയപ്പെട്ടു",
    ta: "பகுப்பாய்வு தோல்வி",
    hi: "विश्लेषण असफल",
  );

  String get retry => _t(
    en: "Retry",
    ml: "വീണ്ടും ശ്രമിക്കുക",
    ta: "மீண்டும் முயற்சி",
    hi: "फिर कोशिश करें",
  );

  String errorMessage(String key) {
    return _t(
      en: "Something went wrong. Please try again.",
      ml: "പിശക് സംഭവിച്ചു. വീണ്ടും ശ്രമിക്കുക.",
      ta: "பிழை ஏற்பட்டது. மீண்டும் முயற்சிக்கவும்.",
      hi: "कुछ गलत हुआ। फिर प्रयास करें।",
    );
  }

  // ======================================================
  // PREVIEW / SAM
  // ======================================================
  String get previewImage => _t(
    en: "Preview Image",
    ml: "ചിത്രം മുൻകാഴ്ച",
    ta: "பட முன்னோட்டம்",
    hi: "छवि पूर्वावलोकन",
  );

  String get retake => _t(
    en: "Retake",
    ml: "വീണ്ടും എടുക്കുക",
    ta: "மீண்டும் எடுக்க",
    hi: "दोबारा लें",
  );

  String get selectLeafRegion => _t(
    en: "Select Leaf Region",
    ml: "ഇലയുടെ ഭാഗം തിരഞ്ഞെടുക്കുക",
    ta: "இலை பகுதியை தேர்வு",
    hi: "पत्ती क्षेत्र चुनें",
  );

  String get applySegmentation => _t(
    en: "Apply SAM Segmentation",
    ml: "SAM സെഗ്മെന്റേഷൻ പ്രയോഗിക്കുക",
    ta: "SAM பகுப்பாக்கம்",
    hi: "SAM सेगमेंटेशन लागू करें",
  );

  // ======================================================
  // HISTORY / PDF
  // ======================================================
  String get history => _t(
    en: "Scan History",
    ml: "സ്കാൻ ചരിത്രം",
    ta: "ஸ்கேன் வரலாறு",
    hi: "स्कैन इतिहास",
  );

  String get noHistory => _t(
    en: "No scan history found",
    ml: "സ്കാൻ ചരിത്രം ഇല്ല",
    ta: "வரலாறு இல்லை",
    hi: "कोई इतिहास नहीं",
  );

  String get generatingPdf => _t(
    en: "Generating PDF…",
    ml: "PDF സൃഷ്ടിക്കുന്നു…",
    ta: "PDF உருவாக்கப்படுகிறது…",
    hi: "PDF बन रहा है…",
  );

  String get historyPdfSubtitle => _t(
    en: "Cardamom Leaf Scan Report",
    ml: "ഏലക്ക ഇല റിപ്പോർട്ട്",
    ta: "ஏலக்காய் இலை அறிக்கை",
    hi: "इलायची पत्ती रिपोर्ट",
  );

  String get page => _t(en: "Page", ml: "പേജ്", ta: "பக்கம்", hi: "पृष्ठ");
  String get image => _t(en: "Image", ml: "ചിത്രം", ta: "படம்", hi: "चित्र");
  String get disease => _t(en: "Disease", ml: "രോഗം", ta: "நோய்", hi: "रोग");
  String get confidence =>
      _t(en: "Confidence", ml: "വിശ്വാസ്യത", ta: "நம்பகத்தன்மை", hi: "विश्वास");

  String get date => _t(en: "Date", ml: "തീയതി", ta: "தேதி", hi: "तारीख");

  // ======================================================
  // RESULT
  // ======================================================
  String get leafHealthReport => _t(
    en: "Leaf Health Report",
    ml: "ഇല ആരോഗ്യ റിപ്പോർട്ട്",
    ta: "இலை ஆரோக்கிய அறிக்கை",
    hi: "पत्ती स्वास्थ्य रिपोर्ट",
  );

  String get healthyLeaf =>
      _t(en: "Healthy Leaf", ml: "ആരോഗ്യകരമായ ഇല", ta: "ஆரோக்கியமான இலை", hi: "स्वस्थ पत्ती");

  String get uncertain =>
      _t(en: "Uncertain", ml: "അനിശ്ചിതം", ta: "நிச்சயமற்றது", hi: "अनिश्चित");

  String diseaseDetected(String d) => _t(
    en: "Disease Detected ($d)",
    ml: "രോഗം കണ്ടെത്തി ($d)",
    ta: "நோய் கண்டறியப்பட்டது ($d)",
    hi: "रोग पाया गया ($d)",
  );

  // ======================================================
  // HELPER
  // ======================================================
  String _t({
    required String en,
    required String ml,
    required String ta,
    required String hi,
  }) {
    switch (lang) {
      case AppLanguage.ml:
        return ml;
      case AppLanguage.ta:
        return ta;
      case AppLanguage.hi:
        return hi;
      case AppLanguage.en:
      default:
        return en;
    }
  }
}
