import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Arzcurrency> arz = [];
  List<Arzcurrency> filteredItems = [];

  GetResponse() async {
    var url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));

    if (arz.isEmpty && value.statusCode == 200) {
      List jsonList = convert.jsonDecode(value.body);
      if (jsonList.isNotEmpty) {
        setState(() {
          arz =
              jsonList
                  .map(
                    (e) => Arzcurrency(
                      id: e["id"],
                      title: e["title"],
                      price: e["price"],
                      changes: e["changes"],
                      status: e["status"],
                    ),
                  )
                  .toList();
        });
      }
    }
  }

  void filterSearch(String query) {
    filteredItems =
        arz
            .where(
              (item) => item.title!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 2;
    if (width < 900) return 3;
    return 3;
  }

  double _getAspectRatio(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    return 1.5;
  }

  @override
  void initState() {
    super.initState();
    GetResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 27, 28),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(113, 0, 0, 0),
        actions: [
          const SizedBox(width: 10),
          const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/V.png'),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Text('ArzV', style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          const Icon(Icons.menu),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              SearchAnchor.bar(
                barHintText: 'جستجو...',
                barBackgroundColor: WidgetStatePropertyAll(
                  const Color.fromARGB(185, 168, 166, 166),
                ),
                barElevation: WidgetStatePropertyAll(0),
                onChanged: (value) {
                  setState(() {
                    filterSearch(value);
                  });
                },
                suggestionsBuilder: (context, controller) {
                  filterSearch(controller.text);
                  return filteredItems.map((item) {
                    return ListTile(
                      title: Text(
                        item.title ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        controller.closeView(item.title ?? '');
                        filterSearch(item.title ?? '');
                      },
                    );
                  }).toList();
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount:
                      filteredItems.isEmpty ? arz.length : filteredItems.length,
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
    );
  }
}

class Arzcurrency {
  final String? id;
  final String? title;
  final String? price;
  final String? changes;
  final String? status;

  Arzcurrency({this.id, this.title, this.price, this.changes, this.status});
}

// این ویجت باید مثل قبل خودت داشته باشی
Widget Items(int index, List<Arzcurrency> list) {
  return Container(
    color: Colors.blueGrey,
    child: Center(
      child: Text(
        list[index].title ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
