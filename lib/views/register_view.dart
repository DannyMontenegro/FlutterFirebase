import 'package:curso_flutter/constans/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  final user =FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();

                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    await showErrorDialog(
                      context,
                      "Password should be at least 8 characters long",
                      "Weak password",
                    );
                  } else if (e.code == 'email-already-in-use') {
                    await showErrorDialog(
                      context,
                      "Email already in use",
                      "Already registered",
                    );
                  } else if (e.code == 'invalid-email') {
                    await showErrorDialog(
                      context,
                      "Invalid email",
                      "Invalid email",
                    );
                  }else{
                     await showErrorDialog(
                      context,
                      "Error ${e.code}",
                      "Error ocurred",
                    );
                  }
                } catch(e){
                   await showErrorDialog(
                      context,
                      e.toString(),
                      "Something unexpected happened",
                    );
                }
              },
              child: const Text("Register")),
          TextButton(
            child: const Text("Already register? Login!"),
            onPressed: () {
              //Navigator.pushNamed(context, '/register/');
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
          )
        ],
      ),
    );
  }
}
