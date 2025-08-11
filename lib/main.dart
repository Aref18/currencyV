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

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Arzcurrency> arz = [];
  List<Arzcurrency> filteredItems = [];
  GetResponse() {
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

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = [];
  }

  void filterSearch() {
    final query = searchController.text;
    final results = arz.where(
      (item) => item.title!.toLowerCase().contains(query.toLowerCase()),
    );

    setState(() {
      filteredItems = results.toList();
    });
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 83, 82, 82),
                  hintText: 'جستجو... ',
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onSubmitted: (value) => filterSearch(), // وقتی Enter بزنه
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 500,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount:
                      filteredItems.isEmpty ? arz.length : filteredItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Items(
                      index,
                      filteredItems.isEmpty ? arz : filteredItems,
                    );
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
