import 'package:flutter/material.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final name = TextEditingController();
  final pricing = TextEditingController();
  final tag = TextEditingController();
  void create() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增品項'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                hintText: '品項名稱',
              ),
            ),
            TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: pricing,
              decoration: const InputDecoration(
                hintText: '價錢',
              ),
            ),
            TextFormField(
              controller: tag,
              decoration: const InputDecoration(
                hintText: '分類',
              ),
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
