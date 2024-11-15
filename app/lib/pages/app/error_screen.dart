import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/auth_model.dart';
import 'package:go_router/go_router.dart';
import 'package:recover/models/user_data_model.dart';
import 'package:recover/pages/home/home.dart';

class ErrorScreen extends StatelessWidget {
  final String buttonLabel;

  const ErrorScreen({required this.buttonLabel, super.key});

  @override
  Widget build(BuildContext context) {
    return Home(
      children: [
        Column(
          children: [
            Icon(
              Icons.error,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              "Podczas łądowania danych wystąpił błąd. Sprawdź połączenie i spróbuj ponownie.",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: () {
                    Provider.of<UserDataModel>(context, listen: false).init();
                  },
                  child: Text(buttonLabel),
                ),
                OutlinedButton(
                  onPressed: () {
                    Provider.of<AuthModel>(context, listen: false).logout();
                    context.go("/login");
                  },
                  child: Text("Wyloguju się"),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
