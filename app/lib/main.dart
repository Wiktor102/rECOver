import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/auth_model.dart';
import 'package:recover/models/user_data_model.dart';
import 'package:recover/pages/app/app_home.dart';
import 'package:recover/pages/app/quizes/quiz_test.dart';
import 'package:recover/pages/app/quizes/quiz_test_result.dart';
import 'package:recover/pages/home/home.dart';
import 'package:recover/pages/home/login.dart';
import 'package:recover/pages/home/signup.dart';
import 'package:recover/pages/app/welcome/welcome.dart';

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
      builder: (context, state) => const AuthLoader(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => ChangeNotifierProxyProvider<AuthModel, UserDataModel>(
        create: (context) => UserDataModel.create(Provider.of<AuthModel>(context, listen: false)),
        update: (context, authModel, prev) => prev!..update(authModel),
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/app',
          builder: (context, state) => const AppHome(),
        ),
        GoRoute(
          path: '/app/welcome',
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          path: '/app/quiz',
          builder: (context, state) => const QuizTestPage(),
          routes: [
            GoRoute(
              path: "result",
              builder: (context, state) => const QuizTestResult(),
            ),
          ],
        ),
      ],
    )
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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6E1B)),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}

class AuthLoader extends StatefulWidget {
  const AuthLoader({super.key});

  @override
  State<AuthLoader> createState() => _AuthLoaderState();
}

class _AuthLoaderState extends State<AuthLoader> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthModel>(context, listen: false).init().then((_) {
        if (!context.mounted) return;

        var auth = Provider.of<AuthModel>(context, listen: false);
        if (auth.loggedIn) {
          context.go('/app');
        } else {
          context.go('/login');
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Home(children: [
      Center(
        child: CircularProgressIndicator(),
      )
    ]);
  }
}
