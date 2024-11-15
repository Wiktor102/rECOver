import 'package:flutter/material.dart';
import 'package:recover/pages/home/home.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Home(
      children: [
        Column(
          children: [
            const SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 24),
            Text(
              "Ładowanie...",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ],
    );
  }
}
