import 'package:flutter/material.dart';
import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/components/dynamic_textfield.dart';
import 'package:order_admin/models/restaurant.dart';

class CreateRestaurantPage extends StatefulWidget {
  final Restaurant? restaurant;

  const CreateRestaurantPage({super.key, this.restaurant});

  @override
  State<StatefulWidget> createState() => _CreateRestaurantPageState();
}

class _CreateRestaurantPageState extends State<CreateRestaurantPage> {
  TextEditingController? name;
  TextEditingController? description;
  List<TextEditingController>? _listController = [TextEditingController()];

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.restaurant?.name);
    description = TextEditingController(text: widget.restaurant?.description);
    _listController = widget.restaurant == null
        ? [TextEditingController()]
        : widget.restaurant?.categories
            .map((e) => TextEditingController(text: e))
            .toList();
  }

  create() {
    if (name!.text == "") {
      showAlertDialog(context, "請輸入餐廳名稱");
      return;
    }

    List<String> categoryList = _listController!
        .where((element) => element.text != "")
        .map((e) => e.text)
        .toList();

    createRestaurant(name!.text, description!.text, categoryList)
        .then((value) => Navigator.pop(context));
  }

  update() {
    List<String> categoryList = _listController!
        .where((element) => element.text != "")
        .map((e) => e.text)
        .toList();

    updateRestaurant(
            widget.restaurant!.id, name!.text, description!.text, categoryList)
        .then((value) => Navigator.pop(context));
  }

  delete() {
    deleteRestaurant(widget.restaurant!.id)
        .then((value) => Navigator.pop(context));
  }

  List<String> getCategoriesList(String str) {
    String cleanupWhitespace(String input) =>
        input.replaceAll(RegExp(r"\s+"), "");
    var temp = cleanupWhitespace(str).split('r/[\n\s+,，；;]/g');
    return temp.where((String element) => element != '').toList() ?? [];
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
            // // todo: addable categories
            // TextFormField(
            //   controller: categories,
            //   decoration: const InputDecoration(
            //     hintText: '分類',
            //   ),
            //   validator: (String? value) {
            //     if (value == null || value.isEmpty) {
            //       return '請輸入分類';
            //     }
            //     return null;
            //   },
            // ),
            SizedBox(
              height: 400,
              child: DynamicTextField(listController: _listController),
            ),
            widget.restaurant != null
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: delete,
                            child: const Text('刪除餐廳'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: update,
                            child: const Text('提交編輯'),
                          ),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: create,
                        child: const Text('創建餐廳'),
                      ),
                    ),
                  ),
          ],
        ),
      ));
}
