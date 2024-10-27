import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiMental',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const ChatbotPage(),
    );
  }
}

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            // Acción al presionar la flecha para retroceder
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: const Text(
          'Contenido de la página',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
