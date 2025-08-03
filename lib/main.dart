import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(CurrencyV());
}

class CurrencyV extends StatelessWidget {
  CurrencyV({super.key});
  int count = 10;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          headlineMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa'), // Spanish
      ],
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 27, 28),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(113, 0, 0, 0),
        actions: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 169, 124, 108),
            backgroundImage: AssetImage('assets/images/V.png'),
            radius: 20,
          ),
          SizedBox(width: 10),

          Text(
            'currencyV',
            style: TextStyle(
              fontSize: 13,
              color: const Color.fromARGB(255, 112, 112, 112),
            ),
          ),
          SizedBox(width: 10),

          Spacer(),

          Icon(Icons.menu),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.currency_exchange, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'نرم افزاری برای مشاهده نرخ ارز و کریپتوکارنسی',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
