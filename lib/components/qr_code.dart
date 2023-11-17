import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:permission_handler/permission_handler.dart';
// QR Flutter package
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_downloader_web/image_downloader_web.dart';

import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class QRCode extends StatelessWidget {
  QRCode({
    Key? key,
    this.width,
    this.height,
    this.qrSize,
    required this.qrData,
    this.gapLess,
    this.qrVersion,
    this.qrPadding,
    this.qrBorderRadius,
    this.semanticsLabel,
    this.qrBackgroundColor,
    this.qrForegroundColor,
    this.onPressed,
  }) : super(key: key);

  // Required by FF (NOT USED IN WIDGET)
  final double? width;
  final double? height;
  // The (square) size of the image
  final double? qrSize;
  // Text data to the encoded
  final String qrData;
  // Adds an extra pixel in size to prevent gaps (default is true).
  final bool? gapLess;
  // `QrVersions.auto` or a value between 1 and 40.
  // See http://www.qrcode.com/en/about/version.html for limitations and details.
  final int? qrVersion;
  // Padding on all sides
  final double? qrPadding;
  // Circular border radius beside the QR code
  final double? qrBorderRadius;
  // Will be used by screen readers to describe the content of the QR code.
  final String? semanticsLabel;
  // 	The background color (default is transparent).
  final Color? qrBackgroundColor;
  //	The foreground color (default is black).
  final Color? qrForegroundColor;
  final Function? onPressed;

  final ScreenshotController screenshotController = ScreenshotController();

  // todo: not working in web
  Future<void> saveQrCode(context) async {
    final Uint8List? uint8List = await screenshotController.capture();
    if (uint8List != null) {
      final PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        final result = await ImageGallerySaver.saveImage(uint8List);
        if (result['isSuccess']) {
          showAlertDialog(context, "二維碼已下載");
        }
      } else {
        showAlertDialog(context, "下載失敗，請開啟圖片權限");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(qrBorderRadius ?? 0),
          child: Screenshot(
            controller: screenshotController,
            child: QrImageView(
              size: qrSize,
              data: qrData,
              gapless: gapLess ?? true,
              version: qrVersion ?? QrVersions.auto,
              padding: EdgeInsets.all(qrPadding ?? 10),
              semanticsLabel: semanticsLabel ?? '',
              backgroundColor: qrBackgroundColor ?? Colors.transparent,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              await onPressed!();
              // await saveQrCode(context);
            },
            child: const Text("下載二維碼"))
      ],
    );
  }
}
