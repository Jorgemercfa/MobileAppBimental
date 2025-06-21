import 'package:cloud_firestore/cloud_firestore.dart';
import 'Administrators.dart';

class AdminRepository {
  static final AdminRepository instance = AdminRepository._internal();

  factory AdminRepository() {
    return instance;
  }

  AdminRepository._internal();

  List<Administrators> administrators = [];

  /// Obtiene la lista de administradores desde Firestore
  Future<List<Administrators>> getAdmins() async {
    List<Administrators> adminRegistered = [];
    await FirebaseFirestore.instance
        .collection("administrators")
        .get()
        .then((event) {
      for (var doc in event.docs) {
        var adminInfo = doc.data();
        // Usa fromMap para asignar los campos
        Administrators admin = Administrators.fromMap(adminInfo);
        print("${doc.id} => ${doc.data()}");
        adminRegistered.add(admin);
      }
    });
    return adminRegistered;
  }

  /// Actualiza la contraseña del administrador por correo
  Future<bool> updatePassword(String email, String newPassword) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("administrators")
        .where("email", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;

      await FirebaseFirestore.instance
          .collection("administrators")
          .doc(docId)
          .update({"password": newPassword});
      return true;
    } else {
      return false;
    }
  }
}
