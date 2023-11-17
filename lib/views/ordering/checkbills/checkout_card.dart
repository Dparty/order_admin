import 'package:flutter/material.dart';
import 'package:order_admin/views/components/default_button.dart';

class CheckoutCard extends StatelessWidget {
  final Function? onPressed;
  String totalPrice;

  CheckoutCard({
    Key? key,
    required this.totalPrice,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5, //getProportionateScreenWidth(15),
        horizontal: 15,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), //getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "合計:\n",
                    children: [
                      TextSpan(
                        text: totalPrice,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100, //getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "確定",
                    press: onPressed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
