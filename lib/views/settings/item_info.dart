import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_admin/views/settings/add_attribute_page.dart';
import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/selected_item_provider.dart';
import 'package:order_admin/provider/selected_printer_provider.dart';
import 'package:order_admin/views/restaurant_settings_page.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/models/restaurant.dart' as model;

import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';

class EditItemPage extends StatefulWidget {
  final model.Item? item;
  final Function()? reload;

  const EditItemPage({Key? key, this.item, this.reload}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  TextEditingController? name;
  TextEditingController? pricing;
  TextEditingController? tag;
  List<Attribute>? attributes = [];

  bool loading = false;
  List<Printer> printers = [];
  List<String>? printerIds = [];
  String? printerId;

  XFile? image;
  File? imageFile;
  Uint8List webImage = Uint8List(8);
  bool showImage = false;

  List<String>? _selectedPrinters = [];
  int _count = 1;

  void _addNewPrinter() {
    print(_selectedPrinters?.length);
    setState(() {
      _selectedPrinters ??= [context.read<RestaurantProvider>().printers[0].id];
      _count = _count + 1;
      _selectedPrinters?.add(context.read<RestaurantProvider>().printers[0].id);
    });
  }

  void _deletePrinter() {
    setState(() {
      _count = _count - 1;
      _selectedPrinters?.removeLast();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    name = TextEditingController(text: widget.item?.name);
    pricing = TextEditingController(
        text: ((widget.item?.pricing ?? 0) / 100).toString());
    tag = TextEditingController(text: widget.item?.tags?[0].toString());
    printers = context.read<RestaurantProvider>().printers;
    printerIds = widget.item?.printers;
    _selectedPrinters = widget.item?.printers ?? [];
    attributes = widget.item?.attributes;

    super.didChangeDependencies();
  }

  void update() {
    updateItem(
            context.read<SelectedItemProvider>().selectedItem!.id,
            PutItem(
                printers: _selectedPrinters!,
                tags: [tag!.text],
                name: name!.text,
                pricing: (double.parse(pricing!.text) * 100).toInt(),
                attributes: attributes!))
        .then((value) {
      showAlertDialog(context, "更新成功");
      widget.reload!();
    });
  }

  void delete(itemId) {
    deleteTable(itemId).then((_) {
      widget.reload!();
      showAlertDialog(context, "刪除品項成功");
    }).onError((error, stackTrace) {
      showAlertDialog(context, "無法刪除");
    });
  }

  void create() {
    if (loading) return;
    loading = true;
    if (printers.isEmpty) {
      loading = false;
      showAlertDialog(context, "請先創建打印機");
      return;
    }

    if (!showImage) {
      loading = false;
      showAlertDialog(context, '請上傳圖片');
      return;
    }

    createItem(
            context.read<RestaurantProvider>().id,
            PutItem(
                printers: printers
                    .where((p) => p.id == printerId)
                    .map((p) => p.id)
                    .toList(),
                tags: [tag!.text],
                name: name!.text,
                pricing: (double.parse(pricing!.text) * 100).toInt(),
                attributes: attributes!))
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
      if (attribute != null) attributes?.add(attribute);
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
    final restaurant = context.watch<RestaurantProvider>();
    var item = context.watch<SelectedItemProvider>().selectedItem;

    final _formKey = GlobalKey<FormState>();

    void setSelectPrinter(i, value) {
      setState(() {
        _selectedPrinters?[i] = value;
      });
    }

    List<Widget> _printers = item == null
        ? List.generate(
            _selectedPrinters!.length,
            (int i) => PrinterRow(
                  index: i,
                  selectedPrinters: _selectedPrinters,
                  onSelect: setSelectPrinter,
                ))
        : List.generate(
            item!.printers.length,
            (int i) => PrinterRow(
                  index: i,
                  selectedPrinters: _selectedPrinters,
                  onSelect: setSelectPrinter,
                ));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: item == null ? const Text('新增品項') : const Text('編輯品項'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Form(
                key: _formKey,
                child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      item != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.delete_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showAlertDialog(
                                          context, "確認刪除品項${item?.name}?",
                                          onConfirmed: () => delete(item?.id));
                                    },
                                    label: const Text(
                                      "刪除該品項",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(150, 43),
                                    ),
                                  ),
                                ])
                          : SizedBox(),

                      TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                          hintText: '輸入品項名稱',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入品項名稱';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        controller: pricing,
                        decoration: const InputDecoration(
                          hintText: '價錢',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入品項價錢';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: tag,
                        decoration: const InputDecoration(
                          hintText: '分類',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入品項分類';
                          }
                          return null;
                        },
                      ),
                      ...?attributes?.map((a) => Padding(
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
                                onPressed: () =>
                                    setState(() => attributes?.remove(a)),
                                child: const Text('刪除'),
                              )
                            ],
                          ))),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        // child: ElevatedButton(
                        //   onPressed: addAttribute,
                        //   child: const Text('增加屬性'),
                        // ),
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                          onPressed: addAttribute,
                          label: const Text(
                            "增加屬性",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(208, 43),
                          ),
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('打印機：'),
                                ElevatedButton(
                                  onPressed: _addNewPrinter,
                                  child: Icon(Icons.add),
                                ),
                                ElevatedButton(
                                  onPressed: _deletePrinter,
                                  child: Icon(Icons.remove),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50.0,
                              // width: 50,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                // scrollDirection: Axis.vertical,

                                child: Row(
                                  children: _printers,
                                ),
                                // children: _printers,
                              ),
                            ),
                          ])),

                      // const Text('請新增打印機'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () => _pickImage(),
                          child: const Text('上傳圖片'),
                        ),
                      ),
                      item == null
                          ? showImage
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: kIsWeb
                                      ? const Text("在電腦上無法上傳圖片")
                                      : Image.file(
                                          imageFile == null
                                              ? item?.images[0]
                                              : imageFile,
                                          fit: BoxFit.cover))
                              : const Text(
                                  '請上傳圖片',
                                  style: TextStyle(fontSize: 20),
                                )
                          : SizedBox(
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FadeInImage(
                                  image: NetworkImage(
                                    item.images.isEmpty ? '' : item.images[0],
                                  ),
                                  fit: BoxFit.fitHeight,
                                  placeholder:
                                      const AssetImage("images/default.png"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      "images/default.png",
                                      width: 100,
                                    );
                                  },
                                ),
                              ),
                            ),

                      // item != null
                      //     ? SizedBox(
                      //         height: 150,
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: FadeInImage(
                      //             image: NetworkImage(
                      //               item.images.isEmpty ? '' : item.images[0],
                      //             ),
                      //             fit: BoxFit.fitHeight,
                      //             placeholder:
                      //                 const AssetImage("images/default.png"),
                      //             imageErrorBuilder:
                      //                 (context, error, stackTrace) {
                      //               return Image.asset(
                      //                 "images/default.png",
                      //                 width: 100,
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //       )
                      //     : SizedBox(),

                      item != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    update();
                                  }
                                },
                                child: const Text('提交編輯'),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    create();
                                  }
                                },
                                child: const Text('創建'),
                              ),
                            ),
                    ]),
              ))),
            ],
          )),
    );
  }
}

// todo: Add multiple printers
class PrinterRow extends StatefulWidget {
  int index;
  List<String>? selectedPrinters;
  Function? onSelect;

  PrinterRow(
      {Key? key,
      required this.index,
      required this.selectedPrinters,
      this.onSelect})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _PrinterRow();
}

class _PrinterRow extends State<PrinterRow> {
  @override
  Widget build(BuildContext context) {
    var printers = context.watch<RestaurantProvider>().printers;
    return Container(
        width: 100.0,
        child: Column(children: <Widget>[
          Expanded(
            child: DropdownButton<String>(
              value: widget.selectedPrinters?[widget.index] ?? printers[0].id,
              // : widget.selectedPrinters?[widget.index],
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                widget.onSelect!(widget.index, value);
              },
              items: printers.map<DropdownMenuItem<String>>((Printer value) {
                return DropdownMenuItem<String>(
                  value: value.id,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
        ]));
  }
}
