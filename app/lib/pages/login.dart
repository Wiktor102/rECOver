import 'package:flutter/material.dart';
import 'package:recover/common/custom_input_decoration.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});
  void onFormSubmitted(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const Center(child: Text("")),
            Positioned(
              top: 0,
              height: MediaQuery.of(context).size.height - 350 + 40,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    opacity: 0.8,
                    image: AssetImage('assets/bg.png'),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height - 350,
              height: 350,
              width: MediaQuery.of(context).size.width,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(180 / 360),
                child: ClipPath(
                  clipper: Clipper(),
                  child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Transform.translate(
                  offset: Offset(0, MediaQuery.of(context).size.height * 0.13),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              onPressed: () => onFormSubmitted(context),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(Clipper oldClipper) => false;
}
