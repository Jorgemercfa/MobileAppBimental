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

  addUser(User newUser) {
    newUser.id = _generateUniqueId();
    users.add(newUser);
  }

  String _generateUniqueId() {
    return _uuid.v4(); // Genera un UUID único
  }

  getUsers() {
    return users;
  }
}
