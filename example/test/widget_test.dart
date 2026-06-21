import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sankey_diagram_flutter_example/app.dart';

void main() {
  testWidgets('SankeyDemoApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SankeyDemoApp());

    // Advance past the repository's Future.delayed (350 ms) + entry animation (600 ms).
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
  });
}
