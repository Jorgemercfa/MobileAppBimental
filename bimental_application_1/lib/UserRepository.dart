import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'User.dart';
import 'session_service.dart';

class UserRepository {
  static final UserRepository instance = UserRepository._internal();
  final Uuid _uuid = Uuid();

  factory UserRepository() {
    return instance;
  }

  UserRepository._internal();

  List<User> users = [];

  Future<String> addUser(User newUser) async {
    try {
      final userId = _generateUniqueId();
      final userData = {
        'id': userId,
        'name': newUser.name,
        'lastName': newUser.lastName,
        'email': newUser.email,
        'phone': newUser.phone,
        'password': newUser.password
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(userData);

      print("Usuario registrado con ID: $userId");
      return userId;
    } catch (e) {
      print("Error al registrar usuario: $e");
      throw Exception("Error al registrar usuario: $e");
    }
  }

  String _generateUniqueId() {
    return _uuid.v4();
  }

  Future<List<User>> getUsers() async {
    List<User> usersRegistered = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (var doc in snapshot.docs) {
        final userInfo = doc.data() as Map<String, dynamic>;

        // Validación completa de campos
        final user = User(
          _validateField(userInfo['id']),
          _validateField(userInfo['name'], defaultValue: 'Desconocido'),
          _validateField(userInfo['lastName']),
          _validateField(userInfo['email']),
          _validateField(userInfo['password']),
          _validateField(userInfo['phone']),
        );

        print("Usuario recuperado: ${user.toString()}");
        usersRegistered.add(user);
      }
    } catch (e) {
      print("Error al obtener usuarios: $e");
      throw Exception("Error al obtener usuarios: $e");
    }
    return usersRegistered;
  }

  // Método auxiliar para validar campos
  String _validateField(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  Future<bool> updatePassword(String email, String newPassword) async {
    try {
      if (email.isEmpty || newPassword.isEmpty) {
        print("updatePassword: email o contraseña vacíos");
        return false;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return false;

      await querySnapshot.docs.first.reference
          .update({"password": newPassword});

      return true;
    } catch (e) {
      print("Error al actualizar contraseña: $e");
      return false;
    }
  }

  /// 🔹 Método clásico: requiere todos los campos
  Future<bool> updateUserData(
      String email, String name, String lastName, String phone) async {
    try {
      if (email.isEmpty) {
        print("updateUserData: email vacío");
        return false;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return false;

      await querySnapshot.docs.first.reference
          .update({"name": name, "lastName": lastName, "phone": phone});

      return true;
    } catch (e) {
      print("Error al actualizar datos: $e");
      return false;
    }
  }

  /// 🔹 Nuevo método: solo actualiza los campos enviados en [nuevosDatos]
  /// Ahora intenta identificar al usuario por (1) uid en el mapa, (2) id en SessionService,
  /// (3) uid de FirebaseAuth, o (4) email; no lanza excepción visible.
  Future<bool> updateUserDataMap(Map<String, dynamic> nuevosDatos) async {
    try {
      if (nuevosDatos.isEmpty) {
        print("updateUserDataMap: no se enviaron datos para actualizar");
        return false;
      }

      // Prioridad: uid (map) > SessionService user_id > firebaseAuth.uid
      String? uid = nuevosDatos['uid']?.toString();
      String? email = nuevosDatos['email']?.toString();

      // Intentar obtener id/email desde session si no vienen en el mapa
      if ((uid == null || uid.isEmpty)) {
        final sessionId = await SessionService.getUserId();
        if (sessionId != null && sessionId.isNotEmpty) {
          uid = sessionId;
        }
      }
      if ((email == null || email.isEmpty)) {
        final sessionEmail = await SessionService.getUserEmail();
        if (sessionEmail != null && sessionEmail.isNotEmpty) {
          email = sessionEmail;
        }
      }

      // Si todavía no hay, usar FirebaseAuth currentUser
      final fb_auth.User? firebaseUser =
          fb_auth.FirebaseAuth.instance.currentUser;
      if ((uid == null || uid.isEmpty) && firebaseUser != null) {
        uid = firebaseUser.uid;
      }
      if ((email == null || email.isEmpty) && firebaseUser?.email != null) {
        email = firebaseUser!.email;
      }

      if ((uid == null || uid.isEmpty) && (email == null || email.isEmpty)) {
        print("updateUserDataMap: no se encontró identificador (uid/email)");
        return false;
      }

      DocumentReference? docRef;

      // Si tenemos uid: intentar localizar por campo 'id' o por docId == uid
      if (uid != null && uid.isNotEmpty) {
        final byIdSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("id", isEqualTo: uid)
            .limit(1)
            .get();
        if (byIdSnapshot.docs.isNotEmpty) {
          docRef = byIdSnapshot.docs.first.reference;
        } else {
          // intentar doc con id == uid
          final doc = FirebaseFirestore.instance.collection("users").doc(uid);
          final docSnap = await doc.get();
          if (docSnap.exists) {
            docRef = doc;
          }
        }
      }

      // Si no se encontró por uid, intentar buscar por email
      if (docRef == null && email != null && email.isNotEmpty) {
        final q = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: email)
            .limit(1)
            .get();
        if (q.docs.isNotEmpty) {
          docRef = q.docs.first.reference;
        }
      }

      if (docRef == null) {
        print(
            "updateUserDataMap: no se encontró documento de usuario para actualizar");
        return false;
      }

      // No queremos sobreescribir identificadores a menos que se quiera cambiar
      Map<String, dynamic> datosActualizados = Map.from(nuevosDatos);
      datosActualizados.remove("email");
      datosActualizados.remove("uid");

      if (datosActualizados.isEmpty) {
        // Si no hay nada que actualizar, devolver true (operación sin cambios)
        print(
            "updateUserDataMap: nada que actualizar (solo identificador enviado)");
        return true;
      }

      await docRef.update(datosActualizados);

      return true;
    } catch (e) {
      print("Error al actualizar datos con mapa: $e");
      return false;
    }
  }
}
