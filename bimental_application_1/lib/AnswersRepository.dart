import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'AnswersUser.dart';

class AnswersRepository {
  static List<AnswersUser> answersHistory = [];
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Guarda los resultados del DASS-21 en Firestore, junto con el userId y timestamp.
  static Future<void> saveDass21Results(
      Map<String, dynamic> results, String userId) async {
    DateTime now = DateTime.now();
    String timestampStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    AnswersUser newEntry = AnswersUser(
      userId: userId,
      timestamp: timestampStr,
      p_depresion: results['depresion'] ?? 0,
      p_ansiedad: results['ansiedad'] ?? 0,
      p_estres: results['estres'] ?? 0,
    );

    answersHistory.add(newEntry);

    try {
      // Guardar en la colección principal
      await _firestore.collection('answers').add({
        'timestamp': now, // Guardar como DateTime
        'p_depresion': newEntry.p_depresion,
        'p_ansiedad': newEntry.p_ansiedad,
        'p_estres': newEntry.p_estres,
        'userId': userId,
      });

      // Guardado opcional en estructura optimizada por usuario
      try {
        await _firestore
            .collection('user_answers')
            .doc(userId)
            .collection('results')
            .add({
          'timestamp': now,
          'p_depresion': newEntry.p_depresion,
          'p_ansiedad': newEntry.p_ansiedad,
          'p_estres': newEntry.p_estres,
        });
      } catch (e) {
        print("Error al guardar en estructura optimizada: $e");
      }

      print("Datos DASS-21 guardados en Firestore correctamente.");
    } catch (e) {
      print("Error al guardar en Firestore: $e");
    }
  }

  /// Obtiene todos los resultados de todos los usuarios (solo para administradores)
  static Future<List<AnswersUser>> getAllAnswersFromFirestore() async {
    try {
      List<AnswersUser> allAnswers = [];

      try {
        QuerySnapshot snapshot = await _firestore
            .collection('answers')
            .orderBy('timestamp', descending: true)
            .get();

        allAnswers = _processSnapshot(snapshot);
      } catch (e) {
        // Intento alternativo sin ordenamiento si falla
        try {
          QuerySnapshot snapshot = await _firestore.collection('answers').get();
          allAnswers = _processSnapshot(snapshot);
          allAnswers.sort((a, b) {
            try {
              final dateA =
                  DateFormat('yyyy-MM-dd HH:mm:ss').parse(a.timestamp);
              final dateB =
                  DateFormat('yyyy-MM-dd HH:mm:ss').parse(b.timestamp);
              return dateB.compareTo(dateA);
            } catch (e) {
              return b.timestamp.compareTo(a.timestamp);
            }
          });
        } catch (e) {
          print("Error en intento alternativo: $e");
        }
      }

      return allAnswers;
    } catch (e) {
      print("Error en la verificación de admin: $e");
      return [];
    }
  }

  /// Obtiene los resultados de un usuario específico
  static Future<List<AnswersUser>> getAnswersFromFirestore(
      String userId) async {
    List<AnswersUser> userAnswers = [];

    try {
      // Consulta principal a la colección 'answers'
      QuerySnapshot snapshot = await _firestore
          .collection('answers')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      userAnswers = _processSnapshot(snapshot);
    } catch (e) {
      // Intento 1: Sin ordenamiento
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('answers')
            .where('userId', isEqualTo: userId)
            .get();

        userAnswers = _processSnapshot(snapshot);
        userAnswers.sort((a, b) {
          try {
            final dateA = DateFormat('yyyy-MM-dd HH:mm:ss').parse(a.timestamp);
            final dateB = DateFormat('yyyy-MM-dd HH:mm:ss').parse(b.timestamp);
            return dateB.compareTo(dateA);
          } catch (e) {
            return b.timestamp.compareTo(a.timestamp);
          }
        });
      } catch (e) {
        // Intento 2: Estructura optimizada (user_answers)
        try {
          QuerySnapshot snapshot = await _firestore
              .collection('user_answers')
              .doc(userId)
              .collection('results')
              .orderBy('timestamp', descending: true)
              .get();

          userAnswers = _processSnapshot(snapshot, userId);
        } catch (e) {
          print("Error al obtener de estructura optimizada: $e");
        }
      }
    }

    return userAnswers;
  }

  static List<AnswersUser> _processSnapshot(QuerySnapshot snapshot,
      [String? userId]) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Manejo de timestamp (DateTime, Timestamp o String)
      String timestamp;
      if (data['timestamp'] is DateTime) {
        timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(data['timestamp']);
      } else if (data['timestamp'] is Timestamp) {
        timestamp = DateFormat('yyyy-MM-dd HH:mm:ss')
            .format((data['timestamp'] as Timestamp).toDate());
      } else {
        timestamp = data['timestamp']?.toString() ?? '';
      }

      return AnswersUser(
        userId: userId ?? data['userId'] ?? '',
        timestamp: timestamp,
        p_depresion: (data['p_depresion'] ?? 0).toInt(),
        p_ansiedad: (data['p_ansiedad'] ?? 0).toInt(),
        p_estres: (data['p_estres'] ?? 0).toInt(),
      );
    }).toList();
  }

  /// Obtiene el historial local
  static List<AnswersUser> getAnswers() {
    return answersHistory;
  }
}
