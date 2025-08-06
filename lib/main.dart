import 'package:flutter/cupertino.dart';
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
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          bodyLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          bodyMedium: TextStyle(
            fontSize: 15,
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

//----------------------------------------------------
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
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 169, 124, 108),
            backgroundImage: AssetImage('assets/images/V.png'),
            radius: 20,
          ),
          SizedBox(width: 10),
          Text('CurrencyV', style: Theme.of(context).textTheme.headlineLarge),

          Spacer(),
          Icon(Icons.menu),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                width: double.infinity,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(146, 224, 109, 101),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 500,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Items();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: const Color.fromARGB(146, 224, 109, 101),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: double.infinity,
                        child: TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.blueGrey,
                            ),
                          ),
                          onPressed: () {},
                          label: Text(
                            'بروزرسانی',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          icon: Icon(
                            CupertinoIcons.refresh,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//----------------------------------------------------

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 1.0, color: Colors.grey),
          ],
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),

        width: double.infinity,
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text('دلار'), Text('93700'), Text('+43')],
        ),
      ),
    );
  }
}
