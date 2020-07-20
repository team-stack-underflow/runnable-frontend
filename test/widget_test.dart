// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runnable/main.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {

  // Wraps a Widget in a MaterialApp for testing
  var wrapWidget = ({Widget widget}) => MaterialApp(home: widget);

  testWidgets('RunnableHome', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWidget(widget: RunnableHome()));

    // There should be one main widget
    expect(find.byType(RunnableHome), findsOneWidget);

    // There should be one app bar
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Runnable'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    
    // There should be four language options
    expect(find.byType(LangBox), findsNWidgets(4));
    expect(find.text('Python'), findsOneWidget);
    expect(find.text('Java'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('JavaScript'), findsOneWidget);

  });

  testWidgets('RCSelectPage', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWidget(widget: RCSelectPage(name: 'Test')));

    // There should be one main widget
    expect(find.byType(RCSelectPage), findsOneWidget);

    // There should be one app bar
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // There should be two environment options
    expect(find.text('REPL'), findsOneWidget);
    expect(find.text('Compile'), findsOneWidget);
  });

 /* testWidgets('ReplPage', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(wrapWidget(widget: ReplPage(name: 'Test', channel: null,)));
      await tester.pumpAndSettle();
      // There should be one main widget
      //expect(find.byType(ReplPage), findsOneWidget);

      // There should be one app bar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });
  });*/

  testWidgets('SettingsPage', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWidget(widget: SettingsPage()));

    // There should be one main widget
    expect(find.byType(SettingsPage), findsOneWidget);

    // There should be one app bar
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // There should be six settings options
    expect(find.byType(Card), findsNWidgets(6));

    expect(find.text('User guide'), findsOneWidget);
    expect(find.byIcon(Icons.book), findsOneWidget);

    expect(find.text('Theme'), findsOneWidget);
    expect(find.byIcon(Icons.brightness_6), findsOneWidget);

    expect(find.text('Code font size'), findsOneWidget);
    expect(find.byIcon(Icons.text_fields), findsOneWidget);

    expect(find.text('Storage location'), findsOneWidget);
    expect(find.byIcon(Icons.sd_storage), findsOneWidget);

    expect(find.text('About'), findsOneWidget);
    expect(find.byIcon(Icons.help), findsOneWidget);

    expect(find.text('Report a bug'), findsOneWidget);
    expect(find.byIcon(Icons.bug_report), findsOneWidget);

    expect(find.byIcon(Icons.keyboard_arrow_right), findsNWidgets(3));
  });
}
