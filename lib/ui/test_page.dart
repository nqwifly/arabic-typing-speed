import 'dart:async';
import 'package:flutter/material.dart';

import 'package:arabic_typing_speed/main.dart';
import 'package:arabic_typing_speed/model/result.dart';
import 'package:arabic_typing_speed/model/typing_test.dart';
import 'package:arabic_typing_speed/model/text_word.dart';
import 'package:arabic_typing_speed/ui/result_page.dart';
import 'package:arabic_typing_speed/constants.dart';

import 'package:countdown/countdown.dart';

import '../app_theme.dart';

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
  List<String> userTypedWordsList;
  int currentWordIndex = 0;

  int correctAnswersCount = 0;
  int incorrectAnswersCount = 0;

  TextEditingController _typerController = TextEditingController();

  double durationInMin;
  CountDown cd;
  StreamSubscription<Duration> countDownSubscriber;
  bool _isTimerStarted = false;
  int currentTimerCount;

  @override
  void initState() {
    _typerController.addListener(typingWatcher);
    // _countDownController.pause();

    durationInMin = widget.duration.inSeconds / 60;

    typingTest = TypingTest(durationInMin: durationInMin, text: textOptions[0]);
    textAsWordList = typingTest.transformTextToList();
    userTypedWordsList = [];

    cd = CountDown(widget.duration, refresh: Duration(seconds: 1));
    currentTimerCount = widget.duration.inSeconds;
    textAsWordList[currentWordIndex].textStyle = currentStyle;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _countDownController.pause();
    return Container(
      color: AppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              getAppBarUI(),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: currentTimerCount /
                                      widget.duration.inSeconds,
                                  strokeWidth: 3,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                  backgroundColor: Colors.grey,
                                ),
                                Text('$currentTimerCount'),
                              ],
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 100,
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
    );
  }

  Widget getTypingBar() {
    return Container(
      decoration: BoxDecoration(
        color: HexColor('#F8FAFB'),
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
            color: HexColor('#B9BABC'),
          ),
          contentPadding: EdgeInsets.all(10),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.2,
            color: HexColor('#B9BABC'),
          ),
        ),
      ),
    );
  }

  void dispose() {
    _typerController.dispose();
    countDownSubscriber.cancel();
    super.dispose();
  }

  startCountDown() async {
    countDownSubscriber = cd.stream.listen(null);
    countDownSubscriber.onData((data) {
      setState(() {
        currentTimerCount = data.inSeconds;
      });
    });
    countDownSubscriber.onDone(() {
      showResultPage(correctAnswersCount, incorrectAnswersCount, durationInMin);
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
    userTypedWordsList.add(typedValue.substring(0, typedValue.length - 1));
    if (userTypedWordsList[currentWordIndex] ==
        textAsWordList[currentWordIndex].word) {
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
      showResultPage(correctAnswersCount, incorrectAnswersCount, durationInMin);
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
}

Widget getAppBarUI() {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'اختبر',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.2,
                  color: AppTheme.nearlyWhite,
                ),
              ),
              Text(
                'سرعة طباعتك',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  letterSpacing: 0.27,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 60,
          height: 60,
          child: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
              child: Hero(
                tag: 'flash_icon',
                child: Container(
                    child: Image.asset(
                  'assets/electric.png',
                )),
              )),
        ),
      ],
    ),
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
