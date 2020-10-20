import 'dart:convert';
import 'dart:typed_data';

import 'package:arabic_typing_speed/model/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ResultPage extends StatelessWidget {
  final Result result;

  const ResultPage({Key key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<State<StatefulWidget>> _globalKey =
        new GlobalKey<State<StatefulWidget>>();

    Widget resultWidget = RepaintBoundary(
      child: Container(
          key: _globalKey,
          color: Colors.blueGrey,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Hero(
                    tag: 'flash_icon',
                    child: Container(
                        height: 150,
                        width: 150,
                        child: Image.asset(
                          'assets/electric.png',
                        ))),
              ),
              Text(
                '${result.wpm}',
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '  كلمة/الدقيقة',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text(
                ' طباعتك دقيقة بنسبة ${result.typingAccuracy}%',
                style: TextStyle(fontSize: 30, color: Colors.white),
              )
            ],
          ))),
    );

    return Scaffold(
      body: SafeArea(
        child: resultWidget,
      ),
    );

    // FlatButton(
    //   child: Text("Share"),
    //   onPressed: () async {
    //     RenderRepaintBoundary boundary =
    //     _globalKey.currentContext.findRenderObject();
    //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    //     ByteData byteData =
    //     await image.toByteData(format: ui.ImageByteFormat.png);
    //     var pngBytes = byteData.buffer.asUint8List();
    //     var bs64 = base64Encode(pngBytes);
    //
    //     await Share.file(
    //         'esys image', 'esys.png', pngBytes, 'image/png',
    //         text: 'My optional text.');
    //   },
    // );
  }
}
