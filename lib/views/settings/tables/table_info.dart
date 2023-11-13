import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/components/dialog.dart';

// models
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/bill.dart';

// providers
import 'package:provider/provider.dart';
import 'package:order_admin/provider/selected_table_provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/api/utils.dart';

import '../../../components/qr_code.dart';

class TableInfoView extends StatefulWidget {
  final model.Table? table;
  final Function()? reload;

  const TableInfoView({Key? key, this.table, this.reload}) : super(key: key);

  @override
  State<TableInfoView> createState() => _TableInfoViewState();
}

class _TableInfoViewState extends State<TableInfoView> {
  TextEditingController? label;
  TextEditingController? x;
  TextEditingController? y;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    label = TextEditingController(text: widget.table?.label.toString());
    x = TextEditingController(text: widget.table?.x.toString());
    y = TextEditingController(text: widget.table?.y.toString());
    super.didChangeDependencies();
  }

  Future<void> _downloadImage(String url) async {
    if (kIsWeb) {
      await WebImageDownloader.downloadImageFromWeb(url);
    } else {
      await _saveNetworkImage(url);
    }
  }

  _saveNetworkImage(String url) async {
    if (widget.table == null) return;
    final response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
        quality: 60, name: "${widget.table!.label}-qrcode");
  }

  void create(id, label, x, y) {
    createTable(id, label, x, y).then((table) {
      showAlertDialog(context, "創建成功");
      widget.reload!();
    });
  }

  void update(id, label, x, y) {
    updateTable(id, label, x, y).then((table) {
      showAlertDialog(context, "更新成功");
      widget.reload!();
    });
  }

  void delete(tableId) {
    deleteTable(tableId).then((_) {
      widget.reload!();
      showAlertDialog(context, "刪除餐桌成功");
    }).onError((error, stackTrace) {
      showAlertDialog(context, "無法刪除餐桌，可能有進行中訂單");
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Bill>? bills = context.watch<SelectedTableProvider>().tableOrders;
    final restaurant = context.watch<RestaurantProvider>();
    var table = context.watch<SelectedTableProvider>().selectedTable;
    final _formKey = GlobalKey<FormState>();
    String url = '';

    if (table != null) {
      url = createOrderingUrl(restaurant.id, table!.id);
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: table == null ? const Text('新增餐桌') : const Text('編輯餐桌'),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                        controller: label,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: '輸入餐桌標籤',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入餐桌標籤';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: x,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: '輸入餐桌位置 x',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '輸入餐桌位置 x';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: y,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: '輸入餐桌位置 y',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '輸入餐桌位置 y';
                          }
                          return null;
                        },
                      ),
                      table == null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 100),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    create(restaurant.id, label?.text,
                                        int.parse(x!.text), int.parse(y!.text));
                                  }
                                },
                                child: const Text('創建'),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 160,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFC88D67),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        showAlertDialog(
                                            context, "確認刪除餐桌${table?.label}?",
                                            onConfirmed: () =>
                                                delete(table?.id));
                                      },
                                      child: const Text("刪除餐桌"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 160,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFC88D67),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          update(
                                              restaurant.id,
                                              label?.text,
                                              int.parse(x!.text),
                                              int.parse(y!.text));
                                        }
                                      },
                                      child: const Text("編輯餐桌"),
                                    ),
                                  ),
                                ],
                              )),
                    ],
                  ),
                ),
                table == null
                    ? Container()
                    : Column(
                        children: [
                          Center(
                              child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 50.0, bottom: 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _downloadImage(url);
                                  },
                                  child: const Text('下載二維碼'),
                                ),
                              ),
                              SizedBox(
                                child: QRCode(
                                  qrSize: 320,
                                  qrData: url,
                                ),
                              )
                            ],
                          )),
                        ],
                      )
              ],
            )));
  }
}
