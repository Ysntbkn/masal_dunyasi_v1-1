import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:masal_dunyasi_v1/core/state/app_state.dart';
import 'package:masal_dunyasi_v1/main.dart';

void main() {
  testWidgets('Login screen renders auth choices', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MasalDunyasiApp(),
      ),
    );
    await tester.pump();

    expect(find.text('G\u0130R\u0130\u015e YAP'), findsOneWidget);
    expect(find.text('L\u00fctfen Bir Y\u00f6ntem Se\u00e7in'), findsOneWidget);
    expect(find.text('Google \u0130le Giri\u015f Yap'), findsOneWidget);
    expect(find.text('Misafir Olarak Girin'), findsOneWidget);
  });
}
