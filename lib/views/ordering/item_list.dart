import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart';
import '../item_detail.dart';

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
  Map _selectedItems = {};

  void _showAttribute(item) async {
    // print(items.attributes[0].label);

    final Map? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(item: item);
      },
    );

    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
              padding: EdgeInsets.only(right: 15.0),
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
  final item;
  const MultiSelect({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final Map _selectedItems = {};

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    print(_selectedItems);
    context.read<CartProvider>().addToCart(widget.item);
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item.name),
      content: Builder(builder: (context) {
        // Get available height and width of the build area of this widget. Make a choice depending on the size.
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return Container(
            height: height - 400,
            width: width - 400,
            child: Column(children: [
              ...widget.item.attributes
                  .map((item) => Column(
                        children: [
                          Text(
                            item.label,
                            textAlign: TextAlign.left,
                          ),
                          Row(
                            children: [
                              ...item.options
                                  .map((option) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ChoiceChip(
                                          avatar: CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.shade800,
                                            child: Text(option.label),
                                          ),
                                          label: Text(
                                              "\$${(option.extra / 100).toString()}"),
                                          selectedColor:
                                              Colors.orangeAccent.withAlpha(39),
                                          selectedShadowColor:
                                              Colors.orangeAccent,
                                          elevation: 3,
                                          selected:
                                              _selectedItems[item.label] ==
                                                  option.label,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              _selectedItems[item.label] =
                                                  selected
                                                      ? option.label
                                                      : null;
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
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Color(0xFFC88D67)),
                    child: Text(
                      "+ 加入購物車",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ]));
      }),
      // actions: [
      //   TextButton(
      //     onPressed: _cancel,
      //     child: const Text('取消'),
      //   ),
      //   ElevatedButton(
      //     onPressed: _submit,
      //     child: const Text('確認'),
      //   ),
      // ],
    );
  }
}

Widget _buildCard(context, item, _showAttribute) {
  return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
          onTap: () {
            _showAttribute(item);
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => ItemDetail(
            //         assetPath: imgPath,
            //         cookieprice: price,
            //         cookiename: name)));
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
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Icon(Icons.add, color: Color(0xFFC88D67))])),
                Hero(
                    tag: '',
                    child: Container(
                      height: 75.0,
                      // width: 175.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/favicon.png'),
                            // NetworkImage(item.images),
                            // image: AssetImage('images/favicon.png'),
                            // fit: BoxFit.cover,
                            onError: (err, stackTrace) =>
                                AssetImage('images/favicon.png')),
                        // image: DecorationImage(
                        //     image: AssetImage(imgPath),
                        //     fit: BoxFit.contain)
                      ),
                      // child: Hero(
                      //   tag: name,
                      //   child: Image.asset(imgPath),
                      // ),
                    )),
                SizedBox(height: 7.0),
                Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 55.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(item.name,
                            style: TextStyle(
                                color: Color(0xFF575E67), fontSize: 12.0)),
                      ),
                      Spacer(),
                      Expanded(
                        child: Text("\$${(item.pricing / 100).toString()}",
                            style: TextStyle(
                                color: Color(0xFFCC8053), fontSize: 12.0)),
                      ),
                    ],
                  ),
                )
              ]))));
}
