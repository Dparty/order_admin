import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/models/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:order_admin/provider/shopping_cart_provider.dart';

class OptionSelect extends StatefulWidget {
  final Item item;
  const OptionSelect({Key? key, required this.item}) : super(key: key);

  @override
  State<OptionSelect> createState() => _OptionSelectState();
}

class _OptionSelectState extends State<OptionSelect> {
  Map<String, String> selectedItems = {};
  double tmpPrice = 0;

  @override
  void initState() {
    super.initState();
    tmpPrice = widget.item.pricing.toDouble() / 100;
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    CartItem cartItem = CartItem(
      item: widget.item,
      initialPrice: widget.item.pricing.toDouble(),
      productPrice: widget.item.pricing.toDouble(),
      quantity: 1,
      unitTag: '1',
      selectedItems: selectedItems,
    );
    context.read<CartProvider>().addToCart(cartItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item.name),
      content: Builder(builder: (context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return Container(
            height: height - 400,
            width: width - 400,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...widget.item.attributes
                      .asMap()
                      .entries
                      .map((entry) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.value.label,
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                children: [
                                  ...entry.value.options
                                      .map((option) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ChoiceChip(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              label: Text(
                                                  "${option.label}  +\$${(option.extra / 100).toString()}"),
                                              selectedColor: Colors.orangeAccent
                                                  .withAlpha(39),
                                              selectedShadowColor:
                                                  Colors.orangeAccent,
                                              elevation: 3,
                                              selected: selectedItems[
                                                      entry.value.label] ==
                                                  option.label,
                                              onSelected: (bool selected) {
                                                setState(() {
                                                  if (selectedItems[
                                                          entry.value.label] ==
                                                      option.label) {
                                                    selectedItems.remove(
                                                        entry.value.label);
                                                  } else {
                                                    selectedItems[entry.value
                                                        .label] = option.label;
                                                  }
                                                  tmpPrice =
                                                      (widget.item.pricing! /
                                                              100) +
                                                          (option.extra / 100)
                                                              .toDouble();
                                                });
                                              },
                                            ),
                                          ))
                                      .toList()
                                ],
                              )
                            ],
                          ))
                      .toList(),
                  Row(
                    children: [
                      Expanded(child: Text("價格：${tmpPrice}")),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _cancel,
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.grey),
                            child: const Text(
                              "取消",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: kPrimaryColor),
                            child: const Text(
                              "+ 加入購物車",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ]));
      }),
    );
  }
}
