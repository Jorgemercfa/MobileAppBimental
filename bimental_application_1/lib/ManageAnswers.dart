class ManageAnswers {
  static List<String> answers = [];

  static saveAnswers(List<String> _answers) {
    answers = _answers;
    print("Se guardaron las respuestas");
  }

  static getAnswers() {
    return answers;
  }
}
