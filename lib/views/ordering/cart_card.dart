import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/models/cart_item.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/provider/shopping_cart_provider.dart';
import 'package:provider/provider.dart';

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.productName!,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "\$${(item.price! / 100).toString()}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                    children: [
                      // TextSpan(
                      //     text: " x${cart.numOfItem}",
                      //     style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: kPrimaryColor
                          // padding: const EdgeInsets.all(30)
                          ),
                      child: const Icon(
                        Icons.remove,
                        // size: 50,
                      ),
                      onPressed: () {
                        provider.removeItem(item);
                      },
                    ),
                    Text(item.quantity.toString()),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: kPrimaryColor),
                      child: const Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        provider.addQuantity(item);
                      },
                    ),
                  ],
                ),
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
    );
  }
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
      required this.addQuantity,
      required this.deleteQuantity,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: deleteQuantity, icon: const Icon(Icons.remove)),
        Text(text),
        IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
      ],
    );
  }
}
