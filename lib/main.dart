import 'package:currencyv/model/arz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(CurrencyV());
}

class CurrencyV extends StatelessWidget {
  CurrencyV({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.green,
          ),
          headlineSmall: TextStyle(fontSize: 18, color: Colors.red),
          bodyLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
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

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Arzcurrency> arz = [];
  GetResponse(BuildContext cntx) {
    var Url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";

    http.get(Uri.parse(Url)).then((value) {
      if (arz.isEmpty) {
        if (value.statusCode == 200) {
          List jsonList = convert.jsonDecode(value.body);
          if (jsonList.length > 0) {
            for (var i = 0; i < jsonList.length; i++) {
              setState(() {
                arz.add(
                  Arzcurrency(
                    id: jsonList[i]["id"],
                    title: jsonList[i]["title"],
                    price: jsonList[i]["price"],
                    changes: jsonList[i]["changes"],
                    status: jsonList[i]["status"],
                  ),
                );
              });
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    GetResponse(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 27, 28),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(113, 0, 0, 0),
        actions: [
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/V.png'),
            radius: 20,
          ),
          SizedBox(width: 10),
          Text('ArzV', style: Theme.of(context).textTheme.bodyLarge),

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
                    style: Theme.of(context).textTheme.bodyLarge,
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
                    Text('نام', style: Theme.of(context).textTheme.bodyLarge),
                    Text('قیمت', style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      'تغییرات',
                      style: Theme.of(context).textTheme.bodyLarge,
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
                  itemCount: arz.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Items(index, arz);
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      SizedBox(
                        height: double.infinity,
                        child: TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.purple,
                            ),
                          ),
                          onPressed: () {
                            _showSnakeBar(context, '${_getTime()}');
                          },
                          label: Text(
                            'بروزرسانی',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          icon: Icon(
                            CupertinoIcons.refresh,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),

                      Text('اخرین بروز رسانی  ${_getTime()}'),
                      SizedBox(),
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

String _getTime() {
  return '23:45';
}

void _showSnakeBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.green),
  );
}

//----------------------------------------------------

class Items extends StatelessWidget {
  int index;
  List<Arzcurrency> arz;
  Items(this.index, this.arz, {super.key});

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
          children: [
            Text(
              arz[index].title!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              arz[index].price!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              arz[index].changes!,
              style:
                  arz[index].status == "n"
                      ? Theme.of(context).textTheme.headlineSmall
                      : Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
    );
  }
}
