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
      supportedLocales: [Locale('fa')],
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}

class ItemModel {
  final String? title;
  ItemModel({this.title});
}

class homepage extends StatefulWidget {
  homepage({super.key});
  List<ItemModel> allItems = List.generate(
    20,
    (index) => ItemModel(title: "آیتم شماره $index"),
  );

  List<Arzcurrency> selectedItem = [];

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Arzcurrency> arz = [];

  Future GetResponse(BuildContext cntx) async {
    var Url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(Url));
    if (arz.isEmpty) {
      if (value.statusCode == 200) {
        List jsonList = convert.jsonDecode(value.body);
        if (jsonList.isNotEmpty) {
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
  }

  List<Arzcurrency> filteredItems = [];
  bool showResults = false;

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 2;
    } else if (width < 900) {
      return 3;
    } else {
      return 3;
    }
  }

  double _getAspectRatio(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 1;
    } else {
      return 1.5;
    }
  }

  @override
  void initState() {
    GetResponse(context);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FloatingSearchBar.of(context)?.open();
    });
  }

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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Expanded(
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount:
                          showResults ? widget.selectedItem.length : arz.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Items(
                          index,
                          showResults ? widget.selectedItem : arz,
                          onLongPress: () {
                            if (showResults && widget.selectedItem.isNotEmpty) {
                              setState(() {
                                widget.selectedItem.removeAt(index);
                                if (widget.selectedItem.isEmpty) {
                                  showResults = false;
                                }
                              });
                              _showSnakeBar(context, 'آیتم حذف شد');
                            }
                          },
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

  TextEditingController searchController = TextEditingController();
  String currentQuery = '';

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return FloatingSearchBar(
      hint: 'جستجوی رمز ارز...',
      queryStyle: TextStyle(color: Colors.black),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      width: isPortrait ? 600 : 700,
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 300),
      onQueryChanged: (query) {
        setState(() {
          currentQuery = query;
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
        if (currentQuery.isEmpty) return SizedBox.shrink();

        final displayList = filteredItems.isEmpty ? arz : filteredItems;

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final item = displayList[index];
                final isAdded = widget.selectedItem.contains(item);

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title ?? '',
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isAdded
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                          color: isAdded ? Colors.green : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isAdded) {
                              widget.selectedItem.remove(item);
                            } else {
                              widget.selectedItem.add(item);
                            }
                          });
                          _showSnakeBar(
                            context,
                            isAdded ? 'آیتم حذف شد' : 'آیتم اضافه شد',
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      searchController.text = item.title ?? '';
                      widget.selectedItem.clear();
                      widget.selectedItem.add(item);
                      showResults = true;
                    });
                    FloatingSearchBar.of(context)?.close();
                  },
                );
              },
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

class Items extends StatelessWidget {
  final int index;
  final List<Arzcurrency> arz;
  final VoidCallback? onLongPress;

  Items(this.index, this.arz, {super.key, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(blurRadius: 1.0, color: Colors.purple),
            ],
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
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
                            arz[index].status == "n"
                                ? Colors.red
                                : Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
