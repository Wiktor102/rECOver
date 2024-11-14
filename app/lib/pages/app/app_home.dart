import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/user_data_model.dart';
import 'package:recover/pages/app/navigation_bar.dart';
import 'package:recover/pages/app/top_bar.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0;

  final PageController _controller = PageController();
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page')),
    Center(child: Text('Search Page')),
    Center(child: Text('Notifications Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
        body: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
      ),
    );
  }
}
