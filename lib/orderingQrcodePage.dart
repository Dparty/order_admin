import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:order_admin/models/restaurant.dart' as api;

const qrcodeApi =
    'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=';
const orderWebDomain = 'https://ordering-uat.sum-foods.com';

String createQrcodeUrl(String text) {
  return "$qrcodeApi$text";
}

String createOrderingUrl(String restaurantId, String tableId) {
  return createQrcodeUrl(Uri.encodeComponent(
      "$orderWebDomain/ordering/?restaurantId=$restaurantId&tableId=$tableId"));
}

class OrderingQrcodePage extends StatefulWidget {
  final String restaurantId;
  final String tableId;
  const OrderingQrcodePage(this.restaurantId, this.tableId, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _OrderingQrcodePageState(restaurantId, tableId);
}

class _OrderingQrcodePageState extends State<OrderingQrcodePage> {
  final String restaurantId;
  final String tableId;
  api.Table? table;
  _OrderingQrcodePageState(this.restaurantId, this.tableId);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _downloadImage(String url) async {
    if (kIsWeb) {
      await WebImageDownloader.downloadImageFromWeb(url);
    } else {
      await _saveNetworkImage(url);
    }
  }

  _saveNetworkImage(String url) async {
    if (table == null) return;
    final response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
        quality: 60, name: "${table!.label}-qrcode");
  }

  @override
  Widget build(BuildContext context) {
    final url = createOrderingUrl(restaurantId, tableId);
    return Scaffold(
      appBar: AppBar(title: const Text('桌號二維碼')),
      body: Column(
        children: [
          Expanded(
              child: Center(
                  child: Image.network(
            url,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ))),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _downloadImage(url);
                },
                child: const Text('下載'),
              )
            ],
          )
        ],
      ),
    );
  }
}
