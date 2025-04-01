import 'package:bimental_application_1/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math'; // Para seleccionar preguntas aleatoriamente
import 'AnswersRepository.dart';
import 'UserRepository.dart';
import 'openai_service.dart';
// import 'ManageAnswers.dart';

void main() => runApp(const ChatBotApp());

class ChatBotApp extends StatelessWidget {
  const ChatBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final OpenAIService _openAIService = OpenAIService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _showQuestionnaire = false;
  int questionCategoryNumber = 1;

  // Map de preguntas por categoría
  final Map<String, List<Map<String, String>>> _questions = {
    "1": [
      {"id": "1.1", "texto": "Me costó mucho relajarme"},
      {"id": "1.2", "texto": "Me fue difícil relajarme"},
      {"id": "1.3", "texto": "Relajarme resultó ser un desafío"},
      {
        "id": "1.4",
        "texto": "Tuve problemas para encontrar un momento de relajación"
      }
    ],
    "2": [
      {"id": "2.1", "texto": "Me di cuenta que tenía la boca seca"},
      {"id": "2.2", "texto": "Noté que mi boca estaba seca"},
      {"id": "2.3", "texto": "Sentí sequedad en la boca"},
      {"id": "2.4", "texto": "Percibí que mi boca carecía de humedad"}
    ],
    "3": [
      {"id": "3.1", "texto": "No podía sentir ningún sentimiento positivo"},
      {
        "id": "3.2",
        "texto": "Me resultaba imposible experimentar emociones positivas"
      },
      {"id": "3.3", "texto": "No lograba sentirme bien emocionalmente"},
      {"id": "3.4", "texto": "No podía conectar con sentimientos agradables"}
    ],
    "4": [
      {
        "id": "4.1",
        "texto":
            "Se me hizo difícil respirar (p. ej., respiración excesivamente rápida o falta de aliento sin hacer esfuerzo físico)"
      },
      {"id": "4.2", "texto": "Tuve problemas para respirar de forma normal"},
      {"id": "4.3", "texto": "Sentí que me costaba tomar aire"},
      {
        "id": "4.4",
        "texto":
            "Experimenté dificultad al intentar respirar sin razón aparente"
      }
    ],
    "5": [
      {
        "id": "5.1",
        "texto": "Se me hizo difícil tomar la iniciativa para hacer cosas"
      },
      {"id": "5.2", "texto": "Me costó iniciar actividades por mi cuenta"},
      {
        "id": "5.3",
        "texto": "Sentí que no podía empezar cosas nuevas fácilmente"
      },
      {"id": "5.4", "texto": "Iniciar tareas fue complicado para mí"}
    ],
    "6": [
      {"id": "6.1", "texto": "Reaccioné exageradamente en ciertas situaciones"},
      {
        "id": "6.2",
        "texto": "Respondí de forma desproporcionada en algunas circunstancias"
      },
      {
        "id": "6.3",
        "texto":
            "Mi reacción en ciertas situaciones fue más intensa de lo normal"
      },
      {"id": "6.4", "texto": "Exageré mis respuestas en determinados momentos"}
    ],
    "7": [
      {"id": "7.1", "texto": "Tuve temblores (p. ej., en las manos)"},
      {"id": "7.2", "texto": "Sentí que mis manos temblaban"},
      {"id": "7.3", "texto": "Experimenté temblores físicos"},
      {
        "id": "7.4",
        "texto": "Noté movimientos involuntarios en mis extremidades"
      }
    ],
    "8": [
      {"id": "8.1", "texto": "Sentí que tenía muchos nervios"},
      {"id": "8.2", "texto": "Me sentí extremadamente nervioso"},
      {"id": "8.3", "texto": "Los nervios me dominaron en varias ocasiones"},
      {"id": "8.4", "texto": "Estuve inquieto y con mucha ansiedad"}
    ],
    "9": [
      {
        "id": "9.1",
        "texto":
            "Estuve preocupado por situaciones en las cuales podía entrar en pánico y hacer el ridículo"
      },
      {
        "id": "9.2",
        "texto":
            "Me angustié ante la posibilidad de perder el control y avergonzarme"
      },
      {
        "id": "9.3",
        "texto":
            "Temí encontrarme en situaciones donde pudiera entrar en pánico"
      },
      {
        "id": "9.4",
        "texto": "Me preocupaba pasar vergüenza por no controlar mi ansiedad"
      }
    ],
    "10": [
      {"id": "10.1", "texto": "Sentí que no tenía nada por lo que ilusionarme"},
      {"id": "10.2", "texto": "Sentí que no había nada que me motivara"},
      {"id": "10.3", "texto": "Me faltaba entusiasmo hacia el futuro"},
      {
        "id": "10.4",
        "texto": "Carecía de expectativas positivas que me alegraran"
      }
    ],
    "11": [
      {"id": "11.1", "texto": "Me sentí agitado"},
      {"id": "11.2", "texto": "Estuve inquieto y alterado"},
      {"id": "11.3", "texto": "Sentí que no podía estar en calma"},
      {"id": "11.4", "texto": "Me noté muy nervioso y acelerado"}
    ],
    "12": [
      {"id": "12.1", "texto": "Se me hizo difícil relajarme"},
      {"id": "12.2", "texto": "Relajarme fue complicado para mí"},
      {
        "id": "12.3",
        "texto": "Tuve problemas para alcanzar un estado de calma"
      },
      {"id": "12.4", "texto": "Me costó mucho encontrar tranquilidad"}
    ],
    "13": [
      {"id": "13.1", "texto": "Me sentí triste y deprimido"},
      {"id": "13.2", "texto": "Experimenté una sensación profunda de tristeza"},
      {"id": "13.3", "texto": "Me noté abatido y sin ánimos"},
      {"id": "13.4", "texto": "Estuve emocionalmente decaído"}
    ],
    "14": [
      {
        "id": "14.1",
        "texto":
            "No toleré nada que no me permitiera continuar con lo que estaba haciendo"
      },
      {
        "id": "14.2",
        "texto": "Me frustré con cualquier interrupción en mis actividades"
      },
      {
        "id": "14.3",
        "texto":
            "No pude soportar situaciones que afectaran mi ritmo de trabajo"
      },
      {
        "id": "14.4",
        "texto": "Me molestaba cualquier cosa que interrumpiera mis planes"
      }
    ],
    "15": [
      {"id": "15.1", "texto": "Sentí que estaba cercano a sentir pánico"},
      {
        "id": "15.2",
        "texto": "Percibí que estaba al borde de entrar en pánico"
      },
      {
        "id": "15.3",
        "texto": "Tuve la sensación de que un ataque de pánico era inminente"
      },
      {
        "id": "15.4",
        "texto": "Sentí que la ansiedad extrema estaba a punto de desbordarse"
      }
    ],
    "16": [
      {"id": "16.1", "texto": "No me pude entusiasmar por nada"},
      {"id": "16.2", "texto": "Nada lograba despertar mi interés"},
      {"id": "16.3", "texto": "No encontré motivación en ninguna actividad"},
      {"id": "16.4", "texto": "Carecía de entusiasmo por todo"}
    ],
    "17": [
      {"id": "17.1", "texto": "Sentí que valía muy poco como persona"},
      {
        "id": "17.2",
        "texto": "Percibí que mi valor personal era insignificante"
      },
      {"id": "17.3", "texto": "Me sentí menospreciado, incluso por mí mismo"},
      {"id": "17.4", "texto": "Creí que no tenía importancia como individuo"}
    ],
    "18": [
      {"id": "18.1", "texto": "Sentí que estaba muy irritable"},
      {"id": "18.2", "texto": "Me noté fácilmente molesto"},
      {"id": "18.3", "texto": "Estuve más propenso a la irritación"},
      {
        "id": "18.4",
        "texto": "Cualquier cosa pequeña me hacía perder la paciencia"
      }
    ],
    "19": [
      {
        "id": "19.1",
        "texto":
            "Sentí la actividad de mi corazón a pesar de no haber hecho ningún esfuerzo físico (p. ej., aumento de los latidos, sensación de palpitación o salto de los latidos)"
      },
      {"id": "19.2", "texto": "Percibí latidos acelerados sin razón aparente"},
      {
        "id": "19.3",
        "texto": "Sentí que mi corazón palpitaba con fuerza, incluso en reposo"
      },
      {
        "id": "19.4",
        "texto":
            "Noté un ritmo cardíaco irregular sin haber realizado ejercicio"
      }
    ],
    "20": [
      {"id": "20.1", "texto": "Tuve miedo sin razón"},
      {"id": "20.2", "texto": "Sentí temor sin un motivo específico"},
      {"id": "20.3", "texto": "Me asusté sin causa aparente"},
      {
        "id": "20.4",
        "texto": "Experimenté una sensación de miedo injustificado"
      }
    ],
    "21": [
      {"id": "21.1", "texto": "Sentí que la vida no tenía ningún sentido"},
      {"id": "21.2", "texto": "Percibí que mi existencia carecía de propósito"},
      {"id": "21.3", "texto": "Me parecía que todo en la vida era inútil"},
      {"id": "21.4", "texto": "Sentí que no había razones para seguir adelante"}
    ]
  };

