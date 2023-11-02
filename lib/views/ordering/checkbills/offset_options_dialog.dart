import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';

class offsetOptions extends StatefulWidget {
  int? selectedIndex = 0;
  final Function? onSelected;
  final Function? onConfirmed;
  offsetOptions(
      {Key? key, this.selectedIndex, this.onSelected, this.onConfirmed})
      : super(key: key);

  @override
  State<offsetOptions> createState() => _offsetOptionsState();
}

class _offsetOptionsState extends State<offsetOptions> {
  List checkListItems = [
    {
      "id": 0,
      "value": true,
      "offset": 0,
      "title": "原價",
    },
    {
      "id": 1,
      "offset": -5,
      "value": false,
      "title": "95折",
    },
    {
      "id": 2,
      "offset": 10,
      "value": false,
      "title": "+10%服務費",
    },
  ];

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    widget.onConfirmed!();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("折扣選擇"),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
              height: height - 500,
              width: width - 1000,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: List.generate(
                        checkListItems.length,
                        (index) => CheckboxListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          activeColor: kPrimaryColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            checkListItems[index]["title"],
                          ),
                          value: checkListItems[index]["value"],
                          onChanged: (value) {
                            widget.onSelected!(checkListItems[index]["offset"]);
                            setState(() {
                              for (var element in checkListItems) {
                                element["value"] = false;
                              }
                              checkListItems[index]["value"] = true;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _cancel,
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.grey),
                            child: const Text(
                              "取消",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: kPrimaryColor),
                            child: const Text(
                              "確定",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ));
        }));
  }
}
