import 'package:flutter/material.dart';

class ResultadoScreen extends StatelessWidget {
  final String resultado;

  ResultadoScreen({required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de pre diagnostico'),
        backgroundColor: const Color(0xFF1A119B),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Los resultados del cuestionario son:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                resultado,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Regresar'),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF1A119B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
