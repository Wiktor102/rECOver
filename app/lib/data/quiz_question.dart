class QuizQuestion {
  late int id;
  late String question;
  late List<String> answers;
  late String explanation;
  late int correctAnswer;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.explanation,
  });

  QuizQuestion.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    question = data["question"];
    answers = List<String>.from(data["answers"]["options"]);
    correctAnswer = data["answers"]["correct_answer"];
    explanation = data["answers"]["explanation"];
  }
}
