import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey =
      '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'; // Reemplaza con tu clave de API

  Future<String> obtenerRespuesta(String mensaje) async {
    final url = Uri.parse('https://api.openai.com/v1/completions');
    final respuesta = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model':
            'text-davinci-003', // Puedes cambiar el modelo según tus necesidades
        'prompt': mensaje,
        'max_tokens': 100,
        'temperature': 0.7,
      }),
    );

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      return datos['choices'][0]['text'].trim();
    } else {
      throw Exception('Error al obtener respuesta de OpenAI');
    }
  }
}
