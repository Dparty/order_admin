import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_admin/addAttribute.dart';
import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/models/restaurant.dart';

class CreateItemPage extends StatefulWidget {
  final String restaurantId;
  const CreateItemPage(this.restaurantId, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _CreateItemPageState(restaurantId);
}

class _CreateItemPageState extends State<CreateItemPage> {
  final name = TextEditingController();
  final pricing = TextEditingController();
  final tag = TextEditingController();
  final List<Attribute> attributes = [];
  final ImagePicker picker = ImagePicker();
  final String restaurantId;
  List<Printer> printers = [];
  String? printerId;
  XFile? image;

  _CreateItemPageState(this.restaurantId);

  @override
  void initState() {
    super.initState();
    listPrinters(restaurantId).then((list) => setState(() {
          printers = list.data;
          if (printers.isNotEmpty) {
            printerId = printers[0].id;
          }
        }));
  }

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
    createItem(
            restaurantId,
            PutItem(
                printers: printers
                    .where((p) => p.id == printerId)
                    .map((p) => p.id)
                    .toList(),
                tags: [tag.text],
                name: name.text,
                pricing: int.parse(pricing.text) * 100,
                attributes: attributes))
        .then((value) => Navigator.pop(context));
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
            printers.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(children: [
                      const Text('打印機：'),
                      Expanded(
                        child: DropdownButton<String>(
                          value: printerId,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              printerId = value;
                            });
                          },
                          items: printers
                              .map<DropdownMenuItem<String>>((Printer value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                      )
                    ]))
                : const Text('請新增打印機'),
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
