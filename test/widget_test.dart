import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:cardamom_leaves_disease_detector/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Mock empty camera list for testing
    cameras = <CameraDescription>[];

    await tester.pumpWidget(const CardamomDiseaseApp());

    // Verify app title exists
    expect(find.text('Cardamom Leaf Disease Detection'), findsOneWidget);
  });
}
