import 'package:curso_flutter/constans/routes.dart';
import 'package:curso_flutter/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify email")),
      body: Column(children: [
        const Text(
            "Verification email has been sent, please check your inbox and click the link"),
        const Text(
            "If you haven't received the verification email yet, press the button below"),
        TextButton(
          child: const Text("Send email"),
          onPressed: () async {
            await AuthService.firebase().sendEmailVerification();
          },
        ),
        TextButton(
          child: const Text("Restart"),
          onPressed: () async {
            await AuthService.firebase().logOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
        )
      ]),
    );
  }
}
