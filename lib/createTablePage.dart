import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart';

import 'api/restaurant.dart';

class CreateTablePage extends StatefulWidget {
  final String restaurantId;
  const CreateTablePage(this.restaurantId, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _CreateTablePageState(restaurantId);
}

class _CreateTablePageState extends State<CreateTablePage> {
  final String restaruantId;
  final label = TextEditingController();

  _CreateTablePageState(this.restaruantId);

  void create() {
    createTable(restaruantId, label.text).then((table) {
      Navigator.pop(context, table);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('新增餐桌'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: label,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '輸入餐桌標籤',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '請輸入餐桌標籤';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: create,
                child: const Text('創建'),
              ),
            ),
          ],
        ),
      ));
}
