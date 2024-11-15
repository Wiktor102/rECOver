import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/user_data_model.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    return AppBar(
      title: Row(
        children: [
          Icon(Symbols.account_circle, fill: 1, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(userData.username),
        ],
      ),
      actions: [
        _TopAppBarIndicator(
          icon: Icon(
            Symbols.star,
            size: 32,
            fill: 1,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          value: userData.points,
        ),
        _TopAppBarIndicator(
          icon: Icon(
            Symbols.local_fire_department,
            size: 32,
            fill: userData.todayRecords == null ? 0 : 1,
            color: Theme.of(context).colorScheme.error,
          ),
          value: userData.mainStreak + (userData.todayRecords == null ? 0 : 1),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopAppBarIndicator extends StatelessWidget {
  final Icon icon;
  final int value;

  const _TopAppBarIndicator({required this.icon, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: icon,
          ),
          Text(value.toString(), style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
