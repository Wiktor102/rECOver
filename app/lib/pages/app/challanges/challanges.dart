import 'package:flutter/material.dart';
import 'package:recover/common/screen_heading.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScreenHeading(
          title: "Wyzwania",
          subtitle: "Wykonuj wyzwania i zdobywaj dodatkowe punkty!",
        ),
        Expanded(
          child: Center(
            child: Text("Challange pojawią się w pełnej wersji aplikacji."),
          ),
        ),
      ],
    );
  }
}
