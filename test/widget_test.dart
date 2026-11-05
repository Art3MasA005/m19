import 'package:calorie_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('starts empty and shows the default goal', (tester) async {
    await tester.pumpWidget(const CalorieTrackerApp());

    expect(find.text('Calorie Tracker'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('No food added today'), 200);
    expect(find.text('No food added today'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('validates input, then adds and deletes food', (tester) async {
    await tester.pumpWidget(const CalorieTrackerApp());
    await tester.tap(find.text('Add Food'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Food').last);
    await tester.pumpAndSettle();
    expect(find.text('Enter a food name'), findsOneWidget);
    expect(find.text('Enter a calorie amount'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Bread');
    await tester.enterText(find.byType(TextFormField).last, '-5');
    await tester.tap(find.text('Add Food').last);
    await tester.pumpAndSettle();
    expect(find.text('Enter a positive number'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).last, '200');
    await tester.tap(find.text('Add Food').last);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Bread'), 200);
    expect(find.text('Bread'), findsOneWidget);
    expect(find.text('200 kcal'), findsWidgets);

    await tester.drag(find.byType(ListView), const Offset(0, 600));
    await tester.pumpAndSettle();
    expect(find.textContaining('1,800'), findsOneWidget);

    await tester.scrollUntilVisible(find.byTooltip('Delete Bread'), 200);
    await tester.tap(find.byTooltip('Delete Bread'));
    await tester.pumpAndSettle();
    expect(find.text('Bread'), findsNothing);
    await tester.scrollUntilVisible(find.text('No food added today'), 200);
    expect(find.text('No food added today'), findsOneWidget);
  });

  testWidgets('add page fits a narrow screen and cancel actions return home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CalorieTrackerApp());
    await tester.tap(find.text('Add Food'));
    await tester.pumpAndSettle();

    expect(find.text('Add a food item to your daily log'), findsOneWidget);
    expect(find.text('Required field'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Calorie Tracker'), findsOneWidget);

    await tester.tap(find.text('Add Food'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Calorie Tracker'), findsOneWidget);
  });

  testWidgets('daily tracking shares food and totals with home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CalorieTrackerApp());
    await tester.tap(find.byTooltip('Daily Tracking'));
    await tester.pumpAndSettle();
    expect(find.text('Daily Tracking'), findsOneWidget);
    expect(find.text('No food added today'), findsOneWidget);

    await tester.tap(find.text('Add Food'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Bread');
    await tester.enterText(find.byType(TextFormField).last, '200');
    await tester.tap(find.text('Add Food').last);
    await tester.pumpAndSettle();

    expect(find.text('Bread'), findsOneWidget);
    expect(find.text('1,800'), findsOneWidget);
    await tester.tap(find.byTooltip('Back to Home'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Bread'), 200);
    expect(find.text('Bread'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, 800));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Daily Tracking'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete Bread'));
    await tester.pumpAndSettle();
    expect(find.text('No food added today'), findsOneWidget);
  });
}
