import 'package:bimental_application_1/session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'AnswersRepository.dart';
import 'AnswersUser.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Resultados',
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
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _cargarResultados();
  }

  void _cargarResultados() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final userId = await SessionService.getUserId();
      if (userId == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'Debes iniciar sesión para ver tus resultados';
        });
        return;
      }

      // <-- Aquí obtenemos List<AnswersUser> y la convertimos a List<Map<String,dynamic>>
      List<AnswersUser> respuestasGuardadas =
          await AnswersRepository.getAnswersFromFirestore(userId);

      List<Map<String, dynamic>> nuevosResultados =
          respuestasGuardadas.map((entry) {
        // timestamp ya viene formateado por AnswersRepository (si es el caso)
        final timestamp = entry.timestamp ?? '';
        String fecha = '';
        String hora = '';

        if (timestamp.isNotEmpty && timestamp.contains(' ')) {
          final parts = timestamp.split(' ');
          fecha = parts.isNotEmpty ? parts[0] : '';
          hora = parts.length > 1 ? parts.sublist(1).join(' ') : '';
        } else {
          // Si no tiene espacio, ponemos todo en fecha
          fecha = timestamp;
          hora = '';
        }

        final clasificacionDepresion =
            AnswersRepository.clasificarDepresion(entry.p_depresion);
        final clasificacionAnsiedad =
            AnswersRepository.clasificarAnsiedad(entry.p_ansiedad);
        final clasificacionEstres =
            AnswersRepository.clasificarEstres(entry.p_estres);

        return {
          'timestamp': timestamp,
          'fecha': fecha,
          'hora': hora,
          'p_depresion': entry.p_depresion,
          'p_ansiedad': entry.p_ansiedad,
          'p_estres': entry.p_estres,
          'clasificacion': {
            'Depresión': clasificacionDepresion,
            'Ansiedad': clasificacionAnsiedad,
            'Estrés': clasificacionEstres,
          },
        };
      }).toList();

      setState(() {
        resultados = nuevosResultados;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            'Error al cargar tus resultados. Por favor, intenta nuevamente.';
        if (kDebugMode) {
          errorMessage = 'Error: ${e.toString()}';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis resultados', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A119B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : resultados.isEmpty
                    ? Center(
                        child: Text(
                          'No hay resultados guardados.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: resultados.length,
                        itemBuilder: (context, index) {
                          final resultado = resultados[index];
                          final fecha = resultado['fecha'] ?? '';
                          final hora = resultado['hora'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultadoDetalleScreen(
                                    fecha: fecha,
                                    hora: hora,
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
                                    fecha.isNotEmpty
                                        ? '$fecha $hora'
                                        : 'Sin fecha',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
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
    final clasificacion =
        (detalles['clasificacion'] as Map?)?.cast<String, dynamic>() ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del resultado',
            style: TextStyle(color: Colors.white)),
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
              'Nivel de ansiedad: ${clasificacion['Ansiedad'] ?? 'N/A'}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 24),
            Text(
              'Nivel de depresión: ${clasificacion['Depresión'] ?? 'N/A'}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 24),
            Text(
              'Nivel de estrés: ${clasificacion['Estrés'] ?? 'N/A'}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
