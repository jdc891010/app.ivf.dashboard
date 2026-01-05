import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ivf_clinic_dashboard/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen shows input fields and button', (WidgetTester tester) async {
    // Set a large surface size to avoid overflow in tests
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build the LoginScreen widget
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Find email and password fields
    final emailFinder = find.byType(TextFormField).first;
    final passwordFinder = find.byType(TextFormField).last;
    final buttonFinder = find.byType(ElevatedButton);

    // Verify fields exist
    expect(emailFinder, findsOneWidget);
    expect(passwordFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);

    // Verify title text
    expect(find.text('IVF Clinic Dashboard'), findsOneWidget);
  });

  testWidgets('LoginScreen validates empty input', (WidgetTester tester) async {
    // Set a large surface size to avoid overflow in tests
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Tap login button without entering data
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify validation errors
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
