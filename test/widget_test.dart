import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cardamom_leaves_disease_detector/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const CardamomDiseaseApp());

    // Allow initial frames to render
    await tester.pumpAndSettle();

    // Verify app title exists in AppBar
    expect(
      find.text('Cardamom Leaf Disease Detection'),
      findsOneWidget,
    );
  });
}
