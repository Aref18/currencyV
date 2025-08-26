import 'package:currencyv/core/utils/snackbar_utils.dart';
import 'package:currencyv/data/model/arz.dart';

import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class FloatingSearchBarWidget extends StatelessWidget {
  final List<Arzcurrency> arz;
  final List<Arzcurrency> selectedItem;
  final Function(String) onQueryChanged;
  final Function(Arzcurrency) onItemSelected;
  final Function(Arzcurrency, bool) onItemToggled;

  const FloatingSearchBarWidget({
    super.key,
    required this.arz,
    required this.selectedItem,
    required this.onQueryChanged,
    required this.onItemSelected,
    required this.onItemToggled,
  });

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final TextEditingController searchController = TextEditingController();
    String currentQuery = '';

    return FloatingSearchBar(
      hint: 'جستجوی رمز ارز...',
      queryStyle: const TextStyle(color: Colors.black),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      width: isPortrait ? 600 : 700,
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 300),
      onQueryChanged: (query) {
        currentQuery = query;
        onQueryChanged(query);
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [FloatingSearchBarAction.searchToClear()],
      builder: (context, transition) {
        if (currentQuery.isEmpty) return const SizedBox.shrink();

        final displayList =
            arz
                .where(
                  (item) => item.title!.toLowerCase().contains(
                    currentQuery.toLowerCase(),
                  ),
                )
                .toList();

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
                final isAdded = selectedItem.contains(item);

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title ?? '',
                          style: const TextStyle(fontSize: 16),
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
                          onItemToggled(item, isAdded);
                          showSnackBar(
                            context,
                            isAdded ? 'آیتم حذف شد' : 'آیتم اضافه شد',
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    searchController.text = item.title ?? '';
                    onItemSelected(item);
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
