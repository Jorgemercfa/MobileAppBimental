import 'package:flutter/material.dart';

class CuestionarioDASS21Screen extends StatefulWidget {
  @override
  _CuestionarioDASS21ScreenState createState() =>
      _CuestionarioDASS21ScreenState();
}

class _CuestionarioDASS21ScreenState extends State<CuestionarioDASS21Screen> {
  // Lista para almacenar los puntajes de las 21 preguntas
  List<int> respuestas = List.filled(21, 0);

  // Lista de textos personalizados para cada pregunta
  final List<String> textosPreguntas = [
    "Pregunta 1: Me ha costado mucho descargar la tensión.",
    "Pregunta 2: Me di cuenta que tenía la boca seca.",
    "Pregunta 3: No podía sentir ningún sentimiento positivo.",
    "Pregunta 4: Se me hizo difícil respirar.",
    "Pregunta 5: Se me hizo difícil tomar la iniciativa para hacer cosas.",
    "Pregunta 6: Reaccioné exageradamente en ciertas situaciones.",
    "Pregunta 7: Sentí que mis manos temblaban.",
    "Pregunta 8: He sentido que estaba gastando una gran cantidad de energía.",
    "Pregunta 9: Estaba preocupado por situaciones en las cuales podía tener pánico o en las que podría hacer el ridículo.",
    "Pregunta 10: Sentí que estaba constantemente en tensión.",
    "Pregunta 11: Me he sentido inquieto.",
    "Pregunta 12: Se me hizo difícil relajarme.",
    "Pregunta 13: Me sentí triste y deprimido.",
    "Pregunta 14: No toleré nada que no me permitiera continuar con lo que estaba haciendo.",
    "Pregunta 15: Sentí que estaba al punto de pánico.",
    "Pregunta 16: No me pude entusiasmar por nada.",
    "Pregunta 17: Sentí que valía muy poco como persona.",
    "Pregunta 18: He tendido a sentirme enfadado con facilidad.",
    "Pregunta 19: Sentí los latidos de mi corazón a pesar de no haber hecho ningún esfuerzo físico.",
    "Pregunta 20: Tuve miedo sin razón.",
    "Pregunta 21: Sentí que la vida no tenía ningún sentido.",
  ];

  // Índices de las preguntas de cada subescala
  final depresionIndices = [2, 4, 9, 12, 15, 16, 20];
  final ansiedadIndices = [1, 3, 6, 8, 14, 18, 19];
  final estresIndices = [0, 5, 7, 10, 11, 13, 17];

  // Función para calcular el resultado de cada subescala
  String calcularResultado() {
    int depresionScore =
        depresionIndices.map((i) => respuestas[i]).reduce((a, b) => a + b);
    int ansiedadScore =
        ansiedadIndices.map((i) => respuestas[i]).reduce((a, b) => a + b);
    int estresScore =
        estresIndices.map((i) => respuestas[i]).reduce((a, b) => a + b);

    String depresionResultado = obtenerNivel(depresionScore, "Depresión");
    String ansiedadResultado = obtenerNivel(ansiedadScore, "Ansiedad");
    String estresResultado = obtenerNivel(estresScore, "Estrés");

    return "$depresionResultado\n$ansiedadResultado\n$estresResultado";
  }

  // Función para obtener el nivel de severidad basado en el puntaje y tipo
  String obtenerNivel(int puntaje, String tipo) {
    switch (tipo) {
      case "Depresión":
        if (puntaje <= 4) return "No tiene depresión";
        if (puntaje <= 6) return "Depresión leve";
        if (puntaje <= 10) return "Depresión moderada";
        if (puntaje <= 13) return "Depresión severa";
        return "Depresión extremadamente severa";
      case "Ansiedad":
        if (puntaje <= 3) return "No tiene ansiedad";
        if (puntaje == 4) return "Ansiedad leve";
        if (puntaje <= 7) return "Ansiedad moderada";
        if (puntaje <= 9) return "Ansiedad severa";
        return "Ansiedad extremadamente severa";
      case "Estrés":
        if (puntaje <= 7) return "No tiene estrés";
        if (puntaje <= 9) return "Estrés leve";
        if (puntaje <= 12) return "Estrés moderado";
        if (puntaje <= 16) return "Estrés severo";
        return "Estrés extremadamente severo";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuestionario DASS-21'),
        backgroundColor: Color(0xFF1A119B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            for (int i = 0; i < 21; i++)
              buildPregunta(textosPreguntas[i], (value) {
                setState(() {
                  respuestas[i] = value;
                });
              }, respuestas[i]),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String resultado = calcularResultado();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResultadoDASS21Screen(resultado: resultado),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          texto,
          style: TextStyle(fontSize: 18, color: Color(0xFF1A119B)),
          textAlign: TextAlign.center,
        ),
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

class ResultadoDASS21Screen extends StatelessWidget {
  final String resultado;

  ResultadoDASS21Screen({required this.resultado});

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
