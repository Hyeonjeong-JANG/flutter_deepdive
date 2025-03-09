// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:actual/user/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(),
      ),
    );

    // 스플래시 화면에 로고 이미지가 있는지 확인
    expect(find.byType(Image), findsOneWidget);

    // 로딩 인디케이터가 있는지 확인
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
