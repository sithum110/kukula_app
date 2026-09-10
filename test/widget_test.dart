import 'package:flutter_test/flutter_test.dart';
import 'package:kukula_app/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KukulaApp());
    expect(find.byType(KukulaApp), findsOneWidget);
  });
}
