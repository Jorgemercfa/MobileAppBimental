import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'user': text});
      _controller.clear();
    });

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
                        contentPadding: EdgeInsets.symmetric(
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
