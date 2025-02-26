class ManageAnswers {
  static List<List<String>> answersHistory = [];

  static void saveAnswers(List<String> _answers) {
    answersHistory.add(_answers);
    print("Se guardaron las respuestas");
  }

  static List<List<String>> getAnswers() {
    return answersHistory;
  }
}
