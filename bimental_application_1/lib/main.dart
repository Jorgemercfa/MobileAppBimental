import 'package:bimental_application_1/CofigurationUser.dart';
import 'package:bimental_application_1/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bimental_application_1/RegisterUserPage.dart';
import 'package:bimental_application_1/firebase_options.dart';
import 'ForgetPassword.dart';
import 'Home.dart';
import 'SignInAdm.dart';

// Lista en memoria para almacenar los usuarios registrados
List<Map<String, String>> usuariosRegistrados = [];

// Notificador global para manejar el tema oscuro
ValueNotifier<bool> isDarkModeEnabled = ValueNotifier(false);

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
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeEnabled,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'BiMental',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: isDark
                ? const Color.fromARGB(255, 55, 55, 55)
                : Colors.white, // Se actualiza dinámicamente
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/Home': (context) => HomePage(),
            '/ForgetPassword': (context) => ResetPasswordPage(),
            '/RegisterUserPage': (context) => RegisterUserPage(),
            '/SignInAdmin': (context) => SignInAdmin(),
            '/ConfigurationUser': (context) => ConfiguracionScreen(),
          },
        );
      },
    );
  }
}
