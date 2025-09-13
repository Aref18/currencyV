import 'package:currencyv/data/model/arz.dart';
import 'package:currencyv/data/services/api_service.dart';
import 'package:currencyv/presentation/widgets/floating_search_bar_widget.dart';
import 'package:currencyv/presentation/widgets/grid_item_widget.dart';
import 'package:currencyv/presentation/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Arzcurrency> arz = [];
  List<Arzcurrency> selectedItem = [];
  int? focusedIndex;
  bool isVertical = false;
  bool showResults = false;

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  void fetchCurrencies() async {
    if (arz.isEmpty) {
      final currencies = await ApiService.fetchCurrencies();
      setState(() {
        arz = currencies;
        selectedItem = arz.take(4).toList();
      });
    }
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 2;
    if (width < 900) return 3;
    return 3;
  }

  double _getAspectRatio(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width < 600 ? 1 : 1.5;
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
          IconButton(
            icon: Icon(
              isVertical ? Icons.list : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isVertical = !isVertical;
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          focusedIndex = null;
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          // می‌تونی نوع انیمیشن رو اینجا عوض کنی
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.1, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child:
                            isVertical
                                ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: selectedItem.length,
                                  itemBuilder: (context, index) {
                                    return ListItemWidget(
                                      key: ValueKey(selectedItem[index].id),
                                      index: index,
                                      arz: selectedItem,
                                      isFocused: focusedIndex == index,
                                      onLongPress: () {
                                        setState(() {
                                          focusedIndex = index;
                                        });
                                      },
                                      onTap: () {
                                        setState(() {
                                          focusedIndex = null;
                                        });
                                      },
                                      onDelete: () {
                                        setState(() {
                                          selectedItem.removeAt(index);
                                          focusedIndex = null;
                                        });
                                      },
                                    );
                                  },
                                )
                                : GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  clipBehavior: Clip.none,
                                  itemCount: selectedItem.length,
                                  itemBuilder: (context, index) {
                                    return GridItemWidget(
                                      key: ValueKey(selectedItem[index].id),
                                      index: index,
                                      arz: selectedItem,
                                      isFocused: focusedIndex == index,
                                      onLongPress: () {
                                        setState(() {
                                          focusedIndex = index;
                                        });
                                      },
                                      onTap: () {
                                        setState(() {
                                          focusedIndex = null;
                                        });
                                      },
                                      onDelete: () {
                                        setState(() {
                                          selectedItem.removeAt(index);
                                          focusedIndex = null;
                                        });
                                      },
                                    );
                                  },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: _getCrossAxisCount(
                                          context,
                                        ),
                                        childAspectRatio: _getAspectRatio(
                                          context,
                                        ),
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingSearchBarWidget(
              arz: arz,
              selectedItem: selectedItem,
              onQueryChanged: (query) {},
              onItemSelected: (item) {
                setState(() {
                  if (!selectedItem.contains(item)) {
                    selectedItem.add(item);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
