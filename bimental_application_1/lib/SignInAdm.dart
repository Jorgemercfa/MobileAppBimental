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
      title: 'BiMental administravito',
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

class SignInAdmin extends StatelessWidget {
  const SignInAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(color: Color(0xFF1A119B)), // Cambia color del texto
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
            color: Color(0xFF1A119B)), // Color de los íconos
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BiMental administrativo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A119B), // Cambia color del texto principal
              ),
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              labelText: 'Correo Electronico',
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              labelText: 'Contraseña',
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón de iniciar sesión
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePageAdmin()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1A119B), // Cambia color de fondo del botón
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Iniciar Sesión',
                style:
                    TextStyle(color: Colors.white), // Color del texto del botón
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Acción al presionar "Olvidé contraseña"
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPasswordPageAdmin()));
              },
              child: const Text(
                'Olvidé contraseña',
                style: TextStyle(
                    color: Color(0xFF1A119B)), // Cambia color del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            const TextStyle(color: Color(0xFF1A119B)), // Cambia color del label
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      cursorColor: const Color(0xFF1A119B), // Cambia color del cursor
    );
  }
}
