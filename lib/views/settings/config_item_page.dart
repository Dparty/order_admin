import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/views/components/main_layout.dart';
import 'package:order_admin/views/settings/item_info.dart';
import 'package:order_admin/api/restaurant.dart';

// providers
import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/selected_item_provider.dart';

// components
import 'package:order_admin/views/components/item_card_list.dart';

class ConfigItem extends StatefulWidget {
  ConfigItem({super.key});
  List shoppingList = [];
  int tabListLength = 0;
  int lastIndex = 0;

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
    _tabController = TabController(
        length: restaurant.itemsMap.keys.length + 1,
        initialIndex: widget.lastIndex,
        vsync: this);
    _tabController?.addListener(() {
      setState(() {
        widget.lastIndex = _tabController!.index;
      });
    });

    void onClickItem(item) {
      context.read<SelectedItemProvider>().setItem(item);
    }

    return MainLayout(
      centerTitle: "品項設置",
      center: ListView(
        physics: const NeverScrollableScrollPhysics(),
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
                      context.read<SelectedItemProvider>().resetSelectItem();
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
                      labelPadding: const EdgeInsets.only(right: 45.0),
                      unselectedLabelColor: const Color(0xFFCDCDCD),
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
                  type: PageType.CONFIG.name,
                ),
                ...restaurant.itemsMap.keys.map(
                  (label) => ItemCardListView(
                    itemList: restaurant.itemsMap[label]?.toList(),
                    crossAxisCount:
                        3, //crossAxisCount: (MediaQuery.of(context).size.width ~/ 350).toInt(),
                    type: PageType.CONFIG.name,
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
