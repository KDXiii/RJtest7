import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_skeleton/main.dart';

void main() {
  testWidgets('分类入口进入对应列表，长按选择结果回传首页副标题',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('图书分类'), findsOneWidget);
    expect(find.text('请选择分类'), findsOneWidget);

    await tester.tap(find.text('计算机技术'));
    await tester.pumpAndSettle();

    expect(find.text('跨平台之路'), findsOneWidget);
    expect(find.text('状态管理简史'), findsNothing);

    await tester.longPress(find.text('跨平台之路'));
    await tester.pumpAndSettle();

    expect(find.text('仅看高借阅量'), findsOneWidget);

    await tester.tap(find.text('仅看高借阅量'));
    await tester.pumpAndSettle();

    expect(find.text('图书分类'), findsOneWidget);
    expect(find.text('计算机技术 · 仅看高借阅量'), findsOneWidget);
  });

  testWidgets('列表项跳转详情页并可返回', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('计算机技术'));
    await tester.pumpAndSettle();

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

    expect(find.text('图书详情'), findsNothing);
    expect(find.text('跨平台之路'), findsOneWidget);
  });
}
