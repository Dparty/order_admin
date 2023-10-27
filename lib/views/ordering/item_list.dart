import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/models/model.dart';
import 'package:order_admin/models/restaurant.dart';
import '../item_detail.dart';
import 'package:order_admin/models/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:order_admin/provider/shopping_cart_provider.dart';

class ItemListView extends StatefulWidget {
  final List<Item>? itemList;
  Item? selectedItem;

  ItemListView({Key? key, required this.itemList}) : super(key: key);

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  // Map selectedItems = {};
  List selectedItems = [];

  void _showAttribute(item) async {
    final List? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(item: item);
      },
    );

    if (results != null) {
      setState(() {
        selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 15.0),
          Container(
              padding: const EdgeInsets.only(right: 15.0),
              width: MediaQuery.of(context).size.width - 30.0,
              height: MediaQuery.of(context).size.height - 50.0,
              child:
                  GridView.count(crossAxisCount: 3, primary: false, children: [
                ...widget.itemList!
                    .map(
                      (item) => _buildCard(context, item, _showAttribute),
                    )
                    .toList()
              ])),
          const SizedBox(height: 15.0)
        ],
      ),
    );
  }
}

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final Item item;
  const MultiSelect({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  Map<String, String> selectedItems = {};

  @override
  void initState() {
    super.initState();
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
                                              // avatar: CircleAvatar(
                                              //   backgroundColor:
                                              //       Colors.grey.shade800,
                                              //   child: Text(option.label),
                                              // ),
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
                      Expanded(child: Text("價格：${widget.item.pricing! / 100}")),
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

Widget _buildCard(context, item, _showAttribute) {
  return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
          onTap: () {
            _showAttribute(item);
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3.0,
                        blurRadius: 5.0)
                  ],
                  color: Colors.white),
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: FadeInImage(
                        image: NetworkImage(
                          item.images.isEmpty ? '' : item.images[0],
                        ),
                        fit: BoxFit.fitWidth,
                        placeholder: const AssetImage("images/default.png"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "images/default.png",
                            width: 100,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(item.name,
                                style: const TextStyle(
                                    color: Color(0xFF575E67), fontSize: 12.0)),
                          ),
                          // const Spacer(),
                          Expanded(
                            child: Text("\$${(item.pricing / 100).toString()}",
                                style: const TextStyle(
                                    color: Color(0xFFCC8053), fontSize: 12.0)),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ]))));
}
