// Importa la librería para codificar y decodificar datos JSON
import 'dart:convert';

// Importa la librería 'http' para hacer solicitudes HTTP
import 'package:http/http.dart' as http;

// Clase que encapsula el servicio para comunicarse con la API de OpenAI
class OpenAIService {
  // Clave de API de OpenAI (IMPORTANTE: nunca expongas esta clave en producción)
  final String _apiKey =
      'sk-proj-...'; // <-- Recorta la clave en producción o muévela a variables de entorno

  // URL del endpoint de OpenAI para crear respuestas del modelo de chat
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  // Método asíncrono que envía un mensaje a la API de OpenAI y obtiene la respuesta generada
  Future<String> obtenerRespuesta(String mensaje) async {
    try {
      // Realiza una solicitud POST al endpoint de OpenAI
      final response = await http.post(
        Uri.parse(_apiUrl), // Convierte la URL en objeto URI
        headers: {
          'Content-Type': 'application/json', // Indica que el contenido es JSON
          'Authorization':
              'Bearer $_apiKey', // Autenticación con la clave de API
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo', // Especifica el modelo de lenguaje a usar
          'messages': [
            {
              'role': 'user',
              'content': mensaje
            } // Mensaje enviado por el usuario
          ],
          'max_tokens': 150, // Límite de tokens en la respuesta
          'temperature': 0.7, // Nivel de creatividad de la respuesta
        }),
      );

      // Verifica si la respuesta fue exitosa (código 200)
      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Decodifica la respuesta JSON
        // Extrae y retorna el contenido de la respuesta del modelo
        return data['choices'][0]['message']['content'].toString();
      } else {
        // Lanza una excepción si el servidor responde con un error
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      // Captura y lanza cualquier otro error que ocurra en la solicitud
      throw Exception('Error al procesar la solicitud: $e');
    }
  }
}
