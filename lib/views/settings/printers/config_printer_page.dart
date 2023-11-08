import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/provider/selected_printer_provider.dart';
import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';

import 'package:order_admin/views/components/main_layout.dart';
import 'package:order_admin/views/settings/printers/printers_list.dart';
import 'package:order_admin/views/settings/printers/create_printer_page.dart';

class ConfigPrinter extends StatefulWidget {
  const ConfigPrinter({super.key});

  @override
  State<ConfigPrinter> createState() => _ConfigPrinterState();
}

class _ConfigPrinterState extends State<ConfigPrinter> {
  // Printer? _selectedPrinter;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context.watch<RestaurantProvider>();

    void setSelectedPrinter(printer) {
      context.read<SelectedPrinterProvider>().setPrinter(printer);
    }

    return MainLayout(
      centerTitle: "打印機設置",
      center: ListView(
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
                      context
                          .read<SelectedPrinterProvider>()
                          .resetSelectPrinter();
                    },
                    child: const Text("新增打印機"),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 150.0,
            width: double.infinity,
            child: PrintersListView(
              printersList: restaurant.printers,
              reload: () =>
                  listPrinters(restaurant.id).then((list) => setState(() {
                        context
                            .read<RestaurantProvider>()
                            .setRestaurantPrinter(list.data);
                      })),
              onTap: setSelectedPrinter,
            ),
          )
        ],
      ),
      right: CreatePrinterPage(
        restaurant.id,
        reload: () => listPrinters(restaurant.id).then((list) => setState(() {
              context
                  .read<RestaurantProvider>()
                  .setRestaurantPrinter(list.data);
            })),
        automaticallyImplyLeading: false,
        // printer: context.watch<SelectedPrinterProvider>().selectedPrinter,
      ),
    );
  }
}
