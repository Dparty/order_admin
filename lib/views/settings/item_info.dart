import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:order_admin/api/config.dart';
import 'package:order_admin/views/settings/add_attribute_page.dart';
import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/models/restaurant.dart';

import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/selected_item_provider.dart';
import './printer_row.dart';

class EditItemPage extends StatefulWidget {
  final Item? item;
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
  List<PlatformFile>? _paths;

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
    // printerIds = widget.item?.printers;
    _selectedPrinters = widget.item?.printers ?? [];
    attributes = widget.item?.attributes ?? [];

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
      // widget.reload!();
      if (_paths != null) {
        //passing file bytes and file name for API call
        ApiClient.uploadFile(
                widget.item!.id, _paths!.first.bytes!, _paths!.first.name)
            .then((value) {
          showAlertDialog(context, "更新图片成功");
          _paths = null;
          widget.reload!();
        });
      }
      loading = false;
    });
  }

  void delete(itemId) {
    deleteItem(itemId).then((_) {
      widget.reload!();
      showAlertDialog(context, "刪除品項成功");
    }).onError((error, stackTrace) {
      showAlertDialog(context, "無法刪除");
    });
  }

  void create() {
    if (loading) return;
    loading = true;
    if (_selectedPrinters!.isEmpty) {
      loading = false;
      showAlertDialog(context, "請先創建打印機");
      return;
    }

    if (_paths == null) {
      loading = false;
      showAlertDialog(context, '請上傳圖片');
      return;
    }

    createItem(
            context.read<RestaurantProvider>().id,
            PutItem(
                printers: _selectedPrinters!,
                tags: [tag!.text],
                name: name!.text,
                pricing: (double.parse(pricing!.text) * 100).toInt(),
                attributes: attributes ?? []))
        .then((value) {
      if (_paths != null) {
        ApiClient.uploadFile(value.id, _paths!.first.bytes!, _paths!.first.name)
            .then((value) {
          showAlertDialog(context, "創建成功");
          _paths = null;
          widget.reload!();
        });
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

  void _pickFiles() async {
    try {
      var path = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
      ))
          ?.files;
      setState(() {
        _paths = path;
      });
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
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
                                  child: const Icon(Icons.add),
                                ),
                                ElevatedButton(
                                  onPressed: _deletePrinter,
                                  child: const Icon(Icons.remove),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () => _pickFiles(), //_pickImage()
                          child: const Text('上傳圖片'),
                        ),
                      ),
                      _paths != null
                          ? Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 150.00,
                                  width: 150.00,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: MemoryImage(
                                              _paths!.first.bytes!))),
                                ),
                              ),
                            )
                          : item != null
                              ? SizedBox(
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FadeInImage(
                                      image: NetworkImage(
                                        item!.images.isEmpty
                                            ? defaultImage
                                            : item.images[0],
                                      ),
                                      fit: BoxFit.fitHeight,
                                      placeholder: const AssetImage(
                                          "images/default.png"),
                                    ),
                                  ),
                                )
                              : SizedBox(),
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
