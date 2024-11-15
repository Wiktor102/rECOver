import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recover/common/screen_heading.dart';
import 'package:recover/models/auth_model.dart';
import 'package:recover/models/settings_model.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  final String description =
      "rECOver to nowoczesna aplikacja łącząca edukację z samorozwojem, zaprojektowana z myślą o promowaniu ekologii i ochrony środowiska. Jej celem jest inspirowanie użytkowników do podejmowania codziennych, proekologicznych działań.to nowoczesna aplikacja łącząca edukację z samorozwojem, zaprojektowana z myślą o promowaniu ekologii i ochrony środowiska. Jej celem jest inspirowanie użytkowników do podejmowania codziennych, proekologicznych działań.";

  void onThemeChanged(BuildContext context, AppThemeMode? value) {
    Provider.of<SettingsModel>(context, listen: false).changeTheme(value ?? AppThemeMode.system);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ScreenHeading(title: "Ustawienia"),
          ListTile(
            title: const Text("Motyw"),
            leading: const Icon(Icons.palette),
            trailing: Consumer<SettingsModel>(builder: (context, settings, child) {
              return DropdownButton<AppThemeMode>(
                value: settings.theme,
                items: const [
                  DropdownMenuItem(value: AppThemeMode.light, child: Text('Jasny')),
                  DropdownMenuItem(value: AppThemeMode.dark, child: Text('Ciemny')),
                  DropdownMenuItem(value: AppThemeMode.system, child: Text('Systemowy')),
                ],
                onChanged: (value) => onThemeChanged(context, value),
              );
            }),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, size: 28),
                      const SizedBox(width: 16),
                      Text("O aplikacji", style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Opis", style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(description, style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Autorzy", style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text("Wiktor Golicz", style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text("Maksymilian Gruszka", style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Wersja: Alpha 1.0", style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              Provider.of<AuthModel>(context, listen: false).logout();
              context.go("/login");
            },
            icon: const Icon(Icons.exit_to_app),
            label: const Text("Wyloguj się"),
          ),
        ],
      ),
    );
  }
}
