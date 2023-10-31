import 'package:flutter/material.dart';
import 'package:order_admin/models/model.dart';
import 'package:order_admin/models/restaurant.dart';

class SpecificationPage extends StatefulWidget {
  final Item item;
  const SpecificationPage(this.item, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _SpecificationPageState(item);
}

class _SpecificationPageState extends State<SpecificationPage> {
  final Item item;
  List<Pair> specification = [];
  _SpecificationPageState(this.item);

  int number = 1;

  void setSpecification(String left, String right) {
    setState(() {
      specification = [
        ...specification.where((s) => s.left != left),
        Pair(left: left, right: right)
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      specification = item.attributes
          .map((a) => Pair(left: a.label, right: a.options[0].label))
          .toList();
    });
  }

  void submit() {
    Navigator.pop(
        context,
        List.generate(number,
            (_) => Specification(itemId: item.id, options: specification)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(item.name)),
        floatingActionButton: Wrap(direction: Axis.horizontal, children: [
          Container(
              padding: const EdgeInsets.all(10),
              child: FloatingActionButton(
                  onPressed: () {
                    if (number == 1) return;
                    setState(() {
                      number--;
                    });
                  },
                  child: const Icon(Icons.exposure_minus_1))),
          Container(
            padding: const EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: null,
              child: Text(number.toString()),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  number++;
                });
              },
              child: const Icon(Icons.exposure_plus_1),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: submit,
              child: const Icon(Icons.send),
            ),
          ),
        ]),
        body: ListView(
            children: item.attributes
                .map((a) => SpecificationSelector(
                        a,
                        specification
                            .firstWhere((s) => s.left == a.label)
                            .right, (v) {
                      setSpecification(a.label, v);
                    }))
                .toList()),
      );
}

const textSize = 24.0;

class SpecificationSelector extends StatelessWidget {
  final Attribute attribute;
  final String selected;
  final void Function(String) onChange;
  const SpecificationSelector(this.attribute, this.selected, this.onChange,
      {super.key});
  String optionString(Option o) {
    if (o.extra == 0) {
      return o.label;
    }
    return "${o.label} +${o.extra / 100}";
  }

  void onPressed(String v) {
    onChange(v);
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(
          attribute.label,
          style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
        ),
        Wrap(
          children: [
            ...attribute.options
                .map((o) => o.label != selected
                    ? OutlinedButton(
                        onPressed: () {
                          onPressed(o.label);
                        },
                        child: Text(
                          optionString(o),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: textSize),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          onPressed(o.label);
                        },
                        child: Text(
                          optionString(o),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: textSize),
                        ),
                      ))
                .toList()
          ],
        )
      ]);
}
