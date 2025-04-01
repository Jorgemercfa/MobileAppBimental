import 'package:flutter/material.dart';
import 'AnswersRepository.dart';

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

  void _cargarResultados() async {
    final data = await AnswersRepository.getAllAnswersFromFirestore();

    List<Map<String, dynamic>> nuevosResultados = data.map((result) {
      // Separar fecha y hora del timestamp
      String fecha = '';
      String hora = '';
      if (result.timestamp.contains(' ')) {
        fecha = result.timestamp.split(' ')[0];
        hora = result.timestamp.split(' ')[1];
      }

      return {
        'usuario': result.userId,
        'fecha': fecha,
        'hora': hora,
        'p_depresion': result.p_depresion,
        'p_ansiedad': result.p_ansiedad,
        'p_estres': result.p_estres,
        'clasificacion': {
          'Depresión': _clasificarDepresion(result.p_depresion),
          'Ansiedad': _clasificarAnsiedad(result.p_ansiedad),
          'Estrés': _clasificarEstres(result.p_estres),
        },
      };
    }).toList();

    setState(() {
      resultados = nuevosResultados;
    });
  }

  // Funciones para clasificar los puntajes
  String _clasificarDepresion(int score) {
    if (score >= 14) return 'Extremadamente severa';
    if (score >= 11) return 'Severa';
    if (score >= 7) return 'Moderada';
    if (score >= 5) return 'Leve';
    return 'Sin depresión';
  }

  String _clasificarAnsiedad(int score) {
    if (score >= 10) return 'Extremadamente severa';
    if (score >= 8) return 'Severa';
    if (score >= 5) return 'Moderada';
    if (score >= 4) return 'Leve';
    return 'Sin ansiedad';
  }

  String _clasificarEstres(int score) {
    if (score >= 17) return 'Extremadamente severo';
    if (score >= 13) return 'Severo';
    if (score >= 10) return 'Moderado';
    if (score >= 8) return 'Leve';
    return 'Sin estrés';
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
                            detalles: resultado,
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
  final Map<String, dynamic> detalles;

  ResultadoDetalleScreen({
    required this.fecha,
    required this.hora,
    required this.detalles,
  });

  @override
  Widget build(BuildContext context) {
    final clasificacion = detalles['clasificacion'] as Map<String, dynamic>;

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
            Text(
              'Ansiedad: ${clasificacion['Ansiedad']}',
              style: TextStyle(fontSize: 20, color: Color(0xFF1A119B)),
            ),
            SizedBox(height: 16),
            Text(
              'Depresión: ${clasificacion['Depresión']}',
              style: TextStyle(fontSize: 20, color: Color(0xFF1A119B)),
            ),
            SizedBox(height: 16),
            Text(
              'Estrés: ${clasificacion['Estrés']}',
              style: TextStyle(fontSize: 20, color: Color(0xFF1A119B)),
            ),
          ],
        ),
      ),
    );
  }
}
