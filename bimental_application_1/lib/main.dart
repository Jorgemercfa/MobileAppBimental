import 'package:bimental_application_1/CofigurationUser.dart';
import 'package:bimental_application_1/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bimental_application_1/firebase_options.dart'; // ✅ Descomentado
import 'package:bimental_application_1/RegisterUserPage.dart';
import 'ForgetPassword.dart';
import 'Home.dart';
import 'SignInAdm.dart';

List<Map<String, String>> usuariosRegistrados = [];

ValueNotifier<bool> isDarkModeEnabled = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inicialización con firebase_options
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
            scaffoldBackgroundColor:
                isDark ? const Color.fromARGB(255, 0, 0, 0) : Colors.white,
            textTheme: TextTheme(
              bodyLarge:
                  TextStyle(color: isDark ? Colors.white : Color(0xFF1A119B)),
              bodyMedium:
                  TextStyle(color: isDark ? Colors.white : Color(0xFF1A119B)),
              bodySmall:
                  TextStyle(color: isDark ? Colors.white : Color(0xFF1A119B)),
            ),
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
