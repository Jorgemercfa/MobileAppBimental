import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historial de Resultados',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HistorialResultadosScreen(),
    );
  }
}

class HistorialResultadosScreen extends StatelessWidget {
  final List<Map<String, String>> resultados = [
    {'id': '1', 'fecha': '31/10/2024'},
    {'id': '2', 'fecha': '03/11/2024'},
    {'id': '3', 'fecha': '04/11/2024'},
    {'id': '4', 'fecha': '07/11/2024'},
    {'id': '5', 'fecha': '10/11/2024'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial resultados',
            style: TextStyle(color: Colors.blue[800])),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue[800]),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: resultados.map((resultado) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultadoDetalleScreen(
                      id: resultado['id']!,
                      fecha: resultado['fecha']!,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        resultado['id']!,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Resultados ${resultado['fecha']}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ResultadoDetalleScreen extends StatelessWidget {
  final String id;
  final String fecha;

  ResultadoDetalleScreen({required this.id, required this.fecha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados', style: TextStyle(color: Colors.blue[800])),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue[800]),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resultados',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800]),
            ),
            SizedBox(height: 24),
            Text(
              'Anciedad leve',
              style: TextStyle(fontSize: 20, color: Colors.blue[800]),
            ),
            Text(
              'Por lo cuál es un buen indicador',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
            SizedBox(height: 16),
            Text(
              'Depresión grave',
              style: TextStyle(fontSize: 20, color: Colors.blue[800]),
            ),
            Text(
              'Esto puede ser perjudicial para su día a día',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
            SizedBox(height: 16),
            Text(
              'Estrés no tiene',
              style: TextStyle(fontSize: 20, color: Colors.blue[800]),
            ),
            Text(
              'Por lo que se recomienda tomar precauciones',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
            SizedBox(height: 32),
            Text(
              'Fecha: $fecha',
              style: TextStyle(fontSize: 18, color: Colors.blue[800]),
            ),
            Text(
              'Hora: 6:30pm',
              style: TextStyle(fontSize: 18, color: Colors.blue[800]),
            ),
          ],
        ),
      ),
    );
  }
}
