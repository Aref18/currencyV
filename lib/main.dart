import 'dart:ui';

import 'package:currencyv/model/arz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

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
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
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

  // ---------- متدهای کمکی برای ریسپانسیو----------

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 2; // موبایل
    } else if (width < 900) {
      return 3; // تبلت عمودی
    } else {
      return 3; // تبلت افقی یا دسکتاپ
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

  bool showResultss = false;
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
      body: Stack(
        children: [
          // پس زمینه: اینجا GridView رو مستقیم میذاریم تا پشت Blur باشه
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SizedBox(height: 60), // جای سرچ بار
                  Expanded(
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount:
                          filteredItems.isEmpty
                              ? arz.length
                              : filteredItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Items(
                          index,
                          filteredItems.isEmpty ? arz : filteredItems,
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(context),
                        childAspectRatio: _getAspectRatio(context),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildFloatingSearchBar(),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return FloatingSearchBar(
      hint: 'جستجوی رمز ارز...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      width: isPortrait ? 600 : 500,
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 300),
      onQueryChanged: (query) {
        // فیلتر کردن لیست
        setState(() {
          filteredItems =
              arz
                  .where(
                    (item) =>
                        item.title!.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [FloatingSearchBarAction.searchToClear()],
      builder: (context, transition) {
        final displayList = filteredItems.isEmpty ? arz : filteredItems;

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: SizedBox(
              height: 500,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final item = displayList[index];
                  return ListTile(
                    title: Text(item.title ?? ''),
                    onTap: () {
                      // میتونی اینجا اکشن بزاری
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
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
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Image.network(
                      "https://cryptologos.cc/logos/bitcoin-btc-logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    arz[index].title!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
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
