import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/api/restaurant.dart';
import 'package:provider/provider.dart';

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

class _CreatePrinterPageState extends State<CreatePrinterPage> {
  final _formKey = GlobalKey<FormState>();
  final String restaurantId;
  Printer? printer;
  TextEditingController? name;
  TextEditingController? sn;
  _CreatePrinterPageState(this.restaurantId);

  String printerType = printerTypeEnum.first;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    printer = context.watch<SelectedPrinterProvider>().selectedPrinter;
    name = TextEditingController(text: printer?.name);
    sn = TextEditingController(text: printer?.sn);
    printerType = printer?.type ?? printerTypeEnum.first;
    super.didChangeDependencies();
  }

  void create() {
    createPrinter(restaurantId, name!.text, sn!.text, printerType)
        .then((value) {
      widget.reload!();
      // Navigator.pop(context);
    });
  }

  void update() {
    updatePrinter(restaurantId, name!.text, sn!.text, printerType)
        .then((value) {
      widget.reload!();
      // Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // name = TextEditingController(text: widget.printer?.name);
    // sn = TextEditingController(text: widget.printer?.sn);
    // printerType = widget.printer?.type ?? printerTypeEnum.first;

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
                    // This is called when the user selects an item.
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
