import 'package:flutter/material.dart';
import 'package:order_admin/createPrinterPage.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/views/printers_list.dart';
import 'package:provider/provider.dart';
import 'cookie_page.dart';
import 'package:order_admin/provider/restaurant_provider.dart';

class ConfigPrinter extends StatefulWidget {
  const ConfigPrinter({super.key});

  @override
  _ConfigPrinterState createState() => _ConfigPrinterState();
}

class _ConfigPrinterState extends State<ConfigPrinter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context.watch<RestaurantProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {},
        ),
        title: const Text('打印機設置',
            style: TextStyle(fontSize: 20.0, color: Color(0xFF545D68))),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 20.0),
        children: <Widget>[
          SizedBox(height: 15.0),
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
                      backgroundColor: Color(0xFFC88D67),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreatePrinterPage(restaurant.id),
                          ));
                    },
                    child: const Text("新增打印機"),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height - 50.0,
            width: double.infinity,
            child: PrintersListView(printersList: restaurant.printers),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(0xFFF17532),
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      // bottomNavigationBar: BottomBar(),
    );
  }
}
