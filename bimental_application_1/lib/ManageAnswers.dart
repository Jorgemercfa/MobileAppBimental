import 'package:bimental_application_1/AnswersRepository.dart';
import 'package:bimental_application_1/dass_21_api.dart';

class ManageAnswers {
  // Índices de las preguntas para cada categoría
  static const List<int> depresionIndices = [3, 5, 10, 13, 16, 17, 21];
  static const List<int> ansiedadIndices = [2, 4, 7, 9, 15, 19, 20];
  static const List<int> estresIndices = [1, 6, 8, 11, 12, 14, 18];

  static Dass21Api apiDass21 = Dass21Api();

  /// Procesa las respuestas usando la API y luego guarda los resultados en el repositorio.
  ///
  /// [userAnswers]: Lista de respuestas de usuario (List<String>)
  /// [userId]: ID del usuario
  static Future<Map<String, dynamic>> handleDass21Results(
      List<String> userAnswers, String userId) async {
    final dassResults = await apiDass21.processAnswers(userAnswers);
    // dassResults es {depresion: X, ansiedad: Y, estres: Z}

    // Guardar en AnswersRepository (puedes cambiar el método si tu repositorio requiere otro formato)
    await AnswersRepository.saveDass21Results(dassResults, userId);

    // Clasifica los resultados (puedes reusar la lógica previa)
    String clasificarDepresion(int score) {
      if (score >= 14) return 'Extremadamente severa';
      if (score >= 11) return 'Severa';
      if (score >= 7) return 'Moderada';
      if (score >= 5) return 'Leve';
      return 'Sin depresión';
    }

    String clasificarAnsiedad(int score) {
      if (score >= 10) return 'Extremadamente severa';
      if (score >= 8) return 'Severa';
      if (score >= 5) return 'Moderada';
      if (score >= 4) return 'Leve';
      return 'Sin ansiedad';
    }

    String clasificarEstres(int score) {
      if (score >= 17) return 'Extremadamente severo';
      if (score >= 13) return 'Severo';
      if (score >= 10) return 'Moderado';
      if (score >= 8) return 'Leve';
      return 'Sin estrés';
    }

    final sumaDepresion = dassResults['depresion'];
    final sumaAnsiedad = dassResults['ansiedad'];
    final sumaEstres = dassResults['estres'];

    return {
      'p_depresion': sumaDepresion,
      'p_ansiedad': sumaAnsiedad,
      'p_estres': sumaEstres,
      'clasificacion': {
        'Depresión': clasificarDepresion(sumaDepresion),
        'Ansiedad': clasificarAnsiedad(sumaAnsiedad),
        'Estrés': clasificarEstres(sumaEstres),
      }
    };
  }
}
