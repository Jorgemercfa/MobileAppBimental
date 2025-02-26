import 'package:intl/intl.dart';

class ManageAnswers {
  static List<Map<String, dynamic>> answersHistory = [];

  static void saveAnswers(List<String> answers) {
    String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    answersHistory.add({
      'timestamp': timestamp,
      'answers': answers,
    });
    print("Se guardaron las respuestas");
  }

  static List<Map<String, dynamic>> getAnswers() {
    return answersHistory;
  }
}
