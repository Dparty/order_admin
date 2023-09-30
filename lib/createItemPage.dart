import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_admin/addAttribute.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/models/restaurant.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final name = TextEditingController();
  final pricing = TextEditingController();
  final tag = TextEditingController();
  final List<Attribute> attributes = [];
  final ImagePicker picker = ImagePicker();
  XFile? image;
  void create() {
    if (name.text.isEmpty) {
      showDeleteConfirmDialog(context, "請輸入品項名稱");
      return;
    }
    if (pricing.text.isEmpty) {
      showDeleteConfirmDialog(context, '請輸入價錢');
      return;
    }
    if (tag.text.isEmpty) {
      showDeleteConfirmDialog(context, '請輸入分類');
      return;
    }
  }

  void addAttribute() async {
    final Attribute? attribute = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddAttributePage()))
        as Attribute?;
    setState(() {
      if (attribute != null) attributes.add(attribute);
    });
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
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
            ...attributes.map((a) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("屬性:${a.label}"),
                    ),
                    ...a.options.map((o) => Expanded(
                          child: Text("${o.label}:+${o.extra / 100}"),
                        )),
                    ElevatedButton(
                      onPressed: () => setState(() => attributes.remove(a)),
                      child: const Text('刪除'),
                    )
                  ],
                ))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: addAttribute,
                child: const Text('增加屬性'),
              ),
            ),
            image != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        //to show image, you type like this.
                        File(image!.path),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    ),
                  )
                : const Text(
                    '請上傳圖片',
                    style: TextStyle(fontSize: 20),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () => getImage(ImageSource.gallery),
                child: const Text('上傳圖片'),
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
