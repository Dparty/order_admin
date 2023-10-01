import 'package:flutter/material.dart';

const qrcodeApi =
    'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=';

class OrderingQrcodePage extends StatefulWidget {
  final String text;
  const OrderingQrcodePage(this.text, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _OrderingQrcodePageState(text);
}

class _OrderingQrcodePageState extends State<OrderingQrcodePage> {
  final String text;
  _OrderingQrcodePageState(this.text);
  @override
  Widget build(BuildContext context) {
    final url = "$qrcodeApi$text";
    return Scaffold(
      appBar: AppBar(title: const Text('桌號二維碼')),
      body: Column(
        children: [
          Expanded(child: Center(child: Image.network(url))),
          ElevatedButton(
            onPressed: () {},
            child: const Text('下載'),
          )
        ],
      ),
    );
  }
}
