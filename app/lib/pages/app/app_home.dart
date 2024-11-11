import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/auth_model.dart';

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikacja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthModel>(context, listen: false).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Witaj w aplikacji!'),
            Text('Zalogowano pomyślnie!'),
          ],
        ),
      ),
    );
  }
}
