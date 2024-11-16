import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // Para seleccionar preguntas aleatoriamente
import 'openai_service.dart';

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
  bool _questionnaireCompleted = false;

  final Map<String, List<String>> _questions = {
    "1": [
      "Me costó mucho relajarme",
      "Me fue difícil relajarme",
      "Relajarme resultó ser un desafío",
      "Tuve problemas para encontrar un momento de relajación"
    ],
    "2": [
      "Me di cuenta que tenía la boca seca",
      "Noté que mi boca estaba seca",
      "Sentí sequedad en la boca",
      "Percibí que mi boca carecía de humedad"
    ],
    "3": [
      "No podía sentir ningún sentimiento positivo",
      "Me resultaba imposible experimentar emociones positivas",
      "No lograba sentirme bien emocionalmente",
      "No podía conectar con sentimientos agradables"
    ],
    "4": [
      "Se me hizo difícil respirar (p. ej., respiración excesivamente rápida o falta de aliento sin hacer esfuerzo físico)",
      "Tuve problemas para respirar de forma normal",
      "Sentí que me costaba tomar aire",
      "Experimenté dificultad al intentar respirar sin razón aparente"
    ],
    "5": [
      "Se me hizo difícil tomar la iniciativa para hacer cosas",
      "Me costó iniciar actividades por mi cuenta",
      "Sentí que no podía empezar cosas nuevas fácilmente",
      "Iniciar tareas fue complicado para mí"
    ],
  };

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (text.toLowerCase() == 'cuestionario') {
      setState(() {
        _showQuestionnaire = true;
        _controller.clear();
      });
      return;
    }

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

  List<String> _generateRandomQuestions() {
    final random = Random();
    return _questions.entries.map((entry) {
      final options = entry.value;
      return options[random.nextInt(options.length)];
    }).toList();
  }

  void _completeQuestionnaire() {
    setState(() {
      _showQuestionnaire = false;
      _questionnaireCompleted = true;
    });

    // Reactivar OpenAI
    _messages.add({
      'bot':
          "¡Gracias por completar el cuestionario! Puedes continuar interactuando conmigo."
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A119B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Acción de retroceso
          },
        ),
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
                    'Responde a las siguientes preguntas con:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '0 No me sucedió\n1 Me sucedió un poco, o durante parte del tiempo\n2 Me sucedió bastante, o durante una buena parte del tiempo\n3 Me sucedió mucho, o la mayor parte del tiempo',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ..._generateRandomQuestions().map((question) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          question,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )),
                  ElevatedButton(
                    onPressed: _completeQuestionnaire,
                    child: const Text('Finalizar Cuestionario'),
                  ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color(0xFF1A119B), // Fondo del contenedor
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Escribe un texto",
                        fillColor:
                            Colors.white, // Fondo blanco para el TextField
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16), // Espaciado interno
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send,
                        color: Colors.green), // Icono verde
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
