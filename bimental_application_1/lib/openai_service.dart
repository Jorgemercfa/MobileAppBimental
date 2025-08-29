import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OpenAIService {
  // Almacenamiento seguro
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// Guardar la API Key en el almacenamiento seguro (haz esto una sola vez, por ejemplo en el login)
  Future<void> guardarApiKey(String apiKey) async {
    await _storage.write(key: "OPENAI_API_KEY", value: apiKey);
  }

  /// Obtener respuesta de OpenAI
  Future<String> obtenerRespuesta(String mensaje) async {
    try {
      // Leer la API key desde el almacenamiento seguro
      final String? apiKey = await _storage.read(key: "OPENAI_API_KEY");

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('No se encontró la API Key en el dispositivo');
      }

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-4o-mini', // modelo recomendado
          'messages': [
            {'role': 'user', 'content': mensaje}
          ],
          'max_tokens': 300,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].toString();
        } else {
          throw Exception('No se encontró respuesta en la API');
        }
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
