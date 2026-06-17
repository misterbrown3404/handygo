import 'package:flutter_test/flutter_test.dart';
import 'package:handygo_admin/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    const app = HandyGoAdmin();
    expect(app, isNotNull);
  });
}
