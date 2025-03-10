import 'package:flutter/material.dart';
import 'AnswersUser.dart';
import 'ManageAnswers.dart';

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

class HistorialResultadosScreen extends StatefulWidget {
  @override
  _HistorialResultadosScreenState createState() =>
      _HistorialResultadosScreenState();
}

class _HistorialResultadosScreenState extends State<HistorialResultadosScreen> {
  List<Map<String, dynamic>> resultados = [];

  @override
  void initState() {
    super.initState();
    _cargarResultados();
  }

  void _cargarResultados() {
    List<AnswersUser> respuestasGuardadas = ManageAnswers.getAnswers();

    List<Map<String, dynamic>> nuevosResultados =
        respuestasGuardadas.map((AnswersUser) {
      List<int> respuestas = (AnswersUser.answers as List<dynamic>)
          .map((e) => int.tryParse(e.toString()) ?? 0)
          .toList();
      return {
        'fecha': AnswersUser.timestamp.split(' ')[0],
        'hora': AnswersUser.timestamp.split(' ')[1],
        'detalles': calcularResultados(respuestas),
      };
    }).toList();

    setState(() {
      resultados = nuevosResultados;
    });
  }

  Map<String, String> calcularResultados(List<int> respuestas) {
    List<int> depresionIndices = [3, 5, 10, 13, 16, 17, 21];
    List<int> ansiedadIndices = [2, 4, 7, 9, 15, 19, 20];
    List<int> estresIndices = [1, 6, 8, 11, 12, 14, 18];

    int calcularSuma(List<int> indices) {
      return indices
          .where((i) => i - 1 < respuestas.length)
          .map((i) => respuestas[i - 1])
          .fold(0, (a, b) => a + b);
    }

    int sumaDepresion = calcularSuma(depresionIndices);
    int sumaAnsiedad = calcularSuma(ansiedadIndices);
    int sumaEstres = calcularSuma(estresIndices);

    String clasificarDepresion() {
      if (sumaDepresion >= 14) return 'Extremadamente severa';
      if (sumaDepresion >= 11) return 'Severa';
      if (sumaDepresion >= 7) return 'Moderada';
      if (sumaDepresion >= 5) return 'Leve';
      return 'Sin depresión';
    }

    String clasificarAnsiedad() {
      if (sumaAnsiedad >= 10) return 'Extremadamente severa';
      if (sumaAnsiedad >= 8) return 'Severa';
      if (sumaAnsiedad >= 5) return 'Moderada';
      if (sumaAnsiedad >= 4) return 'Leve';
      return 'Sin ansiedad';
    }

    String clasificarEstres() {
      if (sumaEstres >= 17) return 'Extremadamente severo';
      if (sumaEstres >= 13) return 'Severo';
      if (sumaEstres >= 10) return 'Moderado';
      if (sumaEstres >= 8) return 'Leve';
      return 'Sin estrés';
    }

    return {
      'Depresión': clasificarDepresion(),
      'Ansiedad': clasificarAnsiedad(),
      'Estrés': clasificarEstres(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Historial resultados', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A119B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: resultados.isEmpty
            ? Center(child: Text('No hay resultados guardados.'))
            : ListView.builder(
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  final resultado = resultados[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultadoDetalleScreen(
                            fecha: resultado['fecha'],
                            hora: resultado['hora'],
                            detalles: resultado['detalles'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A119B),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.insert_chart,
                              color: Colors.white, size: 30),
                          SizedBox(width: 16),
                          Text(
                            'Resultados ${resultado['fecha']} ${resultado['hora']}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class ResultadoDetalleScreen extends StatelessWidget {
  final String fecha;
  final String hora;
  final Map<String, String> detalles;

  ResultadoDetalleScreen({
    required this.fecha,
    required this.hora,
    required this.detalles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A119B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text('Ansiedad: ${detalles['Ansiedad']}',
                style: TextStyle(fontSize: 20, color: Color(0xFF1A119B))),
            SizedBox(height: 16),
            Text('Depresión: ${detalles['Depresión']}',
                style: TextStyle(fontSize: 20, color: Color(0xFF1A119B))),
            SizedBox(height: 16),
            Text('Estrés: ${detalles['Estrés']}',
                style: TextStyle(fontSize: 20, color: Color(0xFF1A119B))),
          ],
        ),
      ),
    );
  }
}
