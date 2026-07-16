import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_adhivasindo/main.dart';

void main() {
  testWidgets('renders home dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const MobileAdhivasindoApp());
    await tester.pumpAndSettle();

    expect(find.text('Good Morning'), findsOneWidget);
    expect(find.text('Learning Anywhere'), findsOneWidget);
    expect(find.text('Popular Courses'), findsOneWidget);
  });
}
