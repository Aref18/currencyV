import 'package:currencyv/core/utils/snackbar_utils.dart';
import 'package:currencyv/data/model/arz.dart';
import 'package:flutter/material.dart';

class CurrencyItemWidget extends StatelessWidget {
  final int index;
  final List<Arzcurrency> arz;
  final bool isFocused;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CurrencyItemWidget({
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
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Transform.scale(
          scale: isFocused ? 1.1 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              boxShadow: const <BoxShadow>[
                BoxShadow(blurRadius: 1.0, color: Colors.purple),
              ],
              color: isFocused ? Colors.grey[800] : Colors.black,
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            child: Image(
                              image: NetworkImage(
                                "https://cryptologos.cc/logos/bitcoin-btc-logo.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              arz[index].title!,
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          arz[index].price!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                if (isFocused)
                  Positioned(
                    top: 110,
                    right: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        onDelete?.call();
                        showSnackBar(context, 'آیتم حذف شد');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(60, 30),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      child: const Text('حذف'),
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
