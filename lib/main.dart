import 'package:curso_flutter/views/login_view.dart';
import 'package:curso_flutter/views/register_view.dart';
import 'package:curso_flutter/views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
      }
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                  ),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              
              
              case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if(user==null){
                return const LoginView();
              }
              if(user.emailVerified){
                return const NotesView();
              }else{
                return const VerifyEmailView();
              }

              default: 
                  return const CircularProgressIndicator();
            }
            
          },
          
        );
  }
}

enum MenuAction{
  logout
}

class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async{
              switch (value){
                
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout){
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                  }
                  break;
              }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(value: MenuAction.logout, child: Text('Log out'))
            ];
          },
          )
        ]
      ),
      body: const Text("Notes here"),


    );
  }
}


Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: const Text("Log out"),
        content: const Text("Are you sure you want to log out?"),
        actions:  [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Log out")
          ),
        ] 
      );
    } ).then((value) => value?? false);
}