  List<Map<String, String>> _selectedQuestions = [];
  List<String> answers = [];

  // Método para generar una pregunta aleatoria de la categoría actual
  Map<String, String> _generateRandomQuestion() {
    final random = Random();
    final group = _questions[questionCategoryNumber.toString()];

    // Retorna una pregunta aleatoria del grupo correspondiente
    if (group != null && group.isNotEmpty) {
      return group[random.nextInt(group.length)];
    } else {
      return {"id": "N/A", "texto": "No hay más preguntas disponibles"};
    }
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (text.toLowerCase() == 'cuestionario') {
      setState(() {
        _showQuestionnaire = true;
        _selectedQuestions = [_generateRandomQuestion()];
        _controller.clear();
        questionCategoryNumber = 1;
      });
      return;
    }

    if (_showQuestionnaire) {
      // Validar que la respuesta sea un número entre 0 y 3
      if (RegExp(r'^[0-3]$').hasMatch(text)) {
        answers.add(text); // Guardar la respuesta como String
        questionCategoryNumber++;

        if (questionCategoryNumber <= _questions.length) {
          setState(() {
            _selectedQuestions = [_generateRandomQuestion()];
          });
        } else {
          _finishQuestionnaire();
          return;
        }
      } else {
        // Mostrar un mensaje de error si la respuesta no es válida
        setState(() {
          _messages.add(
              {'bot': "Por favor, ingresa un número válido (0, 1, 2 o 3)."});
        });
        return;
      }
    }
    print(answers);
    setState(() {
      _messages.add({'user': text});
      _controller.clear();
    });

    if (!_showQuestionnaire) {
      try {
        final response = await _openAIService.obtenerRespuesta(text);
        setState(() {
          _messages.add({'bot': response});
        });
      } catch (e) {
        if (kDebugMode) {
          print("Error al obtener respuesta de OpenAI: $e");
        }
        setState(() {
          _messages.add({
            'bot': "Lo siento, ocurrió un error. Por favor, intenta de nuevo."
          });
        });
      }
    }
  }

