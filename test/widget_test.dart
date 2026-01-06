
import 'package:flutter_test/flutter_test.dart';
import 'package:phapthoailangmai/main.dart';
import 'package:phapthoailangmai/screens/home_screen.dart';
import 'package:phapthoailangmai/widgets/player_widget.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that HomeScreen is displayed
    expect(find.byType(HomeScreen), findsOneWidget);

    // Verify that PlayerWidget is displayed (persistent)
    expect(find.byType(PlayerWidget), findsOneWidget);

    // Verify title
    expect(find.text('Pháp Thoại Làng Mai'), findsOneWidget);
  });
}
