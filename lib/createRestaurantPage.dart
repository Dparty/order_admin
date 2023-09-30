import 'package:flutter/material.dart';

import 'api/restaurant.dart';

class CreateRestaurantPage extends StatefulWidget {
  const CreateRestaurantPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateRestaurantPageState();
}

class _CreateRestaurantPageState extends State<CreateRestaurantPage> {
  final name = TextEditingController();
  final description = TextEditingController();
  create() {
    createRestaurant(name.text, description.text)
        .then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('創建餐廳'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                hintText: '名稱',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '請輸入餐廳名稱';
                }
                return null;
              },
            ),
            TextFormField(
              controller: description,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '描述',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '請輸入描述';
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