  void _finishQuestionnaire() async {
    String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    setState(() {
      _showQuestionnaire = false;
      _selectedQuestions = [];
    });

    _messages.add({
      'bot':
          "Gracias por completar el cuestionario. Ahora puedes continuar chateando.\nFecha y hora de finalización: $timestamp"
    });

    List<User> foundUsers = await UserRepository.instance.getUsers();
    User? currentUser = foundUsers.isNotEmpty ? foundUsers.last : null;

    if (currentUser != null) {
      // Guardar las respuestas en AnswersRepository
      AnswersRepository.saveAnswers(answers, currentUser.id);
    } else {
      print("Error: No hay usuario autenticado.");
    }

    // Limpiar las respuestas para el próximo cuestionario
    answers.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A119B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Para activar el cuestionario, escriba "cuestionario"',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.containsKey('user');
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color:
                          isUserMessage ? Colors.green[600] : Colors.green[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isUserMessage ? 12 : 0),
                        bottomRight: Radius.circular(isUserMessage ? 0 : 12),
                      ),
                    ),
                    child: Text(
                      isUserMessage ? message['user']! : message['bot']!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_showQuestionnaire) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Responde a la siguiente pregunta con:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A119B)),
                  ),
                  const Text(
                    '0 No me sucedió\n1 Me sucedió un poco, o durante parte del tiempo\n2 Me sucedió bastante, o durante una buena parte del tiempo\n3 Me sucedió mucho, o la mayor parte del tiempo',
                    style: TextStyle(fontSize: 14, color: Color(0xFF1A119B)),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedQuestions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        _selectedQuestions.first['texto']!,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF1A119B)),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _finishQuestionnaire,
                    child: const Text("Finalizar Cuestionario"),
                  ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color(0xFF1A119B),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color(0xFF1A119B), // Color de fondo azul
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Asegura que los elementos se centren verticalmente
                        children: [
                          Expanded(
                            child: Container(
                              height: 50, // Ajusta la altura del TextField
                              alignment: Alignment
                                  .center, // Centra el contenido dentro del contenedor
                              child: TextField(
                                controller: _controller,
                                style: TextStyle(
                                    fontSize: 18.0), // Tamaño del texto
                                decoration: InputDecoration(
                                  hintText: "Escribe un texto",
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal:
                                          16), // Ajusta el padding interno
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
