import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

captureResultScreen(GlobalKey key) async {
  RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
  ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  var pngBytes = byteData.buffer.asUint8List();
  var bs64 = base64Encode(pngBytes);

  await Share.file('result', 'result.png', pngBytes, 'image/png',
      text: 'سرعة طباعتي على لوحة مفاتيح الجوال');
}
