import 'package:flutter_test/flutter_test.dart';
import 'package:network_settings_state_example/main.dart';

void main() {
  testWidgets('renders app bar title', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('network_settings_state'), findsOneWidget);
  });
}