// verifying settings screen has about section
// and about screen has correct info
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_planner/features/settings/about_screen.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('AboutScreen displays correct info', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: AboutScreen(),
      ),
    );

    // Verify Developer Name
    expect(find.text('Khalid Bin Waheed'), findsOneWidget);

    // Verify Company Name
    expect(find.text('Code Cryptical IT Innovators'), findsOneWidget);

    // Verify specific parts of description or just the widget presence
    // Description text might be long and wrapped, better check for key phrases
    expect(
      find.textContaining(
        'Ramadan Planner is your comprehensive spiritual companion',
      ),
      findsOneWidget,
    );
  });
}
