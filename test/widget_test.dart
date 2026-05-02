import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:dnd_ua/main.dart';
import 'package:dnd_ua/providers/app_state.dart';

void main() {
  testWidgets('DndApp renders smoke test', (WidgetTester tester) async {
    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: appState, child: const DndApp()),
    );

    expect(find.byType(DndApp), findsOneWidget);
  });
}
