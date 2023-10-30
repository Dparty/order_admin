import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/api/bill.dart';
import 'package:order_admin/components/dialog.dart';
import 'orderItem_page.dart';

// models
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/bill.dart';

// providers
import 'package:provider/provider.dart';
import 'package:order_admin/provider/selected_table_provider.dart';

class BillCheckbox extends StatelessWidget {
  const BillCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBillsView extends StatefulWidget {
  final model.Table? table;

  const CheckBillsView({Key? key, this.table}) : super(key: key);

  @override
  State<CheckBillsView> createState() => _CheckBillsViewState();
}

class _CheckBillsViewState extends State<CheckBillsView> {
  List<bool> _isSelected = [];

  @override
  void didChangeDependencies() {
    _isSelected = List.filled(
        context.watch<SelectedTableProvider>().tableOrders?.length ?? 0, true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Bill>? bills = context.watch<SelectedTableProvider>().tableOrders;

    return Scaffold(
        appBar: AppBar(title: const Text('訂單列表')),
        body: _isSelected.length == 0
            ? Center(
                child: Column(
                children: [
                  Text("暫無訂單"),
                  Container(
                      width: MediaQuery.of(context).size.width - 1000.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: kPrimaryColor),
                      child: InkWell(
                        onTap: () {
                          if (widget.table == null) {
                            showAlertDialog(context, "請選擇桌號");
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderItem()));
                        },
                        child: const Center(
                            child: Text(
                          '前往點單',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ))
                ],
              ))
            : Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    children: [
                      ...?bills?.mapIndexed(
                        (index, order) => BillCheckbox(
                          label: "取餐號：${order.pickUpCode.toString()}",
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          value: _isSelected[index],
                          onChanged: (bool newValue) {
                            setState(() {
                              _isSelected?[index] = newValue;
                            });
                          },
                        ),
                      )
                    ],
                  ))),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          height: 35.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: kPrimaryColor),
                          child: InkWell(
                            onTap: () async {
                              if (_isSelected
                                  .every((element) => element == false)) {
                                showAlertDialog(context, "請勾選需要打印的訂單");
                                return;
                              }

                              List<String> billIdList = [];
                              for (int i = 0; i < _isSelected.length; i++) {
                                if (_isSelected[i] == true) {
                                  billIdList.add(bills![i].id);
                                }
                              }
                              await printBills(billIdList, 0).then((e) => {});
                            },
                            child: const Center(
                                child: Text(
                              '打印訂單',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 35.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: kPrimaryColor),
                          child: InkWell(
                            onTap: () async {
                              if (_isSelected
                                  .every((element) => element == false)) {
                                showAlertDialog(context, "請勾選需要打印的訂單");
                                return;
                              }

                              List<String> billIdList = [];
                              for (int i = 0; i < _isSelected.length; i++) {
                                if (_isSelected[i] == true) {
                                  billIdList.add(bills![i].id);
                                }
                              }
                              await setBills(billIdList, 0, 'PAIED')
                                  .then((e) => {});
                            },
                            child: const Center(
                                child: Text(
                              '完成訂單',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ));
  }
}
