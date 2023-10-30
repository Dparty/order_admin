import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'orderItem_page.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/order.dart';
import 'package:order_admin/models/bill.dart';
import 'check_bills.dart';

class OrderDetail extends StatelessWidget {
  final String? label;
  final model.Table? table;
  final List<Bill>? orders;

  OrderDetail({Key? key, this.label, this.table, this.orders})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text('點單信息',
            style: TextStyle(fontSize: 20.0, color: Color(0xFF545D68))),
      ),
      body: ListView(children: [
        const SizedBox(height: 30.0),
        Center(
          child: Text(table != null ? table!.label : "請選擇桌號",
              style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor)),
        ),
        const SizedBox(height: 10.0),
        (orders == null)
            ? const Center(
                child: Text('暫無點餐信息',
                    style: TextStyle(color: Color(0xFF575E67), fontSize: 12.0)),
              )
            : Column(
                children: [...?orders?.map((item) => Text(item.id))],
              ),
        const SizedBox(height: 20.0),
        Center(
            child: Container(
                width: MediaQuery.of(context).size.width - 1000.0,
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: kPrimaryColor),
                child: InkWell(
                  onTap: () {
                    if (table == null) {
                      showAlertDialog(context, "請選擇桌號");
                      return;
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OrderItem()));
                  },
                  child: const Center(
                      child: Text(
                    '前往點單',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                )))
      ]),
    );
  }
}
