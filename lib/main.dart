import 'package:curso_flutter/constans/routes.dart';
import 'package:curso_flutter/services/auth/auth_service.dart';
import 'package:curso_flutter/views/login_view.dart';
import 'package:curso_flutter/views/notes_view.dart';
import 'package:curso_flutter/views/register_view.dart';
import 'package:curso_flutter/views/verify_email_view.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: homeRoute,
        routes: {
          homeRoute: (context) => const HomePage(),
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          notesRoute: (context) => const NotesView(),
          verifyEmailRoute: (context) => const VerifyEmailView(),
        });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user == null) {
              return const LoginView();
            }
            if (user.isEmailVerified) {
              return const NotesView();
            } else {
              return const VerifyEmailView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
