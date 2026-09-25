import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rolnik_gra/main.dart';

void main() {
  testWidgets('Splash screen shows title and start buttons',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const RolnikApp());
    // Nie pumpAndSettle - ekran startowy ma teraz bezustannie powtarzające
    // się animacje tła (Ken Burns + mgła), które nigdy się nie "ustabilizują".
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Rolnik'), findsOneWidget);
    expect(find.text('Nowa gra'), findsOneWidget);
    // Bez zapisanej gry (świeży mock stan) przycisk "Kontynuuj" jest ukryty,
    // nie tylko wyszarzony - patrz SplashScreen._hasSave.
    expect(find.text('Kontynuuj'), findsNothing);
  });
}
