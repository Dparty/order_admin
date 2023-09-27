import 'package:flutter/material.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('新增品項'),
    ));
  }
}
