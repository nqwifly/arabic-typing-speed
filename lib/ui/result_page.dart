import 'package:arabic_typing_speed/model/result.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Result result;

  const ResultPage({Key key, this.result}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Colors.cyan,
            child: Center(child:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('assets/flash.png',width:100.0),
                ),
                Text('${result.wpm}', style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),),
                Text('  كلمة/الدقيقة', style: TextStyle(fontSize: 20, color: Colors.white),),
                Text(' كتابتك دقيقة بنسبة ${result.typingAccuracy}%', style: TextStyle(fontSize: 30, color: Colors.white),)

              ],
            ))
        ),
      ),
    );
  }
}
