import 'package:flutter/material.dart';
import 'package:recover/common/screen_heading.dart';
import 'package:recover/pages/app/records/transport_survey.dart';

class Records extends StatelessWidget {
  const Records({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: ListView(
        children: [
          const ScreenHeading(
            title: "rECOrdy",
            subtitle: "Wypełniaj codziennie poniższą ankietę i zdobywaj punkty!",
          ),
          const TransportSurvey(),
          const SizedBox(height: 32),
          Text(
            "Pozostałe rECOrdy",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ListTile(
            title: const Text("Jakieś coś"),
            leading: const Tooltip(
              message: "Tutaj jest ikona",
              child: Icon(Icons.help, fill: 1),
            ),
            trailing: Checkbox(
              value: false,
              onChanged: (bool? value) {},
            ),
          ),
        ],
      ),
    );
  }
}
