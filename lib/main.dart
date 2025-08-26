import 'package:currencyv/core/theme/app_theme.dart';
import 'package:currencyv/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const CurrencyV());
}

class CurrencyV extends StatelessWidget {
  const CurrencyV({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fa')],
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
