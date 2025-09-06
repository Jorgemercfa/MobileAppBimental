import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String _apiUrl = 'http://127.0.0.1:8000/chat/'; // Tu endpoint local

  /// Enviar mensaje al backend FastAPI y obtener respuesta
  Future<String> obtenerRespuesta(String mensaje) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "message": mensaje, // CORREGIDO: el campo ahora se llama 'message'
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        // Suponiendo que tu backend devuelve algo como {"respuesta": "..."}
        return data['respuesta'].toString();
      } else {
        throw Exception(
          'Error en la solicitud: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error al procesar la solicitud: $e');
    }
  }
}
