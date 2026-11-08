import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_skeleton/main.dart';

void main() {
  testWidgets('列表项跳转详情页并可返回', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('图书列表'), findsOneWidget);

    await tester.tap(find.text('跨平台之路'));
    await tester.pumpAndSettle();

    expect(find.text('图书详情'), findsOneWidget);
    expect(find.text('b01'), findsOneWidget);
    expect(find.text('张承志'), findsOneWidget);
    expect(find.text('计算机技术'), findsOneWidget);
    expect(find.text('1月'), findsOneWidget);
    expect(find.text('5 / 5'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, '返回'));
    await tester.pumpAndSettle();

    expect(find.text('图书列表'), findsOneWidget);
    expect(find.text('图书详情'), findsNothing);
  });
}
