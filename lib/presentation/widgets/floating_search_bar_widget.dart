import 'package:currencyv/data/model/arz.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class FloatingSearchBarWidget extends StatefulWidget {
  final List<Arzcurrency> arz;
  final List<Arzcurrency> selectedItem;
  final Function(String) onQueryChanged;
  final Function(Arzcurrency) onItemSelected;

  const FloatingSearchBarWidget({
    super.key,
    required this.arz,
    required this.selectedItem,
    required this.onQueryChanged,
    required this.onItemSelected,
    required bool Function(dynamic item) isItemSelected,
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
      physics: const BouncingScrollPhysics(),
      width: isPortrait ? MediaQuery.of(context).size.width * 0.9 : 700,
      debounceDelay: const Duration(milliseconds: 300),
      automaticallyImplyBackButton: false,
      onQueryChanged: (query) {
        widget.onQueryChanged(query);
        setState(() {
          if (query.isNotEmpty) {
            _controller.open();
          } else {
            _controller.close();
          }
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [FloatingSearchBarAction.searchToClear(showIfClosed: false)],
      builder: (context, _) {
        final query = _controller.query.toLowerCase();
        if (query.isEmpty) return const SizedBox.shrink();

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
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(item.price ?? '0'),
                          trailing: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.add_circle_outline,
                            color: isSelected ? Colors.green : Colors.grey,
                          ),
                          onTap: () {
                            if (!isSelected) widget.onItemSelected(item);
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
