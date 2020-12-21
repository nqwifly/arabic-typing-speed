import 'package:arabic_typing_speed/constants.dart';
import 'package:arabic_typing_speed/model/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../utils.dart';

class ResultPage extends StatelessWidget {
  final Result result;

  const ResultPage({Key key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<State<StatefulWidget>> _globalKey =
        new GlobalKey<State<StatefulWidget>>();

    Widget resultWidget = RepaintBoundary(
      child: RepaintBoundary(
        key: _globalKey,
        child: Container(
            color: Colors.blueGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 10,
                  child: Column(
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
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "   * $kAverageTyping",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );

    return Scaffold(
        body: SafeArea(
          child: resultWidget,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            captureResultScreen(_globalKey);
          },
          tooltip: 'Share',
          child: Icon(
            Icons.share,
            color: Colors.white,
          ),
        ));
  }
}
