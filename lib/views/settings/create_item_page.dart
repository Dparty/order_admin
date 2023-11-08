import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_admin/views/settings/add_attribute_page.dart';

import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/views/restaurant_settings_page.dart';

import 'package:order_admin/configs/constants.dart';

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
  final String restaurantId;
  bool loading = false;
  List<Printer> printers = [];
  String? printerId;
  XFile? image;
  File? imageFile;
  Uint8List webImage = Uint8List(8);
  bool showImage = false;
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
    if (loading) return;
    loading = true;
    if (printers.isEmpty) {
      loading = false;
      showAlertDialog(context, "請先創建打印機");
      return;
    }
    if (name.text.isEmpty) {
      loading = false;
      showAlertDialog(context, "請輸入品項名稱");
      return;
    }
    if (pricing.text.isEmpty) {
      loading = false;
      showAlertDialog(context, '請輸入價錢');
      return;
    }
    if (tag.text.isEmpty) {
      loading = false;
      showAlertDialog(context, '請輸入分類');
      return;
    }
    if (!showImage) {
      loading = false;
      showAlertDialog(context, '請上傳圖片');
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
                pricing: (double.parse(pricing.text) * 100).toInt(),
                attributes: attributes))
        .then((value) {
      if (showImage) {
        if (!kIsWeb) {
          uploadItemImage(value.id, imageFile!)
              .then((value) => Navigator.pop(context))
              .catchError((err) {
            showAlertDialog(context, err.toString());
          });
          loading = false;
        } else {
          Navigator.pop(context);
          loading = false;
        }
      }
    });
  }

  void addAttribute() async {
    final Attribute? attribute = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddAttributePage()))
        as Attribute?;
    setState(() {
      if (attribute != null) attributes.add(attribute);
    });
  }

  void _pickImage() async {
    ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        showImage = true;
        imageFile = File(image!.path);
      });
    }
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
                : Center(
                    child: Container(
                    width: MediaQuery.of(context).size.width - 1000.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: kPrimaryColor),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RestaurantSettingsPage(
                                    restaurantId: restaurantId,
                                    selectedNavIndex: 1)));
                      },
                      child: const Center(
                          child: Text(
                        '新增打印機',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                    ),
                  )),

            // const Text('請新增打印機'),
            showImage
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: kIsWeb
                        ? const Text("在電腦上無法上傳圖片")
                        : Image.file(imageFile!, fit: BoxFit.cover))
                : const Text(
                    '請上傳圖片',
                    style: TextStyle(fontSize: 20),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () => _pickImage(),
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
