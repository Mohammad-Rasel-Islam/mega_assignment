import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RestaurantApp());
    expect(find.byType(RestaurantApp), findsOneWidget);
  });
}
