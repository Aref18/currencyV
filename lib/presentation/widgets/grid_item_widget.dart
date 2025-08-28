import 'package:currencyv/core/utils/snackbar_utils.dart';
import 'package:currencyv/data/model/arz.dart';
import 'package:flutter/material.dart';

class GridItemWidget extends StatelessWidget {
  final int index;
  final List<Arzcurrency> arz;
  final bool isFocused;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const GridItemWidget({
    super.key,
    required this.index,
    required this.arz,
    this.isFocused = false,
    this.onLongPress,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const <BoxShadow>[
                BoxShadow(blurRadius: 1.0, color: Colors.purple),
              ],
              color: isFocused ? Colors.grey[800] : Colors.grey[800],
              border:
                  isFocused
                      ? Border.all(
                        color: const Color.fromARGB(255, 182, 23, 12),
                        width: 2,
                      )
                      : null,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            child: Image(
                              image: NetworkImage(
                                "https://cryptologos.cc/logos/bitcoin-btc-logo.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              arz[index].title!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.copyWith(fontSize: 19),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              arz[index].price!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.copyWith(fontSize: 22),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              arz[index].changes!,
                              style:
                                  arz[index].status == "n"
                                      ? Theme.of(
                                        context,
                                      ).textTheme.headlineSmall
                                      : Theme.of(
                                        context,
                                      ).textTheme.headlineLarge,
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              arz[index].status == "n"
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color:
                                  arz[index].status == "n"
                                      ? Colors.red
                                      : Colors.green,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isFocused)
                  Positioned(
                    bottom: 6, // پایین سمت چپ
                    left: 6,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          onDelete?.call();
                          showSnackBar(context, 'آیتم حذف شد');
                        },
                        child: Center(
                          child: const Text(
                            'حذف',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
