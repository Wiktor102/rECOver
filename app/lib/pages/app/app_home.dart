import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/auth_model.dart';
import 'package:recover/models/user_data_model.dart';

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataModel>(
      builder: (context, userData, child) {
        return FutureBuilder(
          future: userData.loadingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Wystąpił błąd podczas ładowania danych'));
            }

            return Builder(builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (userData.tags == null) context.go('/app/welcome');
              });
              return child!;
            });
          },
        );
      },
      child: Scaffold(
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
      ),
    );
  }
}
