import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_adhivasindo/main.dart';

void main() {
  testWidgets('renders home placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const MobileAdhivasindoApp());
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });
}
