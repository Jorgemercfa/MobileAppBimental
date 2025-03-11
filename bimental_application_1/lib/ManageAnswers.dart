import 'package:intl/intl.dart';
import 'AnswersUser.dart';
import 'package:uuid/uuid.dart';
import 'UserRepository.dart';
import 'User.dart';

class ManageAnswers {
  static List<AnswersUser> answersHistory = [];
  static final Uuid _uuid = Uuid();

  static void saveAnswers(List<String> answers, String userId) {
    // Verificar si el usuario existe en UserRepository
    User? user = UserRepository.instance.users.firstWhere(
      (u) => u.id == userId,
    );

    String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    AnswersUser newEntry = AnswersUser(user.id, timestamp, answers);
    answersHistory.add(newEntry);

    print(
        "Se guardaron las respuestas del usuario: ${user.name} con ID: ${user.id}");
  }

  static List<AnswersUser> getAnswers() {
    return answersHistory;
  }
}
