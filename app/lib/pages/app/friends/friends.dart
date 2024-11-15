import 'package:flutter/material.dart';
import 'package:recover/common/screen_heading.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScreenHeading(title: "Znajomi"),
        Expanded(
          child: Center(
            child: Text("Możliwość konkurowania ze znajomymi pojawi się w pełnej wersji aplikacji."),
          ),
        ),
      ],
    );
  }
}
