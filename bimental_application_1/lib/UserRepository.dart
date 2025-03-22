import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'User.dart';

class UserRepository {
  static final UserRepository instance = UserRepository._internal();
  final Uuid _uuid = Uuid(); // Instancia de UUID

  factory UserRepository() {
    return instance;
  }

  UserRepository._internal();

  List<User> users = [];

  Future<void> addUser(User newUser) async {
    newUser.id = _generateUniqueId();
    // users.add(newUser);
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('users').add({
      'id': newUser.id,
      'name': newUser.name,
      'email': newUser.email,
      'phone': newUser.phone,
      'password': newUser.password
    });
    print("Se ha registrado el usuario: ${docRef.id}, ");
  }

  String _generateUniqueId() {
    return _uuid.v4(); // Genera un UUID único
  }

  Future<List<User>> getUsers() async {
    // return users;
    List<User> usersRegistered = [];
    await FirebaseFirestore.instance.collection("users").get().then((event) {
      for (var doc in event.docs) {
        var userInfo = doc.data();
        User user = User(userInfo["id"], userInfo["name"], userInfo["email"],
            userInfo["password"], userInfo["phone"]);
        print("${doc.id} => ${doc.data()}");

        usersRegistered.add(user);
      }
    });
    print(usersRegistered);
    return usersRegistered;
  }

  Future<bool> updatePassword(String email, String newPassword) async {
    try {
      // Buscar usuario en Firestore por email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;

        // Actualizar contraseña en Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .update({"password": newPassword});

        return true; // Contraseña actualizada correctamente
      } else {
        return false; // Usuario no encontrado
      }
    } catch (e) {
      print("Error al actualizar la contraseña: $e");
      return false;
    }
  }

  Future<bool> updateUserData(String email, String name, String phone) async {
    try {
      print("Buscando usuario con email: $email");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        print("Usuario encontrado con ID: $userId");

        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .update({
          "name": name,
          "phone": phone,
        });

        print("Datos actualizados correctamente");
        return true; // Datos actualizados correctamente
      } else {
        print("Usuario no encontrado");
        return false; // Usuario no encontrado
      }
    } catch (e) {
      print("Error al actualizar los datos: $e");
      return false;
    }
  }
}
