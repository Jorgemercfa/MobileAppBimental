import 'package:bimental_application_1/userRespuesta.dart';
import 'package:flutter/material.dart';
import 'Chatbot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiMental',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: './',
      routes: {
        './': (context) => HomePage(),
        './Chatbot': (context) => ChatScreen(),
        './userRespuesta.dart': (context) => HistorialResultadosScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.green),
            onPressed: () {
              // Acción al presionar el botón de salir
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BiMental',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A119B),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón de Chatbot
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A119B),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Chatbot'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón de Pre diagnóstico
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistorialResultadosScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A119B),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Pre diagnóstico'),
            ),
          ],
        ),
      ),
    );
  }
}
