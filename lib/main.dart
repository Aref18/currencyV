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
          headlineLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
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

          Text('CurrencyV', style: Theme.of(context).textTheme.headlineLarge),
          SizedBox(width: 10),

          Spacer(),
          Icon(Icons.menu),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.currency_exchange, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'نرم افزاری برای مشاهده نرخ ارز و کریپتوکارنسی',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(146, 224, 109, 101),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'نام',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'قیمت',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'تغییرات',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
