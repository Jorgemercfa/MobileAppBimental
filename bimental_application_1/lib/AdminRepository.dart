import 'package:bimental_application_1/Administrators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRepository {
  static final AdminRepository instance = AdminRepository._internal();

  factory AdminRepository() {
    return instance;
  }

  AdminRepository._internal();

  // Inicializando la lista con credenciales predeterminadas
  List<Administrators> administrators = [];

  Future<List<Administrators>> getAdmins() async {
    List<Administrators> AdminRegistered = [];
    await FirebaseFirestore.instance
        .collection("administrators")
        .get()
        .then((event) {
      for (var doc in event.docs) {
        var adminInfo = doc.data();
        Administrators administrators = Administrators(
            adminInfo["id"], adminInfo["email"], adminInfo["password"]);
        print("${doc.id} => ${doc.data()}");

        AdminRegistered.add(administrators);
      }
    });
    return AdminRegistered;
  }

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
