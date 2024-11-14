import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/user_data_model.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page')),
    Center(child: Text('Search Page')),
    Center(child: Text('Notifications Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        appBar: const TopAppBar(),
        bottomNavigationBar: AppBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        body: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    return AppBar(
      title: Text(userData.username),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              const Icon(Symbols.star),
              Text(userData.points.toString()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              const Icon(Symbols.local_fire_department),
              Text(userData.mainStreak.toString()),
            ],
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

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
            AppBottomNavigationBarItem(
              id: 0,
              selected: selectedIndex == 0,
              onTap: onItemTapped!,
              icon: Symbols.calendar_month_rounded,
            ),
            AppBottomNavigationBarItem(
              id: 1,
              selected: selectedIndex == 1,
              onTap: onItemTapped!,
              icon: Symbols.quiz,
            ),
            AppBottomNavigationBarItem(
              id: 2,
              selected: selectedIndex == 2,
              onTap: onItemTapped!,
              icon: Symbols.mountain_flag,
            ),
            AppBottomNavigationBarItem(
              id: 3,
              selected: selectedIndex == 3,
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

class AppBottomNavigationBarItem extends StatelessWidget {
  final int id;
  final bool selected;
  final ValueChanged<int> onTap;

  final IconData icon;

  const AppBottomNavigationBarItem({
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
