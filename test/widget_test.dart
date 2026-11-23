
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myportfolio/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MyPortfolio application test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyPortfolioApp());

    // نعطيو وقت للبيانات باش تتحمّل
    await tester.pump(const Duration(seconds: 2));

    // نتحققو من ظهور الواجهة
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Rania BEN JEMAA'), findsOneWidget);
    expect(find.text('Chayma BEN ROMDHANE'), findsOneWidget);
  });
}
