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

    User? user = UserRepository.instance.users.firstWhere(
      (u) => u.id == userId,
      orElse: () => User('', 'Desconocido', 'N/A', '', 'N/A'),
    );

    List<int> respuestas = answers.map((e) => int.tryParse(e) ?? 0).toList();
    print("Respuestas convertidas a enteros: $respuestas");

    Map<String, dynamic> puntajes =
        ManageAnswers.calcularResultados(respuestas, userId);
    print("Puntajes calculados: $puntajes");

    String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    AnswersUser newEntry = AnswersUser(
      user.id,
      timestamp,
      answers,
      p_depresion: puntajes['p_depresion'] ?? 0,
      p_ansiedad: puntajes['p_ansiedad'] ?? 0,
      p_estres: puntajes['p_estres'] ?? 0,
    );

    answersHistory.add(newEntry);
    print("Nueva entrada guardada: $newEntry");
  }

  static List<AnswersUser> getAnswers() {
    return answersHistory;
  }
}
