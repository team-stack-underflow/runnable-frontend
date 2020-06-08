// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runnable/main.dart';

void main() {

  // Wraps a Widget in a MaterialApp for testing
  var wrapWidget = ({Widget widget}) => MaterialApp(home: widget);

  testWidgets('Home Page', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWidget(widget: RunnableHome()));

    // There should be one main widget
    expect(find.byType(RunnableHome), findsOneWidget);

    // There should be one app bar
    expect(find.byType(AppBar), findsOneWidget);
    
    // There should be four language options
    expect(find.byType(LangBox), findsNWidgets(4));

  });
  
}
