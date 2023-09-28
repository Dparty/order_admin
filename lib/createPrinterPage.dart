import 'package:flutter/material.dart';

import 'api/restaurant.dart';

class CreatePrinterPage extends StatefulWidget {
  final String restaurantId;

  const CreatePrinterPage(
    this.restaurantId, {
    super.key,
  });

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _CreatePrinterPageState(restaurantId);
}

const List<String> printerTypeEnum = <String>[('BILL'), 'KITCHEN'];

class _CreatePrinterPageState extends State<CreatePrinterPage> {
  final String restaurantId;
  _CreatePrinterPageState(this.restaurantId);

  String printerType = printerTypeEnum.first;
  final name = TextEditingController();
  final sn = TextEditingController();

  void create() {
    createPrinter(restaurantId, name.text, sn.text, printerType).then((value) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增打印機'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                hintText: '打印機名稱',
              ),
            ),
            TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: sn,
              decoration: const InputDecoration(
                hintText: 'SN編號',
              ),
            ),
            DropdownButton<String>(
              value: printerType,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  printerType = value!;
                });
              },
              items:
                  printerTypeEnum.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: create,
                child: const Text('創建'),
              ),
            ),
          ])),
    );
  }
}
