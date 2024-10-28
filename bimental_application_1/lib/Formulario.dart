import 'package:flutter/material.dart';

class CuestionarioScreen extends StatefulWidget {
  @override
  _CuestionarioScreenState createState() => _CuestionarioScreenState();
}

class _CuestionarioScreenState extends State<CuestionarioScreen> {
  // Inicializamos los puntajes de cada pregunta en 0
  int pregunta1 = 0;
  int pregunta2 = 0;
  int pregunta3 = 0;

  // Función para calcular el resultado basado en los puntajes
  String calcularResultado() {
    int puntajeTotal = pregunta1 + pregunta2 + pregunta3;

    if (puntajeTotal == 0) {
      return "Usted no tiene signos de depresión";
    }
    if (puntajeTotal == 1) {
      return "Usted tiene depresión leve";
    }
    if (puntajeTotal == 2) {
      return "Usted tiene depresión grave";
    } else {
      return "Usted tiene depresión severa";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuestionarios de pre diagnóstico'),
        backgroundColor: Color(0xFF1A119B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildPregunta(
                "Me encontré enojándome por cosas bastante triviales.",
                (value) {
              setState(() {
                pregunta1 = value;
              });
            }, pregunta1),
            buildPregunta(
                "Tenía tendencia a reaccionar exageradamente a las situaciones.",
                (value) {
              setState(() {
                pregunta2 = value;
              });
            }, pregunta2),
            buildPregunta("Sentí que estaba cerca del pánico.", (value) {
              setState(() {
                pregunta3 = value;
              });
            }, pregunta3),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String resultado = calcularResultado();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultadoScreen(resultado: resultado),
                  ),
                );
              },
              child: Text('Enviar respuestas'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1A119B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPregunta(
      String texto, Function(int) onChanged, int valorSeleccionado) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(texto, style: TextStyle(fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return GestureDetector(
              onTap: () {
                onChanged(index);
              },
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: index == valorSeleccionado
                      ? Colors.green[700]
                      : Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  index.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class ResultadoScreen extends StatelessWidget {
  final String resultado;

  ResultadoScreen({required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultado"),
        backgroundColor: Color(0xFF1A119B),
      ),
      body: Center(
        child: Text(
          resultado,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
