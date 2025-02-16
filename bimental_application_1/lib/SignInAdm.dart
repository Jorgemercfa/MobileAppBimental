import 'package:flutter/material.dart';
import 'ForgetPasswordAdmin.dart';
import 'HomeAdmin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiMental Administrativo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInAdmin(),
        '/HomeAdmin': (context) => HomePageAdmin(),
        '/ForgetPasswordAdmin': (context) => ForgetPasswordPageAdmin(),
      },
    );
  }
}

class SignInAdmin extends StatefulWidget {
  const SignInAdmin({Key? key}) : super(key: key);

  @override
  _SignInAdminState createState() => _SignInAdminState();
}

class _SignInAdminState extends State<SignInAdmin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  // Lista de credenciales permitidas
  final Map<String, String> validCredentials = {
    'admin1@bimental.com': '#wrb22ed',
  };

  void signIn() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (validCredentials[email] == password) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HomePageAdmin()));
    } else {
      scaffoldKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(color: Color(0xFF1A119B)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF1A119B)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BiMental Administrativo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A119B),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              labelText: 'Correo Electrónico',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: passwordController,
              labelText: 'Contraseña',
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 250, // Ajusta el ancho del botón
              child: ElevatedButton(
                onPressed: signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A119B),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 250, // Ajusta el ancho del botón
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPasswordPageAdmin(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A119B),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                child: const Text(
                  'Olvidé contraseña',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF1A119B)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      cursorColor: const Color(0xFF1A119B),
    );
  }
}
