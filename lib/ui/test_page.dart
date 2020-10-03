
import 'dart:async';
import 'package:arabic_typing_speed/main.dart';
import 'package:arabic_typing_speed/model/result.dart';
import 'package:arabic_typing_speed/model/typing_test.dart';
import 'package:arabic_typing_speed/model/text_word.dart';
import 'package:arabic_typing_speed/ui/result_page.dart';
import 'package:flutter/material.dart';

import 'package:arabic_typing_speed/constants.dart';
import 'package:countdown/countdown.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key, this.title, this.duration}) : super(key: key);
  final String title;
  final Duration duration;
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TypingTest typingTest;
  List<TextWord> mainWordsList;
  List<String> userTypedWordsList;
  int wordIndex = 0;

  int correctAnswersCount =0;
  int incorrectAnswersCount =0;


  TextEditingController _typerController = TextEditingController();

  double durationInMin;
  CountDown cd;
  StreamSubscription<Duration> countDownSubscriber;
  bool _isTimerStarted = false;
  int currentTimerCount;


  @override
  void initState() {
    _typerController.addListener(typingWatcher);

    durationInMin= widget.duration.inSeconds/60;

    typingTest = TypingTest( durationInMin: durationInMin, text: textOptions[0]);
    mainWordsList = typingTest.transformTextToList();
    userTypedWordsList = [];

    cd = CountDown(widget.duration, refresh: Duration(seconds: 1));
    currentTimerCount= widget.duration.inSeconds;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 30, color: Colors.white),
                      children: mainWordsList.map((TextWord textWord) => TextSpan(text: textWord.word+' '
                          ,
                          style: textWord.textStyle,
                      )) // put the text inside a widget
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox( height: 30,),
            TextField(
              controller: _typerController,
              autocorrect: false,
              enableSuggestions: false,
              textAlign: TextAlign.center,
              // inputFormatters: [FilteringTextInputFormatter(" ", allow: false)],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            Text('${widget.duration.inSeconds}/$currentTimerCount')

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => TestPage(title: widget.title, duration: widget.duration,),
              transitionDuration: Duration.zero,
            ),
          );

        },
        tooltip: 'Retry',
        child: Icon(Icons.refresh, color: Colors.white,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void dispose() {
    _typerController.dispose();
    countDownSubscriber.cancel();
    super.dispose();
  }



  startCountDown() async{
    countDownSubscriber = cd.stream.listen(null);
    countDownSubscriber.onData((data) { setState(() {
      currentTimerCount= data.inSeconds;
    });});
    countDownSubscriber.onDone(
            () {
      showResultPage(
        correctAnswersCount, incorrectAnswersCount , durationInMin);}
        );
  }

  void typingWatcher() {
    // start timer when user initiate typing
    if(!_isTimerStarted) {
      startCountDown();
      _isTimerStarted = true;
    }

    String typedValue = _typerController.text;

    if (typedValue.length > 0){
      String pressedKey = typedValue.substring(typedValue.length - 1);

      if (pressedKey == ' ') {
        setState(() {
          // reset the text field
          _typerController.text = '';
          evaluateTypedInput(typedValue);
        }
        );
      }
    }

  }

  void evaluateTypedInput(String typedValue) {
    userTypedWordsList.add(typedValue.substring(0, typedValue.length - 1));
    if(userTypedWordsList[wordIndex] == mainWordsList[wordIndex].word) {
      mainWordsList[wordIndex].textStyle = correctStyle;
      correctAnswersCount++;
    }
    else {
      mainWordsList[wordIndex].textStyle = incorrectStyle;
      incorrectAnswersCount++;
    }

    wordIndex++;
    if(wordIndex < mainWordsList.length)
    mainWordsList[wordIndex].textStyle = currentStyle;
    else
      showResultPage(correctAnswersCount, incorrectAnswersCount, durationInMin);
  }


  void showResultPage( int correctAnswersCounter, int incorrectAnwerCount, durationInMin) {
    Result result = typingTest.result(correctAnswersCounter,incorrectAnwerCount);

    navigatorKey.currentState.push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => ResultPage(result: result),
      transitionDuration: Duration.zero,
    ),);
  }

}


