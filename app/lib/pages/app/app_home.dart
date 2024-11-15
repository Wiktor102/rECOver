import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/user_data_model.dart';
import 'package:recover/pages/app/challanges/challanges.dart';
import 'package:recover/pages/app/error_screen.dart';
import 'package:recover/pages/app/friends/friends.dart';
import 'package:recover/pages/app/loading_screen.dart';
import 'package:recover/pages/app/navigation_bar.dart';
import 'package:recover/pages/app/quizes/quizes.dart';
import 'package:recover/pages/app/records/records.dart';
import 'package:recover/pages/app/settings/settings.dart';
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
    Center(child: SingleChildScrollView(child: RecordsPage())),
    Center(child: QuizPage()),
    Center(child: ChallengesPage()),
    Center(child: FriendsPage()),
    Center(child: Settings()),
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
    return Scaffold(
      body: Consumer<UserDataModel>(
        builder: (context, userData, child) {
          return FutureBuilder(
            future: userData.loadingFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              }

              if (snapshot.hasError) {
                return const ErrorScreen(buttonLabel: "Ponów próbę");
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
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
            ),
          ),
        ),
      ),
    );
  }
}
