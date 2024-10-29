import 'package:flutter/material.dart';

// import 'Resultados.dart';

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
    "Pregunta 1: Me encontré enojándome por cosas triviales.",
    "Pregunta 2: Sentí que no podía experimentar ninguna emoción positiva.",
    "Pregunta 3: Experimenté dificultad para respirar sin esfuerzo físico.",
    "Pregunta 4: Tuve dificultad para motivarme para hacer cosas.",
    "Pregunta 5: Me sentí excesivamente ansioso.",
    "Pregunta 6: Tuve dificultades para relajarme.",
    "Pregunta 7: Sentí que estaba actuando de forma irritable.",
    "Pregunta 8: Me sentí preocupado/a por situaciones cotidianas.",
    "Pregunta 9: Sentí tristeza la mayor parte del día.",
    "Pregunta 10: Sentí que estaba constantemente en tensión.",
    "Pregunta 11: Me encontré teniendo reacciones emocionales fuertes.",
    "Pregunta 12: Experimenté pensamientos negativos acerca de mí mismo.",
    "Pregunta 13: Me sentí constantemente nervioso.",
    "Pregunta 14: Me preocupé de manera excesiva por el futuro.",
    "Pregunta 15: Me sentí cansado/a o fatigado/a sin razón aparente.",
    "Pregunta 16: Perdí interés en cosas que antes disfrutaba.",
    "Pregunta 17: Me sentí incapaz de lidiar con mi vida cotidiana.",
    "Pregunta 18: Me asusté con facilidad.",
    "Pregunta 19: Sentí dificultad para concentrarme.",
    "Pregunta 20: Experimenté cambios en mis hábitos de sueño.",
    "Pregunta 21: Me sentí desconectado de mi entorno.",
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
          style: TextStyle(fontSize: 18),
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
