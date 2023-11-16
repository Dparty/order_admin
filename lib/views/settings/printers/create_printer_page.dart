import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/api/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:order_admin/components/dialog.dart';
import '../../../provider/selected_printer_provider.dart';

class CreatePrinterPage extends StatefulWidget {
  final String restaurantId;
  final Function()? reload;
  final bool? automaticallyImplyLeading;

  CreatePrinterPage(
    this.restaurantId, {
    this.reload,
    this.automaticallyImplyLeading,
    super.key,
  });

  @override
  // ignore: no_logic_in_create_state
  State<CreatePrinterPage> createState() =>
      _CreatePrinterPageState(restaurantId);
}

const List<String> printerTypeEnum = <String>[('BILL'), 'KITCHEN'];
const List<String> printerModelEnum = <String>[('58mm'), '88mm'];

class _CreatePrinterPageState extends State<CreatePrinterPage> {
  final _formKey = GlobalKey<FormState>();
  final String restaurantId;
  Printer? printer;
  TextEditingController? name;
  TextEditingController? sn;
  TextEditingController? description;
  _CreatePrinterPageState(this.restaurantId);

  String printerType = printerTypeEnum.first;
  String printerModel = printerModelEnum.first;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    printer = context.watch<SelectedPrinterProvider>().selectedPrinter;
    name = TextEditingController(text: printer?.name);
    sn = TextEditingController(text: printer?.sn);
    description = TextEditingController(text: printer?.description);
    printerType = printer?.type ?? printerTypeEnum.first;
    printerModel = printer?.model ?? printerModelEnum.first;
    super.didChangeDependencies();
  }

  void create() {
    createPrinter(restaurantId, name!.text, sn!.text, printerType,
            description!.text ?? '', printerModel)
        .then((value) {
      showAlertDialog(context, "創建成功");
      widget.reload!();
      // Navigator.pop(context);
    });
  }

  void update() {
    updatePrinter(printer!.id, name!.text, sn!.text, printerType,
            description!.text ?? '', printerModel)
        .then((value) {
      showAlertDialog(context, "更新成功");
      widget.reload!();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: printer == null ? const Text('新增打印機') : const Text('編輯打印機'),
        automaticallyImplyLeading: widget.automaticallyImplyLeading ?? true,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    hintText: '打印機名稱',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '輸入打印機名稱';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: sn,
                  decoration: const InputDecoration(
                    hintText: 'SN編號',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '輸入SN編號';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: description,
                  decoration: const InputDecoration(
                    hintText: '描述',
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      const Text("類型：", style: TextStyle(fontSize: 16)),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        value: printerType,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            printerType = value!;
                          });
                        },
                        items: printerTypeEnum
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("模型：", style: TextStyle(fontSize: 16)),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        value: printerModel,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            printerModel = value!;
                          });
                        },
                        items: printerModelEnum
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                printer == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              create();
                            }
                          },
                          child: const Text('創建'),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              update();
                            }
                          },
                          child: const Text('修改'),
                        ),
                      ),
              ]))),
    );
  }
}
