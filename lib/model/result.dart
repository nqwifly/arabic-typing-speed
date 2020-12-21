class Result {
  int correctAnswersCount;
  int incorrectAnswersCount;
  int typingAccuracy;
  double wpm;

  calculateTypingAccuracy() {
    typingAccuracy = correctAnswersCount <= 0
        ? 0
        : ((correctAnswersCount /
                    (correctAnswersCount + incorrectAnswersCount)) *
                100)
            .round();
  }

  calculateWpm(int durationInSec) {
    wpm = (correctAnswersCount) / (durationInSec / 60);
  }

  Result({this.correctAnswersCount, this.incorrectAnswersCount});
}
