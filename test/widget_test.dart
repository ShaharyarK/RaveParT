import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ravepart_app/main.dart';

void main() {
  testWidgets('Rave ParT main screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(RaveParTApp());

    expect(find.text('How do you want to detect your mood?'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
}
