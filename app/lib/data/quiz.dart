import 'package:recover/data/quiz_question.dart';

class Quiz {
  int id;
  List<QuizQuestion> questions = [];
  bool completed = false;

  Quiz({required this.id, required this.questions, required this.completed});
}
