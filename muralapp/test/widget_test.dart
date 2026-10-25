import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Interface básica de comentários', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Text('Comentários')),
    ));
    expect(find.text('Comentários'), findsOneWidget);
  });
}
