import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Ejemplo de Color en Flutter"),
          backgroundColor: Color(0xFF1A119B), // Usa el color personalizado
        ),
        body: Center(
          child: Container(
            width: 200,
            height: 200,
            color: Color(0xFF1A119B), // Usa el color en el fondo del Container
            child: Center(
              child: Text(
                "Hola Flutter!",
                style: TextStyle(color: Colors.white), // Texto en color blanco
              ),
            ),
          ),
        ),
      ),
    );
  }
}
