import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/views/settings/create_item_page.dart';
import 'package:order_admin/views/components/main_layout.dart';
import 'package:order_admin/views/settings/item_info.dart';
import 'package:order_admin/api/restaurant.dart';

import 'package:order_admin/components/dialog.dart';
// providers
import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/selected_item_provider.dart';
import 'package:order_admin/provider/selected_table_provider.dart';

// components
import 'package:order_admin/views/components/item_card_list.dart';

class ConfigItem extends StatefulWidget {
  ConfigItem({super.key});
  List shoppingList = [];
  int tabListLength = 0;

  @override
  State<ConfigItem> createState() => _ConfigItemState();
}

class _ConfigItemState extends State<ConfigItem> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context.watch<RestaurantProvider>();
    _tabController =
        TabController(length: restaurant.itemsMap.keys.length + 1, vsync: this);

    void onClickItem(item) {
      context.read<SelectedItemProvider>().setItem(item);
    }

    return MainLayout(
      centerTitle: "品項設置",
      center: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 20.0),
        children: <Widget>[
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('餐廳名稱：${context.read<RestaurantProvider>().name}'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: SizedBox(
                  height: 30,
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC88D67),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateItemPage(
                              restaurant.id,
                            ),
                          ));
                    },
                    child: const Text("新增品項"),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 8,
                  child: TabBar(
                      controller: _tabController,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      indicatorColor: Colors.transparent,
                      labelColor: kPrimaryColor,
                      isScrollable: true,
                      labelPadding: EdgeInsets.only(right: 45.0),
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
                  onTap: onClickItem,
                ),
                ...restaurant.itemsMap.keys.map(
                  (label) => ItemCardListView(
                    itemList: restaurant.itemsMap[label]?.toList(),
                    crossAxisCount: 3,
                    //todo
                    onTap: onClickItem,
                  ),
                )
              ]))
        ],
      ),
      right: EditItemPage(
          item: context.watch<SelectedItemProvider>().selectedItem,
          reload: () => getRestaurant(restaurant.id).then((restaurant) {
                context.read<RestaurantProvider>().setRestaurant(
                    restaurant.id,
                    restaurant.name,
                    restaurant.description,
                    restaurant.items,
                    restaurant.tables);
                context.read<SelectedItemProvider>().resetSelectItem();
              })),
    );
  }
}
