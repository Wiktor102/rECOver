import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:recover/models/user_data_model.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  void startQuiz(BuildContext context) {
    context.push("/app/quiz");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataModel>(builder: (context, userData, child) {
      if (userData.todayQuiz == null) return buildNoQuizAvailable(context);
      if (userData.todayQuiz!.completed) return buildQuizAlreadySolved(context);
      return buildQuizAvailable(context);
    });
  }

  Widget buildQuizAlreadySolved(BuildContext context) {
    return _QuizStatus(
      bgColor: Theme.of(context).colorScheme.primaryContainer,
      fgColor: Theme.of(context).colorScheme.onPrimaryContainer,
      icon: Icons.check,
      label: "Brawo! Dzisiaj rozwiązałeś już quiz. Zapraszamy jutro.",
    );
  }

  Widget buildNoQuizAvailable(BuildContext context) {
    return _QuizStatus(
      bgColor: Theme.of(context).colorScheme.errorContainer,
      fgColor: Theme.of(context).colorScheme.onErrorContainer,
      icon: Symbols.hourglass,
      label: "Przepraszamy, dzisiaj żaden quiz nie jest dostępny. Zajrzyj tu ponownie jutro.",
    );
  }

  Widget buildQuizAvailable(BuildContext context) {
    return _QuizStatus(
      bgColor: Theme.of(context).colorScheme.tertiaryContainer,
      fgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      icon: Symbols.quiz,
      child: Column(
        children: [
          Text(
            "Nie rozwiązałeś jeszcze dzisiejszego quizu. Spróbuj teraz i zdobądź punkty!",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => startQuiz(context),
            label: const Text("Rozpoczni quiz"),
            icon: const Icon(Icons.play_arrow),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizStatus extends StatelessWidget {
  final Color bgColor;
  final Color fgColor;
  final String? label;
  final Widget? child;
  final IconData icon;

  const _QuizStatus({
    required this.bgColor,
    required this.fgColor,
    required this.icon,
    this.label,
    this.child,
    super.key,
  })  : assert(label != null || child != null),
        assert(label == null || child == null);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            icon,
            size: 72,
            color: fgColor,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: label != null
                ? Text(
                    label!,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: fgColor),
                    textAlign: TextAlign.center,
                  )
                : child,
          ),
        ],
      ),
    );
  }
}
