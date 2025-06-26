import 'dart:convert';
import 'package:http/http.dart' as http;

class Dass21Api {
  String url = 'http://127.0.0.1:8000/predict/';

  Future<Map<String, dynamic>> processAnswers(List<String> answers) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'respuestas': answers}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al procesar la solicitud: $e');
    }
  }
}
