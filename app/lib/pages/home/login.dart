import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/common/custom_input_decoration.dart';
import 'package:recover/models/auth_model.dart';
import 'package:recover/pages/home/home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void goToSignup(BuildContext context) {
    context.go('/signup');
  }

  void useLocalAccount(BuildContext context) {
    Provider.of<AuthModel>(context, listen: false).useLocalAccount();
    context.go('/app');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Home(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24, top: 4),
                child: Text(
                  'Zaloguj się',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            const LoginForm(),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () => goToSignup(context),
                child: const Text(
                  'Zarejestruj się',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'lub ',
            //       style: TextStyle(
            //         color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            //       ),
            //     ),
            //     TextButton(
            //       onPressed: () => useLocalAccount(context),
            //       child: const Text(
            //         'kontynuuj bez konta',
            //         style: TextStyle(fontWeight: FontWeight.w500),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String password = "";
  bool loading = false;

  void onFormSubmitted(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState?.validate() == false) return;
    _formKey.currentState?.save();

    setState(() {
      loading = true;
    });

    var auth = Provider.of<AuthModel>(context, listen: false);
    var error = await auth.login(username, password);

    setState(() {
      loading = false;
    });

    if (!context.mounted) return;
    if (error == null) {
      context.go('/app');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              autofillHints: const [AutofillHints.email],
              onSaved: (v) => username = v ?? "",
              decoration: CustomInputDecoration(
                context,
                labelText: "Nazwa użytkownika lub e-mail",
                hintText: '',
                prefixIcon: Icons.person,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              autofillHints: const [AutofillHints.password],
              obscureText: true,
              obscuringCharacter: '*',
              onSaved: (v) => password = v ?? "",
              decoration: CustomInputDecoration(
                context,
                labelText: "Hasło",
                hintText: 'Wpisz swoje hasło',
                prefixIcon: Icons.lock,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: loading ? null : () => onFormSubmitted(context),
              child: loading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3))
                  : const Text(
                      'Kontynuuj',
                      style: TextStyle(fontSize: 17),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
