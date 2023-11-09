import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/models/restaurant.dart';
import './item_card.dart';

class ItemCardListView extends StatefulWidget {
  final List<Item>? itemList;
  int crossAxisCount = 3;
  Item? selectedItem;
  Function? onTap;

  ItemCardListView(
      {Key? key,
      required this.itemList,
      required this.crossAxisCount,
      this.onTap})
      : super(key: key);

  @override
  State<ItemCardListView> createState() => _ItemCardListViewState();
}

class _ItemCardListViewState extends State<ItemCardListView> {
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
              child: GridView.count(
                  crossAxisCount: widget.crossAxisCount,
                  primary: false,
                  children: [
                    ...widget.itemList!
                        .map((item) => itemCard(context, item, onTap: () {
                              widget.onTap!(item);
                            }))
                        .toList()
                  ])),
          const SizedBox(height: 15.0)
        ],
      ),
    );
  }
}
