class AnswerResult {
  const AnswerResult({this.choice, this.confidence});
  final int? choice; // null = "I don't know"
  final int? confidence; // 0 guessing, 1 fairly sure, 2 very sure
}
