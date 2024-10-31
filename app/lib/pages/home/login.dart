import 'package:flutter/material.dart';
import 'package:recover/common/custom_input_decoration.dart';
import 'package:recover/pages/home/home.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});
  void onFormSubmitted(BuildContext context) async {}

  void goToSignup(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/signup');
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
            AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      autofillHints: const [AutofillHints.email],
                      //   onSaved: (v) => email = v ?? "",
                      onSaved: (v) => {},
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
                      //   onSaved: (v) => password = v ?? "",
                      onSaved: (v) => {},
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
                      onPressed: () => onFormSubmitted(context),
                      child: const Text(
                        'Kontynuuj',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'lub ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'kontynuuj bez konta',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
