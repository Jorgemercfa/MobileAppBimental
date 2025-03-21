class AnswersUser {
  final String userId;
  final String timestamp;
  final List<String> answers;
  final int p_depresion;
  final int p_ansiedad;
  final int p_estres;

  AnswersUser(
    this.userId,
    this.timestamp,
    this.answers, {
    required this.p_depresion,
    required this.p_ansiedad,
    required this.p_estres,
  });

  @override
  String toString() {
    return 'AnswersUser{userId: $userId, timestamp: $timestamp, answers: $answers, '
        'p_depresion: $p_depresion, p_ansiedad: $p_ansiedad, p_estres: $p_estres}';
  }
}
