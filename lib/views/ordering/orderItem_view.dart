import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';

// providers
import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/selected_table_provider.dart';

// components
import 'package:order_admin/views/components/default_layout.dart';
import 'package:order_admin/views/components/item_card_list.dart';
import './shopping_cart.dart';
import './options_select.dart';

class OrderItem extends StatefulWidget {
  OrderItem({super.key});
  List shoppingList = [];
  int tabListLength = 0;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
  }

  void onTapCallback(item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OptionSelect(item: item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context.watch<RestaurantProvider>();
    _tabController =
        TabController(length: restaurant.itemsMap.keys.length + 1, vsync: this);

    return DefaultLayout(
        center: ListView(
          padding: const EdgeInsets.only(left: 20.0),
          children: <Widget>[
            const SizedBox(height: 15.0),
            Row(
              children: [
                Text('餐廳名稱：${context.read<RestaurantProvider>().name}'),
                const SizedBox(width: 10),
                Text(
                    '餐桌號：${context.read<SelectedTableProvider>().selectedTable?.label}')
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 8,
                    child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.transparent,
                        labelColor: kPrimaryColor,
                        isScrollable: true,
                        labelPadding: const EdgeInsets.only(right: 45.0),
                        unselectedLabelColor: Color(0xFFCDCDCD),
                        tabs: [
                          const Tab(
                            child: Text('所有品項',
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                          ),
                          ...restaurant.itemsMap.keys.map(
                            (label) => Tab(
                              child: Text(label,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  )),
                            ),
                          )
                        ])),
              ],
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height - 180.0,
                child: TabBarView(controller: _tabController, children: [
                  ItemCardListView(
                    itemList: restaurant.items,
                    crossAxisCount: 3,
                    onTap: onTapCallback,
                  ),
                  ...restaurant.itemsMap.keys.map(
                    (label) => ItemCardListView(
                      itemList: restaurant.itemsMap[label]?.toList(),
                      crossAxisCount: 3,
                      onTap: onTapCallback,
                    ),
                  )
                ]))
          ],
        ),
        centerTitle: '點餐',
        right: const ShoppingCart());
  }
}
