import 'package:applogin/home/home.dart';
import 'package:applogin/sign_up/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = _auth.currentUser;
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:user!=null?const HomeScreen(): const SignUpScreen(),
    );
  }
}
