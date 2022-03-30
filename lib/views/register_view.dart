import 'package:curso_flutter/constans/routes.dart';
import 'package:curso_flutter/services/auth/auth_exceptions.dart';
import 'package:curso_flutter/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email here",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password here",
            ),
          ),
          TextButton(
              onPressed: () async {
                try {
                  final email = _email.text;
                  final password = _password.text;
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );

                  AuthService.firebase().sendEmailVerification();

                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    "Password should be at least 8 characters long",
                    "Weak password",
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    "Invalid email",
                    "Invalid email",
                  );
                } on EmailAlreadyInUseException {
                  await showErrorDialog(
                    context,
                    "Email already in use",
                    "Already registered",
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    "Registration error",
                    "Error ocurred",
                  );
                }
              },
              child: const Text("Register")),
          TextButton(
            child: const Text("Already register? Login!"),
            onPressed: () {
              //Navigator.pushNamed(context, '/register/');
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
