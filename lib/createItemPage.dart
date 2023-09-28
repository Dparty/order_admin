import 'package:flutter/material.dart';
import 'package:order_admin/addAttribute.dart';

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

  void addAttribute() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddAttributePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增品項'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(children: [
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16.0),
            //   child: ElevatedButton(
            //     onPressed: addAttribute,
            //     child: const Text('新增屬性'),
            //   ),
            // ),
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
