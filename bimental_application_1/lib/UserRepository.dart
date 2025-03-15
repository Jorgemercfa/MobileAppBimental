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
}
