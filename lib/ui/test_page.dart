import 'dart:async';
import 'package:arabic_typing_speed/widgets/test_header.dart';
import 'package:flutter/material.dart';

import 'package:arabic_typing_speed/main.dart';
import 'package:arabic_typing_speed/model/result.dart';
import 'package:arabic_typing_speed/model/typing_test.dart';
import 'package:arabic_typing_speed/model/text_word.dart';
import 'package:arabic_typing_speed/ui/result_page.dart';
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
  List<TextWord> textAsWordList;
  int currentWordIndex = 0;

  int correctAnswersCount = 0;
  int incorrectAnswersCount = 0;

  TextEditingController _typerController = TextEditingController();

  CountDown cd;
  StreamSubscription<Duration> countDownSubscriber;
  bool _isTimerStarted = false;
  int currentTimerCount;

  @override
  void initState() {
    _typerController.addListener(typingWatcher);
    // _countDownController.pause();

    // durationInMin = widget.duration.inSeconds / 60;

    typingTest =
        TypingTest(duration: widget.duration.inSeconds, text: textOptions[0]);
    textAsWordList = typingTest.transformTextToList();

    cd = CountDown(widget.duration, refresh: Duration(seconds: 1));
    currentTimerCount = widget.duration.inSeconds;
    textAsWordList[currentWordIndex].textStyle = currentStyle;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _countDownController.pause();
    return Container(
      color: Colors.white70,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.blueGrey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                MyTestHeader(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(75.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                "النصّ: ",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        getTextboxUI(),
                        SizedBox(
                          height: 30,
                        ),
                        getTypingBar()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => TestPage(
                  title: widget.title,
                  duration: widget.duration,
                ),
                transitionDuration: Duration.zero,
              ),
            );
          },
          tooltip: 'Retry',
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget getTextboxUI() {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  children: textAsWordList
                      .map((TextWord textWord) => TextSpan(
                            text: '${textWord.word} ',
                            style: textWord.textStyle,
                          )) // put the text inside a widget
                      .toList(),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: currentTimerCount / widget.duration.inSeconds,
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    backgroundColor: Colors.grey,
                  ),
                  Text('$currentTimerCount'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTypingBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(13)),
      ),
      child: TextField(
        controller: _typerController,
        autocorrect: false,
        enableSuggestions: false,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: textAsWordList[currentWordIndex].word,
          border: InputBorder.none,
          helperStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.all(10),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.2,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  startCountDown() async {
    countDownSubscriber = cd.stream.listen(null);
    countDownSubscriber.onData((data) {
      setState(() {
        currentTimerCount = data.inSeconds;
      });
    });
    countDownSubscriber.onDone(() {
      showResultPage(correctAnswersCount, incorrectAnswersCount,
          widget.duration.inSeconds);
    });
  }

  void typingWatcher() {
    if (currentTimerCount <= 0) {
      _typerController.text = '';
      return;
    }

    // start timer when user initiate typing
    if (!_isTimerStarted) {
      startCountDown();
      _isTimerStarted = true;
    }

    String typedValue = _typerController.text;

    if (typedValue.length > 0) {
      String pressedKey = typedValue.substring(typedValue.length - 1);

      if (pressedKey == ' ') {
        setState(() {
          // reset the text field
          _typerController.text = '';
          evaluateTypedInput(typedValue);
        });
      }
    }
  }

  void evaluateTypedInput(String typedValue) {
    //remove last space
    typedValue = typedValue.trim();
    if (typedValue == textAsWordList[currentWordIndex].word) {
      textAsWordList[currentWordIndex].textStyle = correctStyle;
      correctAnswersCount++;
    } else {
      textAsWordList[currentWordIndex].textStyle = incorrectStyle;
      incorrectAnswersCount++;
    }

    currentWordIndex++;
    if (currentWordIndex < textAsWordList.length)
      textAsWordList[currentWordIndex].textStyle = currentStyle;
    else
      showResultPage(correctAnswersCount, incorrectAnswersCount,
          widget.duration.inSeconds);
  }

  void showResultPage(
      int correctAnswersCounter, int incorrectAnwerCount, durationInMin) {
    Result result =
        typingTest.result(correctAnswersCounter, incorrectAnwerCount);

    navigatorKey.currentState.push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ResultPage(result: result),
      ),
    );
  }

  void dispose() {
    _typerController.dispose();
    countDownSubscriber.cancel();
    super.dispose();
  }
}
