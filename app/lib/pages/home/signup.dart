import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recover/common/custom_input_decoration.dart';
import 'package:recover/pages/home/home.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  void goToLogin(BuildContext context) {
    context.go('/');
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
                  'Zarejestruj się',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            SignupForm(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () => goToLogin(context),
                child: const Text(
                  'Mam już konto',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String email = '';
  String nick = '';
  String password = '';
  String repeatPassword = '';
  bool loading = false;

  String? validateEmail(value) {
    if (value == null || value.isEmpty) {
      return 'Adres e-mail nie może być pusty';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Niepoprawny adres e-mail';
    }
    return null;
  }

  String? validatePasswordStrength(value) {
    if (value == null || value.isEmpty) {
      return 'Hasło nie może być puste';
    } else if (value.length < 8) {
      return 'Hasło musi mieć co najmniej 8 znaków';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Hasło musi zawierać co najmniej jedną wielką literę';
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Hasło musi zawierać co najmniej jedną małą literę';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Hasło musi zawierać co najmniej jedną cyfrę';
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Hasło musi zawierać co najmniej jeden znak specjalny';
    }
    return null;
  }

  String? checkIfPasswordsMatch(value) {
    if (value != password) {
      return 'Hasła nie są takie same';
    }

    return null;
  }

  void onFormSubmitted(BuildContext context) async {
    widget._formKey.currentState?.save();
    if (widget._formKey.currentState?.validate() == false) return;

    setState(() {
      loading = true;
    });

    final String body = json.encode({
      "mail": email,
      "username": nick,
      "password": password,
      "password2": repeatPassword,
      "terms": true, // akceptacja regulaminu
      "privacy": true // akceptacja polityki prywatności
    });

    Uri uri = Uri.parse("https://api.recover.wiktorgolicz.pl/index.php/auth/signup");
    if (!kReleaseMode && false) {
      uri = Uri.parse("http://10.0.2.2:3001/recover/index.php/auth/signup");
    }

    try {
      final http.Response response =
          await http.post(uri, body: body, headers: {"Content-Type": "application/json"});
      dynamic decodedResponse;

      try {
        decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      } catch (e) {
        throw Exception();
      }

      if (response.statusCode == 400 || response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Nazwa użytkownika jest już zajęta lub istnieje konto powiązane z tym adresem e-mail."),
        ));
        return;
      }

      if (response.statusCode != 200) {
        throw Exception(decodedResponse.error);
      }

      context.go('/login');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Rejestracja pomyślna. Teraz możesz sie zalogować."),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Wystąpił nieznany błąd. Przepraszamy. Proszę spróbować później."),
      ));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: widget._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              autofillHints: const [AutofillHints.nickname],
              onSaved: (v) => nick = v ?? "",
              decoration: CustomInputDecoration(
                context,
                labelText: "Nazwa użytkownika",
                hintText: '',
                prefixIcon: Icons.person,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              autofillHints: const [AutofillHints.email],
              onSaved: (v) => email = v ?? "",
              validator: validateEmail,
              decoration: CustomInputDecoration(
                context,
                labelText: "Adres e-mail",
                hintText: '',
                prefixIcon: Icons.email,
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
              validator: validatePasswordStrength,
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
            TextFormField(
              autofillHints: const [AutofillHints.password],
              obscureText: true,
              obscuringCharacter: '*',
              onSaved: (v) => repeatPassword = v ?? "",
              validator: checkIfPasswordsMatch,
              decoration: CustomInputDecoration(
                context,
                labelText: "Powtórz hasło",
                hintText: 'Wpisz swoje hasło ponownie',
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
                'Zarejestruj się',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
