import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';

class DynamicTextField extends StatefulWidget {
  List<TextEditingController>? listController;
  DynamicTextField({super.key, required this.listController});

  @override
  State<DynamicTextField> createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState extends State<DynamicTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.listController == []) {
      widget.listController = [TextEditingController()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                shrinkWrap: true,
                itemCount: widget.listController!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // color: const Color(0xFF2E384E),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: widget.listController![index],
                              autofocus: false,
                              // style: const TextStyle(color: Color(0xFFF8F8FF)),
                              decoration: const InputDecoration(
                                // border: InputBorder.none,
                                hintText: "輸入品類",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        index != 0
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.listController![index].clear();
                                    widget.listController![index].dispose();
                                    widget.listController!.removeAt(index);
                                  });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: kPrimaryColor,
                                  size: 20,
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.listController!.add(TextEditingController());
                  });
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      "添加更多分類",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
