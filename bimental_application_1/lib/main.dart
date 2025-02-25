//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bimental_application_1/LoginPage';
import 'package:bimental_application_1/RegisterUserPage.dart';
import 'package:bimental_application_1/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ForgetPassword.dart';
import 'Home.dart';
import 'SignInAdm.dart';

// Lista en memoria para almacenar los usuarios registrados

List<Map<String, String>> usuariosRegistrados = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiMental',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/Home': (context) => HomePage(),
        '/ForgetPassword': (context) => ResetPasswordPage(),
        '/RegisterUserPage': (context) => RegisterUserPage(),
        '/SignInAdmin': (context) => SignInAdmin(),
      },
    );
  }
}
