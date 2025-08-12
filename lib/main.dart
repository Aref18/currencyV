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
            fontSize: 17,
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

// ignore: camel_case_types
class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

// ignore: camel_case_types
class _homepageState extends State<homepage> {
  //connecty to Api
  List<Arzcurrency> arz = [];

  GetResponse() {
    var Url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";

    http.get(Uri.parse(Url)).then((value) {
      if (arz.isEmpty) {
        if (value.statusCode == 200) {
          List jsonList = convert.jsonDecode(value.body);
          // ignore: prefer_is_empty
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

  //--------------------searching part

  List<Arzcurrency> filteredItems = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = [];
  }

  void filterSearch(String query) {
    final results =
        arz
            .where(
              (item) => item.title!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    setState(() {
      filteredItems = results;
    });
  }

  // ---------- متدهای کمکی برای ریسپانسیو----------

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 2; // موبایل
    } else if (width < 900) {
      return 3; // تبلت عمودی
    } else {
      return 4; // تبلت افقی یا دسکتاپ
    }
  }

  double _getAspectRatio(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 1; // موبایل: کارت تقریبا مربعی
    } else {
      return 1.5; // تبلت و دسکتاپ: کارت پهن‌تر
    }
  }

  @override
  Widget build(BuildContext context) {
    GetResponse();
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
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 83, 82, 82),
                  hintText: 'جستجو... ',
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: filterSearch,
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 500,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount:
                      filteredItems.isEmpty ? arz.length : filteredItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Items(
                      index,
                      filteredItems.isEmpty ? arz : filteredItems,
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(
                      context,
                    ), // تعداد ستون‌ها ریسپانسیو
                    childAspectRatio: _getAspectRatio(
                      context,
                    ), // نسبت عرض به ارتفاع ریسپانسیو
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                            _showSnakeBar(context, _getTime());
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
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 1.0, color: Colors.purple),
          ],
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),

        width: double.infinity,
        height: 55,

        child: Column(
          spacing: 50,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                arz[index].title!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  arz[index].price!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      arz[index].changes!,
                      style:
                          arz[index].status == "n"
                              ? Theme.of(context).textTheme.headlineSmall
                              : Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(width: 4),
                    Icon(
                      arz[index].status == "n"
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color:
                          arz[index].status == "n" ? Colors.red : Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
