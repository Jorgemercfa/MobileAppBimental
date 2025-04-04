import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'AnswersUser.dart';
import 'ManageAnswers.dart';
import 'User.dart';
import 'UserRepository.dart';

class AnswersRepository {
  static List<AnswersUser> answersHistory = [];

  // Obtener TODOS los resultados globales (para mostrar historial completo, sin filtrar por usuario)
  static Future<List<AnswersUser>> getAllAnswersFromFirestore() async {
    List<AnswersUser> allAnswers = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('answers')
          .orderBy('timestamp', descending: true)
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        AnswersUser answer = AnswersUser(
          userId: data['userId'] ?? '',
          timestamp: data['timestamp'] ?? '',
          p_depresion: data['p_depresion'] ?? 0,
          p_ansiedad: data['p_ansiedad'] ?? 0,
          p_estres: data['p_estres'] ?? 0,
        );

        allAnswers.add(answer);
      }
      print("Historial completo obtenido de Firestore: $allAnswers");
    } catch (e) {
      print("Error al obtener el historial completo de Firestore: $e");
    }

    return allAnswers;
  }

  // Guardar respuestas en la colección global "answers" (ya lo tienes bien)
  static Future<void> saveAnswers(List<String> answers, String userId) async {
    print("Guardando respuestas para el usuario: $userId");
    print("Respuestas: $answers");

    User? user = UserRepository.instance.users.firstWhere(
      (u) => u.id == userId,
      orElse: () => User('', 'Desconocido', 'N/A', '', 'N/A', ''),
    );

    List<int> respuestas = answers.map((e) => int.tryParse(e) ?? 0).toList();
    print("Respuestas convertidas a enteros: $respuestas");

    Map<String, dynamic> puntajes =
        ManageAnswers.calcularResultados(respuestas, userId);
    print("Puntajes calculados: $puntajes");

    String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    AnswersUser newEntry = AnswersUser(
      userId: user.id,
      timestamp: timestamp,
      p_depresion: puntajes['p_depresion'] ?? 0,
      p_ansiedad: puntajes['p_ansiedad'] ?? 0,
      p_estres: puntajes['p_estres'] ?? 0,
    );

    answersHistory.add(newEntry);
    print("Nueva entrada guardada localmente: $newEntry");

    try {
      await FirebaseFirestore.instance.collection('answers').add({
        'timestamp': timestamp,
        'p_depresion': newEntry.p_depresion,
        'p_ansiedad': newEntry.p_ansiedad,
        'p_estres': newEntry.p_estres,
        'userId': userId,
      });
      print("Datos guardados en Firestore correctamente.");
    } catch (e) {
      print("Error al guardar en Firestore: $e");
    }
  }

  // Obtener respuestas por usuario (ya estaba bien)
  static Future<List<AnswersUser>> getAnswersFromFirestore(
      String userId) async {
    List<AnswersUser> userAnswers = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('answers')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        AnswersUser answer = AnswersUser(
          userId: userId,
          timestamp: data['timestamp'] ?? '',
          p_depresion: data['p_depresion'] ?? 0,
          p_ansiedad: data['p_ansiedad'] ?? 0,
          p_estres: data['p_estres'] ?? 0,
        );
        userAnswers.add(answer);
      }
      print("Respuestas obtenidas de Firestore: $userAnswers");
    } catch (e) {
      print("Error al obtener respuestas de Firestore: $e");
    }

    return userAnswers;
  }

  // Obtener respuestas locales
  static List<AnswersUser> getAnswers() {
    return answersHistory;
  }
}
