import 'package:firebase_core/firebase_core.dart';
import 'package:fiteat/screens/signup-signin/login_screen.dart';
import 'package:flutter/material.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

//Color(0xFFfc7b78) - red

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email and pass login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        splashColor: Color(0xFFfc7b78),
      ),
      home: LoginScreen(),
    );
  }
}