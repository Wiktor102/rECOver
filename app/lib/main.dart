import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/auth_model.dart';
import 'package:recover/pages/app/app_home.dart';
import 'package:recover/pages/home/login.dart';
import 'package:recover/pages/home/signup.dart';

void main() {
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final _router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      redirect: (BuildContext context, GoRouterState state) {
        var auth = Provider.of<AuthModel>(context);
        if (auth.loggedIn || auth.localAccount) return '/app';
        return '/login';
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/app',
      builder: (context, state) => const AppHome(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MaterialApp.router(
        title: 'rECOver',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 11, 110, 27)),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
