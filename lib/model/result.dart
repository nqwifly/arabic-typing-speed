class Result{
  int correctAnswersCount;
  int incorrectAnswersCount;
  int typingAccuracy;
  double wpm;

  calculateTypingAccuracy(double durationInMin){
    typingAccuracy= ((correctAnswersCount / (correctAnswersCount+incorrectAnswersCount))
        * 100).round();
  }

  calculateWpm(double durationInMin){
    wpm= (correctAnswersCount+incorrectAnswersCount) / durationInMin;
  }

  Result({this.correctAnswersCount, this.incorrectAnswersCount});
}