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
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1E1E), Color(0xFF2F4F4F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(16),
              border:
                  isFocused
                      ? Border.all(color: const Color(0xFFFFA500), width: 2)
                      : null, // نارنجی برای کارت انتخاب شده
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.transparent,
                            child: Image(
                              image: NetworkImage(
                                arz[index].imageUrl ??
                                    "https://cryptologos.cc/logos/bitcoin-btc-logo.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              arz[index].title ?? 'بدون عنوان',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.copyWith(fontSize: 19),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            arz[index].price ?? '0',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(fontSize: 22),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            arz[index].changes ?? '0',
                            style:
                                arz[index].status == "n"
                                    ? Theme.of(context).textTheme.headlineSmall!
                                        .copyWith(color: Colors.redAccent)
                                    : Theme.of(context).textTheme.headlineLarge!
                                        .copyWith(color: Color(0xFF00C853)),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            arz[index].status == "n"
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color:
                                arz[index].status == "n"
                                    ? Colors.redAccent
                                    : const Color(0xFF00C853),
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isFocused)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500), // نارنجی مدرن
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          onDelete?.call();
                          showSnackBar(context, 'آیتم حذف شد');
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'حذف',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
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
