import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart';
import './item_card.dart';

class ItemCardListView extends StatefulWidget {
  final List<Item>? itemList;
  int crossAxisCount = 3;
  Item? selectedItem;
  Function? onTap;
  String? type = 'order'; // order or config

  ItemCardListView({
    Key? key,
    required this.itemList,
    required this.crossAxisCount,
    this.onTap,
    this.type,
  }) : super(key: key);

  @override
  State<ItemCardListView> createState() => _ItemCardListViewState();
}

class _ItemCardListViewState extends State<ItemCardListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: ListView(
        physics: const PageScrollPhysics(),
        children: <Widget>[
          const SizedBox(height: 15.0),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              width: MediaQuery.of(context).size.width - 30.0,
              height: MediaQuery.of(context).size.height - 210.0,
              child: GridView.count(
                  physics: const PageScrollPhysics(),
                  crossAxisCount: widget.crossAxisCount,
                  primary: false,
                  children: [
                    ...widget.itemList!
                        .map((item) => itemCard(item, onTap: () {
                              widget.onTap!(item);
                            }, type: widget.type))
                        .toList()
                  ])),
          const SizedBox(height: 15.0)
        ],
      ),
    );
  }
}
