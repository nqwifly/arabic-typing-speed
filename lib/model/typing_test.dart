import 'package:arabic_typing_speed/model/result.dart';
import 'package:arabic_typing_speed/model/text_word.dart';
import '../constants.dart';

class TypingTest {
  int duration;
  String text;

  List<TextWord> transformTextToList() {
    return text
        .split(' ')
        .map((word) => TextWord(word: word, textStyle: initialStyle))
        .toList();
  }

  Result result(int correctAnswersCount, int incorrectAnswersCount) {
    Result result = Result(
        correctAnswersCount: correctAnswersCount,
        incorrectAnswersCount: incorrectAnswersCount);
    result.calculateTypingAccuracy();
    result.calculateWpm(duration);

    return result;
  }

  TypingTest({this.duration, this.text});
}
