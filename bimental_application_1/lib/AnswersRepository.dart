import 'package:intl/intl.dart';
import 'AnswersUser.dart';
import 'ManageAnswers.dart';
import 'User.dart';
import 'UserRepository.dart';

class AnswersRepository {
  static List<AnswersUser> answersHistory = [];

  static void saveAnswers(List<String> answers, String userId) {
    print("Guardando respuestas para el usuario: $userId");
    print("Respuestas: $answers");

    // Buscar el usuario correspondiente
    User? user = UserRepository.instance.users.firstWhere(
      (u) => u.id == userId,
      orElse: () => User('', 'Desconocido', 'N/A', '', 'N/A'),
    );

    // Convertir las respuestas a enteros
    List<int> respuestas = answers.map((e) => int.tryParse(e) ?? 0).toList();
    print("Respuestas convertidas a enteros: $respuestas");

    // Calcular los puntajes
    Map<String, dynamic> puntajes =
        ManageAnswers.calcularResultados(respuestas, userId);
    print("Puntajes calculados: $puntajes");

    // Obtener la fecha y hora actual
    String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Crear una nueva entrada sin guardar las respuestas originales
    AnswersUser newEntry = AnswersUser(
      userId: user.id,
      timestamp: timestamp,
      p_depresion: puntajes['p_depresion'] ?? 0,
      p_ansiedad: puntajes['p_ansiedad'] ?? 0,
      p_estres: puntajes['p_estres'] ?? 0,
    );

    // Guardar la nueva entrada en el historial
    answersHistory.add(newEntry);
    print("Nueva entrada guardada: $newEntry");
  }

  static List<AnswersUser> getAnswers() {
    return answersHistory;
  }
}
