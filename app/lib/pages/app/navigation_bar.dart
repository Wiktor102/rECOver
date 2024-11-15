import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int>? onItemTapped;
  final int selectedIndex;

  const AppBottomNavigationBar({required this.selectedIndex, required this.onItemTapped, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 2.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _AppBottomNavigationBarItem(
              id: 0,
              selected: selectedIndex == 0,
              onTap: onItemTapped!,
              icon: Symbols.calendar_month_rounded,
            ),
            _AppBottomNavigationBarItem(
              id: 1,
              selected: selectedIndex == 1,
              onTap: onItemTapped!,
              icon: Symbols.quiz,
            ),
            _AppBottomNavigationBarItem(
              id: 2,
              selected: selectedIndex == 2,
              onTap: onItemTapped!,
              icon: Symbols.mountain_flag,
            ),
            _AppBottomNavigationBarItem(
              id: 3,
              selected: selectedIndex == 3,
              onTap: onItemTapped!,
              icon: Symbols.group,
            ),
            _AppBottomNavigationBarItem(
              id: 4,
              selected: selectedIndex == 4,
              onTap: onItemTapped!,
              icon: Symbols.settings,
            ),
          ],
          //   selectedItemColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _AppBottomNavigationBarItem extends StatelessWidget {
  final int id;
  final bool selected;
  final ValueChanged<int> onTap;

  final IconData icon;

  const _AppBottomNavigationBarItem({
    required this.id,
    required this.selected,
    required this.onTap,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                )
              : null,
          color: selected ? Theme.of(context).colorScheme.primaryContainer : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 36,
            fill: 1,
            color: selected ? Theme.of(context).colorScheme.onPrimaryContainer : null,
          ),
        ),
      ),
    );
  }
}
