import 'package:flutter/material.dart';

class ScreenHeading extends StatelessWidget {
  final String title;
  final String? subtitle;

  const ScreenHeading({required this.title, this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(subtitle!, style: Theme.of(context).textTheme.titleMedium),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
