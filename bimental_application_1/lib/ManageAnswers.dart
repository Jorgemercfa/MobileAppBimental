import 'package:intl/intl.dart';
import 'AnswersUser.dart';
import 'package:uuid/uuid.dart';

class ManageAnswers {
  static List<AnswersUser> answersHistory = [];
  static final Uuid _uuid = Uuid();

  static void saveAnswers(List<String> answers) {
    String id = _uuid.v4(); // Genera un ID único
    String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    AnswersUser newEntry = AnswersUser(id, timestamp, answers);
    answersHistory.add(newEntry);

    print("Se guardaron las respuestas con ID: $id");
  }

  static List<AnswersUser> getAnswers() {
    return answersHistory;
  }
}
