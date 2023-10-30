import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/bill.dart';
import 'package:collection/collection.dart';

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

  CheckBillsView({Key? key, this.table}) : super(key: key);

  @override
  State<CheckBillsView> createState() => _CheckBillsViewState();
}

class _CheckBillsViewState extends State<CheckBillsView> {
  // bool _isSelected = false;
  List<bool> _isSelected = [];

  // void initState() {
  //   super.initState();
  //   _isSelected = List.filled(widget.orders?.length ?? 0, true);
  // }

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
      body: Center(
          child: SingleChildScrollView(
        child: _isSelected.length != 0
            ? Column(
                children: [
                  ...?bills?.mapIndexed(
                    (index, order) => BillCheckbox(
                      label: order.pickUpCode.toString(),
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
              )
            : Container(),
      )),
    );
  }
}
