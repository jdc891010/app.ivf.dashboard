import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ivf_clinic_dashboard/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App startup and navigation smoke test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Verify we are on Dashboard Screen directly
    // Dashboard should show "Treatment Analytics" or "Dashboard" title
    expect(find.text('Treatment Analytics'), findsOneWidget);
  });
}
