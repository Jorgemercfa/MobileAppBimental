import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'AnswersUser.dart';

class AnswersRepository {
  static List<AnswersUser> answersHistory = [];
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // -----------------------
  // Clasificadores públicos
  // -----------------------
  static String clasificarDepresion(int score) {
    if (score >= 14) return 'Extremadamente severa';
    if (score >= 11) return 'Severa';
    if (score >= 7) return 'Moderada';
    if (score >= 5) return 'Leve';
    return 'Sin depresión';
  }

  static String clasificarAnsiedad(int score) {
    if (score >= 10) return 'Extremadamente severa';
    if (score >= 8) return 'Severa';
    if (score >= 5) return 'Moderada';
    if (score >= 4) return 'Leve';
    return 'Sin ansiedad';
  }

  static String clasificarEstres(int score) {
    if (score >= 17) return 'Extremadamente severo';
    if (score >= 13) return 'Severo';
    if (score >= 10) return 'Moderado';
    if (score >= 8) return 'Leve';
    return 'Sin estrés';
  }

  // -----------------------
  // Helpers internos
  // -----------------------
  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    if (v is String) {
      final parsed = int.tryParse(v);
      if (parsed != null) return parsed;
      final pd = double.tryParse(v);
      if (pd != null) return pd.toInt();
    }
    return 0;
  }

  static String _formatTimestamp(dynamic ts) {
    try {
      if (ts == null) return '';
      if (ts is DateTime) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').format(ts);
      } else if (ts is Timestamp) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').format(ts.toDate());
      } else {
        // si es string u otro, intentar parsear o devolver tal cual
        String s = ts.toString();
        // si ya está en formato conocido
        if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(s)) return s;
        final tryParse = DateTime.tryParse(s);
        if (tryParse != null)
          return DateFormat('yyyy-MM-dd HH:mm:ss').format(tryParse);
        return s;
      }
    } catch (e) {
      return ts?.toString() ?? '';
    }
  }

  static List<AnswersUser> _snapshotToAnswers(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final timestamp = _formatTimestamp(data['timestamp']);
      return AnswersUser(
        userId: data['userId']?.toString() ?? '',
        timestamp: timestamp,
        p_depresion: _toInt(data['p_depresion']),
        p_ansiedad: _toInt(data['p_ansiedad']),
        p_estres: _toInt(data['p_estres']),
      );
    }).toList();
  }

  // -----------------------
  // Guardado
  // -----------------------
  static Future<void> saveDass21Results(
      Map<String, dynamic> results, String userId) async {
    DateTime now = DateTime.now();
    String timestampStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    AnswersUser newEntry = AnswersUser(
      userId: userId,
      timestamp: timestampStr,
      p_depresion: _toInt(results['depresion']),
      p_ansiedad: _toInt(results['ansiedad']),
      p_estres: _toInt(results['estres']),
    );

    // mantener historial local (opcional)
    answersHistory.add(newEntry);

    try {
      await _firestore.collection('answers').add({
        'timestamp': now, // guardamos DateTime/Timestamp
        'p_depresion': newEntry.p_depresion,
        'p_ansiedad': newEntry.p_ansiedad,
        'p_estres': newEntry.p_estres,
        'userId': userId,
      });

      // estructura optimizada por usuario (opcional)
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
        print("Warning: no se pudo guardar en user_answers: $e");
      }

      print("Datos DASS-21 guardados en Firestore correctamente.");
    } catch (e) {
      print("Error al guardar en Firestore: $e");
    }
  }

  // -----------------------
  // Lecturas
  // -----------------------
  /// Devuelve todos los resultados (admin)
  static Future<List<AnswersUser>> getAllAnswersFromFirestore() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('answers')
          .orderBy('timestamp', descending: true)
          .get();
      return _snapshotToAnswers(snapshot);
    } catch (e) {
      // fallback: intentar sin orderBy y luego ordenar localmente
      try {
        QuerySnapshot snapshot = await _firestore.collection('answers').get();
        List<AnswersUser> list = _snapshotToAnswers(snapshot);
        list.sort((a, b) {
          final da = DateTime.tryParse(a.timestamp) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final db = DateTime.tryParse(b.timestamp) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return db.compareTo(da);
        });
        return list;
      } catch (e2) {
        print("Error getAllAnswersFromFirestore fallback: $e2");
        return [];
      }
    }
  }

  /// Devuelve resultados del usuario especificado
  static Future<List<AnswersUser>> getAnswersFromFirestore(
      String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('answers')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      return _snapshotToAnswers(snapshot);
    } catch (e) {
      // fallback 1: sin ordenar
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('answers')
            .where('userId', isEqualTo: userId)
            .get();
        List<AnswersUser> list = _snapshotToAnswers(snapshot);
        list.sort((a, b) {
          final da = DateTime.tryParse(a.timestamp) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final db = DateTime.tryParse(b.timestamp) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return db.compareTo(da);
        });
        return list;
      } catch (e2) {
        // fallback 2: estructura por usuario
        try {
          QuerySnapshot snapshot = await _firestore
              .collection('user_answers')
              .doc(userId)
              .collection('results')
              .orderBy('timestamp', descending: true)
              .get();
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final timestamp = _formatTimestamp(data['timestamp']);
            return AnswersUser(
              userId: userId,
              timestamp: timestamp,
              p_depresion: _toInt(data['p_depresion']),
              p_ansiedad: _toInt(data['p_ansiedad']),
              p_estres: _toInt(data['p_estres']),
            );
          }).toList();
        } catch (e3) {
          print("Error getAnswersFromFirestore fallback: $e3");
          return [];
        }
      }
    }
  }

  /// Historial local (opcional)
  static List<AnswersUser> getAnswers() => answersHistory;
}
