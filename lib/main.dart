import 'package:curso_flutter/views/login_view.dart';
import 'package:curso_flutter/views/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
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
      initialRoute: '/login/',
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView()
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
                /* final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified?? false){
                  return const Text("Done");
                }else{
                  return const VerifyEmailView();
                } */
                return const LoginView();
              default: 
                  return const CircularProgressIndicator();
            }
            
          },
          
        );
  }
}
