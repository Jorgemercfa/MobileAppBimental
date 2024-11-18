import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonDbService {
  // Obtiene el path local del directorio de almacenamiento.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Obtiene el archivo local db.json.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/db.json');
  }

  // Inicializa la base de datos si no existe.
  Future<void> initDb() async {
    final file = await _localFile;
    if (!(await file.exists())) {
      await file.writeAsString(json.encode({"usuarios": []}));
    }
  }

  // Lee la lista de usuarios desde db.json.
  Future<List<Map<String, String>>> readUsuarios() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      Map<String, dynamic> jsonData = json.decode(contents);
      return List<Map<String, String>>.from(jsonData["usuarios"]);
    } catch (e) {
      print("Error leyendo db.json: $e");
      return [];
    }
  }

  // Escribe la lista de usuarios en db.json.
  Future<void> writeUsuarios(List<Map<String, String>> usuarios) async {
    final file = await _localFile;
    await file.writeAsString(json.encode({"usuarios": usuarios}));
  }

  // Agrega un nuevo usuario a la base de datos.
  Future<void> agregarUsuario(Map<String, String> usuario) async {
    List<Map<String, String>> usuarios = await readUsuarios();
    usuarios.add(usuario);
    await writeUsuarios(usuarios);
  }
}
