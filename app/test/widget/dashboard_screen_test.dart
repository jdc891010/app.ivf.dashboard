import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ivf_clinic_dashboard/screens/dashboard_screen.dart';

void main() {
  testWidgets('DashboardScreen shows charts and app drawer', (WidgetTester tester) async {
    // Set a large surface size to avoid overflow in tests
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build the DashboardScreen widget with routes for AppDrawer
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/dashboard',
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/messenger': (context) => const Scaffold(body: Text('Messenger')), // Mock route
        },
      ),
    );

    // Verify key components
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('View All'), findsOneWidget);
    expect(find.text('Open Messenger'), findsOneWidget);
    
    // Verify scrollable areas
    expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
    
    // Verify icons exist
    expect(find.byIcon(Icons.notifications_active), findsOneWidget);
    expect(find.byIcon(Icons.message_outlined), findsOneWidget);

    // Verify Dashboard title
    // Depending on screen size, some widgets might be hidden/shown, but title should be there.
    // DashboardScreen usually has a Scaffold.
    expect(find.byType(DashboardScreen), findsOneWidget);
    
    // Check for AppDrawer icon (Menu icon)
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Check for "Treatment Analytics" text which is in _buildChartsSection
    expect(find.text('Treatment Analytics'), findsOneWidget);
  });
}
