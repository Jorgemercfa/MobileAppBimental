import 'package:bimental_application_1/AnswersRepository.dart';
import 'package:bimental_application_1/dass_21_api.dart';

class ManageAnswers {
  // Índices de las preguntas para cada categoría (si los necesitas localmente)
  static const List<int> depresionIndices = [3, 5, 10, 13, 16, 17, 21];
  static const List<int> ansiedadIndices = [2, 4, 7, 9, 15, 19, 20];
  static const List<int> estresIndices = [1, 6, 8, 11, 12, 14, 18];

  static final Dass21Api apiDass21 = Dass21Api();

  /// Procesa las respuestas usando la API y guarda los resultados en Firestore
  static Future<Map<String, dynamic>> handleDass21Results(
      List<String> userAnswers, String userId) async {
    // Llama a la API para procesar las respuestas
    final dassResults = await apiDass21.processAnswers(userAnswers);
    // dassResults = {depresion: X, ansiedad: Y, estres: Z}

    // Guarda en Firestore (AnswersRepository se encarga)
    await AnswersRepository.saveDass21Results(dassResults, userId);

    // Preparar respuesta en el formato que usa la app (puntajes + clasificación)
    final dep = (dassResults['depresion'] ?? 0) is int
        ? dassResults['depresion']
        : (dassResults['depresion'] is num
            ? (dassResults['depresion'] as num).toInt()
            : 0);
    final ans = (dassResults['ansiedad'] ?? 0) is int
        ? dassResults['ansiedad']
        : (dassResults['ansiedad'] is num
            ? (dassResults['ansiedad'] as num).toInt()
            : 0);
    final est = (dassResults['estres'] ?? 0) is int
        ? dassResults['estres']
        : (dassResults['estres'] is num
            ? (dassResults['estres'] as num).toInt()
            : 0);

    return {
      'p_depresion': dep,
      'p_ansiedad': ans,
      'p_estres': est,
      'clasificacion': {
        'Depresión': AnswersRepository.clasificarDepresion(dep),
        'Ansiedad': AnswersRepository.clasificarAnsiedad(ans),
        'Estrés': AnswersRepository.clasificarEstres(est),
      }
    };
  }
}
