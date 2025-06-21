import 'package:bimental_application_1/CofigurationUser.dart';
import 'package:bimental_application_1/LoginPage.dart';
import 'package:flutter/material.dart';
// Eliminado: import 'package:firebase_core/firebase_core.dart';
// Eliminado: import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bimental_application_1/RegisterUserPage.dart';
// Eliminado: import 'package:bimental_application_1/firebase_options.dart';
import 'ForgetPassword.dart';
import 'Home.dart';
import 'SignInAdm.dart';
// Eliminado: import 'NotificationService.dart';

// Lista en memoria para almacenar los usuarios registrados
List<Map<String, String>> usuariosRegistrados = [];

// Notificador global para manejar el tema oscuro
ValueNotifier<bool> isDarkModeEnabled = ValueNotifier(false);

// Eliminados: función y lógica relacionadas con el manejo de notificaciones en segundo plano y servicios locales

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Eliminado: inicialización de Firebase y configuración de notificaciones

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
                ? const Color.fromARGB(255, 0, 0, 0)
                : Colors.white, // Se actualiza dinámicamente
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
