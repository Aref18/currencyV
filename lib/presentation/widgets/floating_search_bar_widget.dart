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
      queryStyle: const TextStyle(color: Colors.black, fontSize: 16),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      width: isPortrait ? MediaQuery.of(context).size.width * 0.9 : 700,
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 300),
      automaticallyImplyBackButton: false,
      onQueryChanged: (query) {
        print('Query changed: $query'); // دیباگ
        widget.onQueryChanged(query);
        setState(() {
          if (query.isNotEmpty) {
            _controller.open(); // باز کردن پاپ‌آپ فقط وقتی query غیرخالی است
          } else {
            _controller.close(); // بستن پاپ‌آپ وقتی query خالی است
          }
        });
      },
      onFocusChanged: (isFocused) {
        if (!isFocused && _controller.query.isEmpty) {
          _controller
              .close(); // بستن پاپ‌آپ وقتی فوکوس از دست می‌رود و query خالی است
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [FloatingSearchBarAction.searchToClear(showIfClosed: false)],
      builder: (context, _) {
        final query = _controller.query.toLowerCase();
        if (query.isEmpty) {
          return const SizedBox.shrink(); // هیچ چیز نمایش داده نشود وقتی query خالی است
        }

        final filteredItems =
            widget.arz
                .where(
                  (item) => (item.title ?? '').toLowerCase().contains(query),
                )
                .toList();

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child:
                filteredItems.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'هیچ نتیجه‌ای یافت نشد',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = widget.selectedItem.contains(item);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: CircleAvatar(
                            radius: 16,
                            child: Image(
                              image: NetworkImage(
                                item.imageUrl ??
                                    'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item.title ?? 'بدون عنوان',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            item.price ?? '0',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
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
