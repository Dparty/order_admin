import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/models/cart_item.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/provider/shopping_cart_provider.dart';
import 'package:provider/provider.dart';

// components
import 'package:order_admin/components/plusMinus_buttons.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

  final CartItem item;
  final index;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CartProvider>();

    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: FadeInImage(
                image: NetworkImage(item.image!),
                placeholder: const AssetImage("images/default.png"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset("images/default.png",
                      fit: BoxFit.fitWidth);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName!,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Text(
                  "${item.selectedItems.toString()}",
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("價格：${item.price! / 100}")),
                    Row(
                      children: [
                        PlusMinusButtons(
                            addQuantity: () => {provider.addQuantity(item)},
                            deleteQuantity: () => {provider.removeItem(item)},
                            text: item.quantity.toString()),
                        IconButton(
                            onPressed: () {
                              provider.deleteQuantity(item);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade800,
                            )),
                      ],
                    )
                  ],
                )
              ],
            )),
      ],
    );
  }
}
