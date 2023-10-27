import 'package:flutter/material.dart';
import 'package:order_admin/views/restaurantSettingsPage.dart';
import 'navbar_item.dart';
import '../../main.dart';
import '../../api/utils.dart';
import '../restaurantPage.dart';
import 'package:order_admin/views/ordering/orderingPage.dart';

// providers
import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/selected_table_provider.dart';
import 'package:order_admin/provider/shopping_cart_provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key, this.navIndex, this.onTap}) : super(key: key);

  final int? navIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 20, 12, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              DrawerItem(
                name: '餐廳列表',
                icon: Icons.list,
                onPressed: () => onItemPressed(context, index: 0),
              ),
              const SizedBox(
                height: 20,
              ),
              DrawerItem(
                name: '點餐',
                icon: Icons.restaurant_rounded,
                onPressed: () => onItemPressed(context, index: 1),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: '品項設置',
                  icon: Icons.settings,
                  onPressed: () =>
                      onItemPressed(context, index: 2, onTap: onTap)),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: '餐廳設置',
                  icon: Icons.restaurant,
                  onPressed: () =>
                      onItemPressed(context, index: 3, onTap: onTap)),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: '打印機設置',
                  icon: Icons.print,
                  onPressed: () =>
                      onItemPressed(context, index: 4, onTap: onTap)),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: '登出',
                  icon: Icons.logout,
                  onPressed: () => onItemPressed(context, index: 5)),
            ],
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context,
      {required int index, Function? onTap}) {
    final restaurant = context.read<RestaurantProvider>();

    Navigator.pop(context);

    switch (index) {
      case 0:
        context.read<RestaurantProvider>().resetRestaurant();
        context.read<CartProvider>().resetShoppingCart();
        context.read<SelectedTableProvider>().resetSelectTable();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RestaurantsPage()));
        break;
      case 1:
        context.read<CartProvider>().resetShoppingCart();
        context.read<SelectedTableProvider>().resetSelectTable();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderingPage(restaurant.id)));
        break;
      case 2:
        context.read<CartProvider>().resetShoppingCart();
        context.read<SelectedTableProvider>().resetSelectTable();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RestaurantSettingsPage(restaurantId: restaurant.id)));
        break;
      case 4:
        context.read<CartProvider>().resetShoppingCart();
        context.read<SelectedTableProvider>().resetSelectTable();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RestaurantSettingsPage(
                    restaurantId: restaurant.id, selectedNavIndex: 1)));
        break;
      case 5:
        (() {
          signout().then((_) {
            context.read<RestaurantProvider>().resetRestaurant();
            context.read<CartProvider>().resetShoppingCart();
            context.read<SelectedTableProvider>().resetSelectTable();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          });
        })();
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
    }
  }

  Widget headerWidget() {
    const url =
        'https://media.istockphoto.com/photos/learn-to-love-yourself-first-picture-id1291208214?b=1&k=20&m=1291208214&s=170667a&w=0&h=sAq9SonSuefj3d4WKy4KzJvUiLERXge9VgZO-oqKUOo=';
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(url),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Person name',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            SizedBox(
              height: 10,
            ),
            Text('person@email.com',
                style: TextStyle(fontSize: 14, color: Colors.white))
          ],
        )
      ],
    );
  }
}
