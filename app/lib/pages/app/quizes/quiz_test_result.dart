import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/user_data_model.dart';

class QuizTestResult extends StatefulWidget {
  const QuizTestResult({super.key});

  @override
  State<QuizTestResult> createState() => _QuizTestResultState();
}

class _QuizTestResultState extends State<QuizTestResult> {
  List<int>? _answers;
  int _earnedPoints = 0;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _answers = (GoRouterState.of(context).extra! as List<int?>).nonNulls.toList();

        var quiz = Provider.of<UserDataModel>(context, listen: false).todayQuiz;
        var correctAnswers = quiz!.questions.map((e) => e.correctAnswer).toList();

        for (int i = 0; i < correctAnswers.length; i++) {
          if (_answers![i] == correctAnswers[i]) {
            _earnedPoints = _earnedPoints + 1;
          }

          if (_earnedPoints == 0) _earnedPoints = 1;
          if (_earnedPoints == 3) _earnedPoints = 5;
        }
      });
    });
    super.initState();
  }

  void back() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wynik quizu'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Consumer<UserDataModel>(builder: (context, value, child) {
          var quiz = value.todayQuiz!;

          if (_answers == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Twój wynik to: $_earnedPoints',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text('Podsumowanie', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: quiz.questions.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index > 0) const SizedBox(height: 32),
                          Row(
                            children: [
                              Icon(
                                _answers![index] == quiz.questions[index].correctAnswer
                                    ? Icons.check
                                    : Icons.close,
                                size: 36,
                                color: _answers![index] == quiz.questions[index].correctAnswer
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  quiz.questions[index].question,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 52, top: 4, right: 8),
                            child: Text(quiz.questions[index].explanation, softWrap: true),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: FilledButton(
                    onPressed: back,
                    child: const Text('Ok'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
