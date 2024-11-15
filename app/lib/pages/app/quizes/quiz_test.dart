import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recover/data/quiz_question.dart';
import 'package:recover/models/user_data_model.dart';

class QuizTestPage extends StatefulWidget {
  const QuizTestPage({super.key});

  @override
  State<QuizTestPage> createState() => _QuizTestPageState();
}

class _QuizTestPageState extends State<QuizTestPage> {
  List<int?> selectedAnswers = [null, null, null];

  void onAnswerSelected(int questionIndex, int answerIndex) {
    setState(() {
      selectedAnswers[questionIndex] = answerIndex;
    });
  }

  void finishQuiz(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context, listen: false);
    assert(!selectedAnswers.contains(null));
    userData.checkQuiz(selectedAnswers.nonNulls.toList());
    if (context.canPop()) context.pop();
    context.push("/app/quiz/result", extra: selectedAnswers);
  }

  void cancelQuiz(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wyjść?'),
          content: const Text('Czy jesteś pewien, że chcesz przerwać quiz?'),
          actions: <Widget>[
            FilledButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Nie'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                if (context.canPop()) context.pop();
              },
              child: const Text('Tak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz dnia"),
        leading: BackButton(onPressed: () => cancelQuiz(context)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedAnswers.contains(null) ? null : () => finishQuiz(context),
        backgroundColor: selectedAnswers.contains(null) ? Theme.of(context).colorScheme.onSurfaceVariant : null,
        foregroundColor:
            selectedAnswers.contains(null) ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
        child: const Icon(Icons.check),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserDataModel>(builder: (context, userData, child) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return _QuizQuestion(
                question: userData.todayQuiz!.questions[index],
                selectedAnswer: selectedAnswers[index],
                onAnswerSelected: (answerIndex) => onAnswerSelected(index, answerIndex),
              );
            },
            itemCount: userData.todayQuiz!.questions.length,
          );
        }),
      ),
    );
  }
}

class _QuizQuestion extends StatelessWidget {
  final QuizQuestion question;

  final Function onAnswerSelected;
  final int? selectedAnswer;

  const _QuizQuestion({
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _QuizAnswer(
                  label: question.answers[index],
                  selected: selectedAnswer == index,
                  onAnswerSelected: () => onAnswerSelected(index),
                );
              },
              itemCount: question.answers.length,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizAnswer extends StatelessWidget {
  final bool selected;
  final String label;
  final Function onAnswerSelected;

  const _QuizAnswer({required this.label, required this.selected, required this.onAnswerSelected, super.key});

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return FilledButton(
        onPressed: () {},
        child: Text(label),
      );
    }

    return OutlinedButton(
      onPressed: () => onAnswerSelected(),
      child: Text(label),
    );
  }
}
