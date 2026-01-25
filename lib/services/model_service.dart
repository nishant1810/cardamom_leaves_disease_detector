import 'classifier.dart';

class ModelService {
  static final Classifier classifier = Classifier();
  static bool _loaded = false;

  static Future<void> init() async {
    if (!_loaded) {
      await classifier.loadModel();
      _loaded = true;
    }
  }
}
