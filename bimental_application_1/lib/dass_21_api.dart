// Importa la librería 'dart:convert' para codificar y decodificar datos JSON
import 'dart:convert';

// Importa la librería 'http' para hacer solicitudes HTTP
import 'package:http/http.dart' as http;

// Clase que maneja la comunicación con la API del modelo DASS-21
class Dass21Api {
  // URL del endpoint del servidor backend que procesa las respuestas del cuestionario
  String url = 'http://127.0.0.1:8000/predict/';

  // Método asíncrono que envía las respuestas del usuario a la API para procesarlas
  Future<Map<String, dynamic>> processAnswers(List<String> answers) async {
    try {
      // Realiza una solicitud POST a la URL definida, enviando las respuestas en formato JSON
      final response = await http.post(
        Uri.parse(url), // Convierte la URL en un objeto URI
        headers: {
          'Content-Type': 'application/json'
        }, // Encabezado que indica que el cuerpo es JSON
        body: json.encode({
          'respuestas': answers
        }), // Convierte el mapa de datos en una cadena JSON
      );

      // Si la respuesta es exitosa (código 200), decodifica el cuerpo de la respuesta
      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Decodifica el JSON recibido
        return data; // Retorna los datos como un mapa
      } else {
        // Si no es exitosa, lanza una excepción con el código de error
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      // Captura cualquier otro error que ocurra durante la solicitud o decodificación
      throw Exception('Error al procesar la solicitud: $e');
    }
  }
}
