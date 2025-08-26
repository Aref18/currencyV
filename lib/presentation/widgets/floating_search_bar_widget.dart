import 'package:currencyv/core/utils/snackbar_utils.dart';
import 'package:currencyv/data/model/arz.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class FloatingSearchBarWidget extends StatefulWidget {
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
  State<FloatingSearchBarWidget> createState() =>
      _FloatingSearchBarWidgetState();
}

class _FloatingSearchBarWidgetState extends State<FloatingSearchBarWidget> {
  final FloatingSearchBarController _controller = FloatingSearchBarController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: _controller,
      hint: 'جستجوی رمز ارز...',
      queryStyle: const TextStyle(color: Colors.black),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      width: isPortrait ? MediaQuery.of(context).size.width * 0.9 : 700,
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 300),
      onQueryChanged: (query) {
        print('Query changed: $query'); // دیباگ
        widget.onQueryChanged(query);
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [FloatingSearchBarAction.searchToClear(showIfClosed: false)],
      builder: (context, _) {
        final query = _controller.query.toLowerCase();
        final filteredItems =
            query.isEmpty
                ? widget.arz
                : widget.arz
                    .where(
                      (item) =>
                          (item.title ?? '').toLowerCase().contains(query),
                    )
                    .toList();

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child:
                filteredItems.isEmpty
                    ? const ListTile(title: Text('هیچ نتیجه‌ای یافت نشد'))
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = widget.selectedItem.contains(item);

                        return ListTile(
                          title: Text(
                            item.title ?? 'بدون عنوان',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              color: isSelected ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              widget.onItemToggled(item, isSelected);
                              showSnackBar(
                                context,
                                isSelected
                                    ? 'آیتم از لیست انتخاب حذف شد'
                                    : 'آیتم به لیست انتخاب اضافه شد',
                              );
                            },
                          ),
                          onTap: () {
                            widget.onItemSelected(item);
                            _controller.close();
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
