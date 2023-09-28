import 'package:flutter/material.dart';

import 'models/restaurant.dart';

class AddAttributePage extends StatefulWidget {
  const AddAttributePage({super.key});

  @override
  State<StatefulWidget> createState() => _AddAttributePageState();
}

class _AddAttributePageState extends State<AddAttributePage> {
  final attributeLabel = TextEditingController();
  List<TextEditingController> labels = [];
  List<TextEditingController> pricing = [];
  List<Row> optionsFields = [];
  void addOption() {
    setState(() {
      final labelController = TextEditingController();
      final pricingController = TextEditingController();
      labels.add(labelController);
      pricing.add(pricingController);
      optionsFields.add(Row(key: UniqueKey(), children: [
        TextField(
          controller: labelController,
        ),
        TextField(
          controller: pricingController,
        )
      ]));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('增加屬性')),
      floatingActionButton: FloatingActionButton(
        onPressed: addOption,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: optionsFields.length,
          itemBuilder: ((context, index) => Container(
                child: optionsFields[index],
              ))));
}

class OptionEditList {
  final labels = TextEditingController();
  final pricing = TextEditingController();
}
