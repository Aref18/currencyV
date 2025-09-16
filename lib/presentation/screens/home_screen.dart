import 'package:currencyv/core/utils/date_utils.dart';
import 'package:currencyv/data/model/arz.dart';
import 'package:currencyv/data/services/api_service.dart';
import 'package:currencyv/presentation/widgets/floating_search_bar_widget.dart';
import 'package:currencyv/presentation/widgets/grid_item_widget.dart';
import 'package:currencyv/presentation/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  late Future<List<Arzcurrency>> _currenciesFuture;
  String? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _currenciesFuture = ApiService.fetchCurrencies();
    _lastUpdated = getShamsiDateTime();
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

  Future<void> _refreshData() async {
    final currencies = await ApiService.fetchCurrencies();
    setState(() {
      focusedIndex = null;
      arz = currencies;
      _currenciesFuture = Future.value(currencies);
      _lastUpdated = getShamsiDateTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 27, 28),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(113, 0, 0, 0),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Center(
                child: Text(
                  _lastUpdated ?? '',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(217, 255, 255, 255),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'ArzV',
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
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
                    child: RefreshIndicator(
                      onRefresh: _refreshData,
                      color: Colors.green,
                      backgroundColor: Colors.blueGrey,
                      child: FutureBuilder<List<Arzcurrency>>(
                        future: _currenciesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "خطا در دریافت اطلاعات",
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            final currencies = snapshot.data!;
                            if (arz.isEmpty) {
                              arz = currencies;
                              selectedItem = arz.take(4).toList();
                            }

                            return GestureDetector(
                              onTap: () {
                                if (focusedIndex != null) {
                                  setState(() {
                                    focusedIndex = null;
                                  });
                                }
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) {
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
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemCount: selectedItem.length,
                                          itemBuilder: (context, index) {
                                            return ListItemWidget(
                                              key: ValueKey(
                                                selectedItem[index].id,
                                              ),
                                              index: index,
                                              arz: selectedItem,
                                              isFocused: focusedIndex == index,
                                              onLongPress: () {
                                                if (focusedIndex != index) {
                                                  setState(() {
                                                    focusedIndex = index;
                                                  });
                                                }
                                              },
                                              onTap: () {
                                                if (focusedIndex != null) {
                                                  setState(() {
                                                    focusedIndex = null;
                                                  });
                                                }
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
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          clipBehavior: Clip.none,
                                          itemCount: selectedItem.length,
                                          itemBuilder: (context, index) {
                                            return GridItemWidget(
                                              key: ValueKey(
                                                selectedItem[index].id,
                                              ),
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
                                                crossAxisCount:
                                                    _getCrossAxisCount(context),
                                                childAspectRatio:
                                                    _getAspectRatio(context),
                                                crossAxisSpacing: 12,
                                                mainAxisSpacing: 12,
                                              ),
                                        ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text(
                                "هیچ داده‌ای برای نمایش وجود ندارد",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        },
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
                  if (!selectedItem.any((i) => i.id == item.id)) {
                    selectedItem.add(item);
                  }
                });
              },
              isItemSelected: (item) {
                int index = arz.indexWhere((i) => i.id == item.id);
                if (index >= 0 && index < 4) return true;
                return selectedItem.any((i) => i.id == item.id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
