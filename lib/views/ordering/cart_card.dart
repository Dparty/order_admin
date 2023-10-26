import 'package:flutter/material.dart';
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
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: FadeInImage(
                image: NetworkImage(item.image!),
                placeholder: AssetImage("images/default.png"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset("images/default.png",
                      fit: BoxFit.fitWidth);
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.productName!,
              style: TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "\$${(item.productPrice! / 100).toString()}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Color(0xFFFF7643)),
                    children: [
                      // TextSpan(
                      //     text: " x${cart.numOfItem}",
                      //     style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => {
                              [
                                provider.deleteQuantity(item.id ?? ''),
                              ]
                            },
                        icon: const Icon(Icons.remove)),
                    Text(item.quantity!.value.toString()),
                    IconButton(
                        onPressed: () => {
                              [
                                provider.addQuantity(item.id ?? ''),
                              ]
                            },
                        icon: const Icon(Icons.add)),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      provider.removeItem(item.id ?? '');
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
