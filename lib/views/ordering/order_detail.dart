import 'package:flutter/material.dart';
import 'orderItem_page.dart';

class OrderDetail extends StatelessWidget {
  final assetPath, label, table;

  OrderDetail({Key? key, this.assetPath, this.label, this.table})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text('點單信息',
            style: TextStyle(fontSize: 20.0, color: Color(0xFF545D68))),
      ),
      body: ListView(children: [
        SizedBox(height: 15.0),
        SizedBox(height: 15.0),
        Center(
          child: Text(label,
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF17532))),
        ),
        SizedBox(height: 10.0),
        Center(
          child: Text('暫無點餐信息',
              style: TextStyle(color: Color(0xFF575E67), fontSize: 12.0)),
        ),
        SizedBox(height: 20.0),
        Center(
            child: Container(
                width: MediaQuery.of(context).size.width - 1000.0,
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Color(0xFFC88D67)),
                child: InkWell(
                  onTap: () {
                    if (label == 'null') return;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OrderItem()));
                  },
                  child: const Center(
                      child: Text(
                    '前往點單',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                )))
      ]),
    );
  }
}
