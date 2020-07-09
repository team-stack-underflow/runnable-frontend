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

  testWidgets('Language Box', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWidget(widget: LangBox(
      name: "C",
      image: 'c.png',
    )));

    // There should be one main widget
    expect(find.byType(LangBox), findsOneWidget);

    // There should be one button
    expect(find.byType(RaisedButton), findsOneWidget);

    // There should be one label with the language name
    expect(find.text("C"), findsOneWidget);

  });

  testWidgets('REPL/Compile Select Page', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWidget(widget: RCSelectPage(name: "Java")));

    // There should be one main widget
    expect(find.byType(RCSelectPage), findsOneWidget);

    // There should be one app bar
    expect(find.byType(AppBar), findsOneWidget);

    // There should be two mode options
    expect(find.byType(RaisedButton), findsNWidgets(2));

    // There should be one label for each execution mode
    expect(find.text("REPL"), findsOneWidget);
    expect(find.text("Compile"), findsOneWidget);

  });
  
}
