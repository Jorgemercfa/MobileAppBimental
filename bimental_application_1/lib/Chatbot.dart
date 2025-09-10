import 'package:bimental_application_1/dass_21_api.dart';
import 'package:bimental_application_1/session_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'AnswersRepository.dart';
import 'chatbot_api.dart';

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
  final ChatbotService _chatbotService = ChatbotService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _showQuestionnaire = false;
  int questionCategoryNumber = 1;
  bool _hasShownDisclaimer = false;

  // Preguntas actualizadas según lo solicitado
  final Map<String, List<Map<String, String>>> _questions = {
    "1": [
      {"id": "1.1", "texto": "1) Me ha costado mucho descargar la tensión"},
    ],
    "2": [
      {"id": "2.1", "texto": "2) Me di cuenta que tenía la boca seca"},
    ],
    "3": [
      {"id": "3.1", "texto": "3) No podía sentir ningún sentimiento positivo"},
    ],
    "4": [
      {"id": "4.1", "texto": "4) Se me hizo difícil respirar"},
    ],
    "5": [
      {
        "id": "5.1",
        "texto": "5) Se me hizo difícil tomar la iniciativa para hacer cosas"
      },
    ],
    "6": [
      {
        "id": "6.1",
        "texto": "6) Reaccioné exageradamente en ciertas situaciones"
      },
    ],
    "7": [
      {"id": "7.1", "texto": "7) Sentí que mis manos temblaban"},
    ],
    "8": [
      {
        "id": "8.1",
        "texto":
            "8) He sentido que estaba gastando una gran cantidad de energía"
      },
    ],
    "9": [
      {
        "id": "9.1",
        "texto":
            "9) Estaba preocupado por situaciones en las cuales podía tener pánico o en las que podría hacer el ridículo"
      },
    ],
    "10": [
      {
        "id": "10.1",
        "texto": "10) He sentido que no había nada que me ilusionara"
      },
    ],
    "11": [
      {"id": "11.1", "texto": "11) Me he sentido inquieto"},
    ],
    "12": [
      {"id": "12.1", "texto": "12) Se me hizo difícil relajarme"},
    ],
    "13": [
      {"id": "13.1", "texto": "13) Me sentí triste y deprimido"},
    ],
    "14": [
      {
        "id": "14.1",
        "texto":
            "14) No toleré nada que me no permitiera continuar con lo que estaba haciendo"
      },
    ],
    "15": [
      {"id": "15.1", "texto": "15) Sentí que estaba al punto de pánico"},
    ],
    "16": [
      {"id": "16.1", "texto": "16) No me pude entusiasmar por nada"},
    ],
    "17": [
      {"id": "17.1", "texto": "17) Sentí que valía muy poco como persona"},
    ],
    "18": [
      {
        "id": "18.1",
        "texto": "18) He tendido a sentirme enfadado con facilidad"
      },
    ],
    "19": [
      {
        "id": "19.1",
        "texto":
            "19) Sentí los latidos de mi corazón a pesar de no haber hecho ningún esfuerzo físico"
      },
    ],
    "20": [
      {"id": "20.1", "texto": "20) Tuve miedo sin razón"},
    ],
    "21": [
      {"id": "21.1", "texto": "21) Sentí que la vida no tenía ningún sentido"},
    ]
  };

  List<Map<String, String>> _selectedQuestions = [];
  List<String> userAnswers = [];

  @override
  void initState() {
    super.initState();
    // Mostrar el popup cuando se inicializa la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDisclaimerPopup();
    });
  }

  Map<String, String> _getQuestion() {
    final group = _questions[questionCategoryNumber.toString()];
    return group != null && group.isNotEmpty
        ? group[0] // Always get the first (and only) question
        : {"id": "N/A", "texto": "No hay más preguntas disponibles"};
  }

  // Función para mostrar el popup de disclaimer
  void _showDisclaimerPopup() {
    if (_hasShownDisclaimer) return; // Evitar que se muestre múltiples veces

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _hasShownDisclaimer = true; // Marcar como mostrado
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 50),
              SizedBox(height: 10),
              Text(
                "Aviso",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A119B),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: const Text(
            "Los resultados del cuestionario son solo una referencia y "
            "no reemplazan la evaluación de un profesional de salud mental.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A119B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Entendido",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _sendMessage() async {
    final text = _controller.text.trim();

    // Validación de texto vacío (siempre aplica)
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, escribe un texto antes de enviar.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Validación de 100 palabras SOLO durante el cuestionario
    if (_showQuestionnaire) {
      final wordCount =
          text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
      if (wordCount > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Por favor, escribe un texto de máximo 100 palabras.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    if (text.toLowerCase() == 'cuestionario') {
      final userId = await SessionService.getUserId();
      if (userId == null) {
        setState(() {
          _messages.add({
            'bot':
                "Debes iniciar sesión para realizar el cuestionario. Por favor, inicia sesión primero."
          });
        });
        return;
      }

      setState(() {
        _showQuestionnaire = true;
        _selectedQuestions = [_getQuestion()];
        _controller.clear();
        questionCategoryNumber = 1;
        userAnswers.clear();
      });
      return;
    }

    if (_showQuestionnaire) {
      if (userAnswers.length < _questions.length) {
        userAnswers.add(text);
        questionCategoryNumber++;
        if (questionCategoryNumber <= _questions.length) {
          setState(() {
            _selectedQuestions = [_getQuestion()];
          });
        } else {
          _finishQuestionnaire();
        }
        _controller.clear();
        return;
      }
    }

    setState(() {
      _messages.add({'user': text});
      _controller.clear();
    });

    try {
      final response = await _chatbotService.obtenerRespuesta(text);

      setState(() {
        _messages.add({'bot': response});
      });
    } catch (e) {
      if (kDebugMode) print("Error al obtener respuesta de Chatbot: $e");
      setState(() {
        _messages.add({
          'bot': "Lo siento, ocurrió un error. Por favor, intenta de nuevo."
        });
      });
    }
  }

  void _finishQuestionnaire() async {
    final userId = await SessionService.getUserId();
    if (userId == null) {
      setState(() {
        _messages.add({
          'bot': "Error: Sesión no válida. No se guardarán las respuestas."
        });
        _showQuestionnaire = false;
        _selectedQuestions = [];
        userAnswers.clear();
      });
      return;
    }

    try {
      final dass21Results = await Dass21Api().processAnswers(userAnswers);
      await AnswersRepository.saveDass21Results(dass21Results, userId);

      final timestamp =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      setState(() {
        _messages.add({
          'bot':
              "✅ Cuestionario completado y guardado correctamente.\n📅 Fecha: $timestamp"
        });
        _showQuestionnaire = false;
        _selectedQuestions = [];
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'bot':
              "❌ Error al guardar el cuestionario o calcular resultados. Por favor, intenta nuevamente."
        });
      });
    } finally {
      userAnswers.clear();
      print("El id del usuario que realizo el cuestionario es: $userId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A119B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: isUserMessage
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isUserMessage) // Avatar del bot (a la izquierda)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/images/logo_bimental.png'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.65,
                        ),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.green[600]
                              : Colors.green[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: Radius.circular(isUserMessage ? 12 : 0),
                            bottomRight:
                                Radius.circular(isUserMessage ? 0 : 12),
                          ),
                        ),
                        child: Text(
                          isUserMessage ? message['user']! : message['bot']!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    if (isUserMessage) // Avatar del usuario (a la derecha)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue[200],
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          if (_showQuestionnaire) ...[
            // CENTRAR verticalmente el bloque del cuestionario
            Spacer(), // <- Esto empuja el bloque hacia el centro
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Pregunta ${questionCategoryNumber} de ${_questions.length}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A119B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: Text(
                        _selectedQuestions.first['texto']!,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Text(
                    'Responde a la siguiente pregunta con tu texto.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 220,
                    child: ElevatedButton(
                      onPressed: _finishQuestionnaire,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2516B0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(220, 36),
                      ),
                      child: const Text(
                        "Finalizar Cuestionario",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(), // <- Esto ayuda a centrar el bloque, puedes quitar si quieres que esté más arriba
          ],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color(0xFF1A119B),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color(0xFF1A119B),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: TextField(
                                controller: _controller,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFF1A119B),
                                ),
                                decoration: InputDecoration(
                                  hintText: "Escribe un texto",
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 16,
                                  ),
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
