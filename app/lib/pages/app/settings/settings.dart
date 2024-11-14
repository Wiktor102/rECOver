import 'package:flutter/material.dart';
import 'package:recover/common/screen_heading.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [ScreenHeading(title: "Ustawienia")],
    );
  }
}
