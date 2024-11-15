import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recover/common/screen_heading.dart';
import 'package:recover/models/auth_model.dart';
import 'package:recover/models/settings_model.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  void onThemeChanged(BuildContext context, AppThemeMode? value) {
    Provider.of<SettingsModel>(context, listen: false).changeTheme(value ?? AppThemeMode.system);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const Expanded(child: SizedBox.expand()),
        OutlinedButton(
          onPressed: () {
            Provider.of<AuthModel>(context, listen: false).logout();
            context.go("/login");
          },
          child: const Text("Wyloguj się"),
        ),
      ],
    );
  }
}
